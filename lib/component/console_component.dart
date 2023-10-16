import 'dart:async';
import 'dart:collection';
import 'dart:html';

import 'package:ngdart/angular.dart';
import 'package:ngforms/angular_forms.dart';
import 'package:quiver/collection.dart';
import 'package:towerclimbonline/client.dart';
import 'package:towerclimbonline/util.dart';

@Component(
    selector: 'console-component',
    directives: [coreDirectives, formDirectives],
    templateUrl: 'console_component.html',
    changeDetection: ChangeDetectionStrategy.onPush)
class ConsoleComponent {
  RegExp _timePattern = RegExp(r'\d+:\d+:\d+'),
      _accurateTimePattern = RegExp(r'\d+:\d+:\d+.\d+'),
      _datePattern = RegExp(r'\d+-\d+-\d+');

  String? input;
  bool _scroll = false;
  int unreadPublic = 0, unreadChannel = 0, unreadAlerts = 0, _messageCap = 20;
  final Map<String?, int> _unreadPrivate = {};
  final Map<String?, Queue<Map<String?, dynamic>?>> privateMessages = {};
  final Map<String, String> chatStyle = {};

  final Queue<Map<String?, dynamic>?> output = Queue(),
      _channelMessages = Queue(),
      alerts = Queue();

  final Set<String> ignore = Set();
  final ChangeDetectorRef _changeDetectorRef;

  ConsoleComponent(this._changeDetectorRef) {
    ClientGlobals.session!.alert('Type "/commands" for a list of commands.');

    ClientGlobals.session!.remote(
        #openChats, const []).then((chats) => chats.keys.forEach(openChat));

    animationLoop(() {
      if (ClientGlobals.session == null) return;

      // The width is set this way because of issues with iOS devices.

      chatStyle['width'] = '${window.innerWidth! - 152}px';

      if (ClientGlobals.currentModal != null)
        document.body!.classes.add('modal-open');

      if (!_scroll) return;
      var element = querySelector('.console-left-output');
      if (element != null) element.scrollTop = element.scrollHeight;
      _scroll = false;
    });

    // Note: events on dolls on the mini-map are duplicated.

    ClientGlobals.session!.internal
      ..getEvents(type: 'alert').forEach((ObservableEvent event) {
        event.data!['timestamp'] = timestamp;
        if (activePillId != 'alert-') unreadAlerts++;
        alerts.add(event.data);

        // Prevents lag from too many alerts.

        if (alerts.length > _messageCap) alerts.removeFirst();
        _autoScroll();
      })
      ..getEvents(type: 'prompt').forEach((ObservableEvent event) {
        ClientGlobals.currentModalMessage = event.data!['value'];

        // Closes any open prompts.

        querySelectorAll('.modal-header button.close')
            .forEach((element) => element.click());

        _closeModal();

        // Time is given to allow any open modals to close.

        Future.delayed(Duration(milliseconds: 100), () {
          showInputModal('Information', 'text', (result) => null);
          querySelector('#input-modal-toggle')?.click();
        });
      })
      ..getEvents(type: 'trade').forEach((event) {
        event.data!['timestamp'] = timestamp;

        output.add({
          'timestamp': timestamp,
          'type': 'trade',
          'from': event.data!['from'],
          'doll': event.data!['doll']
        });

        if (activePillId != 'chat-') unreadPublic++;
        _autoScroll();
      })
      ..getEvents(type: 'open trade').forEach((event) {
        _closeModal();

        // Time is given to allow any open modals to close.

        Future.delayed(Duration(milliseconds: 100), () {
          ClientGlobals.tradeAccepted = false;
          showModal('Trade with ${event.data!['from']}', 'trade');
          querySelector('#modal-toggle')!.click();
          _changeDetectorRef.markForCheck();
        });
      })
      ..getEvents(type: 'close modal').forEach((event) {
        _closeModal();
        _changeDetectorRef.markForCheck();
      })
      ..getEvents(type: 'change', path: ['shop']).forEach((event) {
        showModal('Shop', 'shop');
        querySelector('#modal-toggle')!.click();
        _changeDetectorRef.markForCheck();
      })
      ..getEvents(type: 'change').forEach((event) {
        // Ends the current conversation when you move.

        if (ClientGlobals.session!.doll != null &&
            listsEqual(
                event.path, ['view', ClientGlobals.session!.doll!.id, 'loc'])) {
          if (conversationMessages.isNotEmpty) conversationMessages.clear();
          if (conversationOptions.isNotEmpty) conversationOptions.clear();
        }

        _changeDetectorRef.markForCheck();
      })
      ..getEvents(type: 'change', path: ['ignore']).forEach((event) {
        event.path!.length > 1
            ? event.data!['value'] == true
                ? ignore.add(event.path![1])
                : ignore.remove(event.path![1])
            : ignore.addAll(event.data!['value'].keys);

        _autoScroll();
      })
      ..getEvents(type: 'private chat').forEach((event) {
        event.data!['timestamp'] = timestamp;
        var user = event.data!['from'];

        if (!privateMessages.containsKey(user))
          openChat(user);
        else
          (privateMessages[user] ??= Queue()).add(event.data);

        if (privateMessages.length > _messageCap)
          privateMessages.remove(privateMessages.keys.first);

        if (activePillId != 'chat-$user') increaseUnreadPrivate(user);
        _autoScroll();
      })
      ..getEvents(type: 'channel chat').forEach((event) {
        event.data!['timestamp'] =
            _timestamp(DateTime.fromMillisecondsSinceEpoch(event.data!['time']));

        _channelMessages.add(event.data);

        if (activePillId != 'group-chat' &&
            !ignore.contains(event.data!['from']) &&
            event.data!['historic'] != true) unreadChannel++;

        _autoScroll();
      })
      ..getEvents(type: 'public chat', path: ['view']).forEach((event) {
        event.data!['timestamp'] = timestamp;

        if (activePillId != 'chat-' && !ignore.contains(event.data!['from']))
          unreadPublic++;

        if (!ignore.contains(event.data!['from'])) {
          var doll = ClientGlobals.session!.internal
              .getPath(List<String>.from(event.path!));

          if (doll != null)
            doll
              ..messageTime = now
              ..message = event.data!['value'];
        }

        output.add(event.data);
        _autoScroll();
      });
  }

  String get activePillId => querySelector('.console-nav .active')!.id;

  String get channel => ClientGlobals.session!.channelName ?? '';

  Iterable<dynamic> get channelMessages {
    if (_channelMessages.length > _messageCap) _channelMessages.removeFirst();
    return _channelMessages;
  }

  Iterable<dynamic> get channelMods =>
      (ClientGlobals.session!.channelMods ?? const []) as Iterable<dynamic>;

  Iterable<dynamic> get channelOwners =>
      (ClientGlobals.session!.channelOwners ?? const []) as Iterable<dynamic>;

  Set<dynamic> get channelUsers {
    var users = ClientGlobals.session?.channel ?? const {};
    return Set.from(users.keys.where((key) => users[key] == true));
  }

  List<dynamic> get conversationMessages =>
      ClientGlobals.session!.conversationMessages ?? const [];

  List<dynamic> get conversationOptions =>
      ClientGlobals.session!.conversationOptions ?? const [];

  Iterable<dynamic> get offlineContacts => ClientGlobals.session!.contacts.keys
      .where((key) => !ClientGlobals.session!.contacts[key]);

  Iterable<dynamic> get onlineContacts => ClientGlobals.session!.contacts.keys
      .where((key) => ClientGlobals.session!.contacts[key]);

  List<dynamic> get sortedChannelUsers => List.from(channelUsers)..sort();

  String get timestamp => _timestamp(DateTime.now());

  void clickAlerts() {
    scroll();
    unreadAlerts = 0;
  }

  void clickChannel() {
    scroll();
    unreadChannel = 0;
  }

  void clickContact(String contact) {
    openChat(contact);
    showChat(contact);
  }

  void clickPrivate(String contact) {
    scroll();
    resetUnreadPrivate(contact);
  }

  void clickPublic() {
    scroll();
    unreadPublic = 0;
  }

  void closeChat(String user) {
    privateMessages.remove(user);
    ClientGlobals.session!.remote(#closeChat, [user]);

    // Shows the public chat.

    showChat('');
  }

  void conversationChoice([String? choice]) {
    choice == null
        ? ClientGlobals.session!.conversationMessages!.removeAt(0)
        : ClientGlobals.session!.remote(#conversationChoice, [choice]);
  }

  String formatCount(int count) => formatNumber(count ?? 0);

  int getUnreadPrivate(String key) => _unreadPrivate[key] ?? 0;

  void handleClick(String option) {
    // The input modal type (string or int) is determined by [inputModalType]
    // in [App].

    switch (option) {
      case 'add contact':
        showInputModal('Add contact', option,
            (user) => ClientGlobals.session!.remote(#addContact, [user]));
        return;
      case 'remove contact':
        showInputModal('Remove contact', option,
            (user) => ClientGlobals.session!.remote(#removeContact, [user]));
        return;
      case 'add ignore':
        showInputModal('Add ignore', option,
            (user) => ClientGlobals.session!.remote(#addIgnore, [user]));
        return;
      case 'remove ignore':
        showInputModal('Remove ignore', option,
            (user) => ClientGlobals.session!.remote(#removeIgnore, [user]));
        return;
      case 'join channel':
        showInputModal('Join channel', option, (channel) async {
          await (ClientGlobals.session!.remote(#joinChannel, [channel]) as FutureOr<bool>)
              ? _showChannel()
              : ClientGlobals.session!.alert('You can\'t join that channel.');
        });
        return;
      case 'create channel':
        showInputModal('Create channel', option, (channel) async {
          if (await (ClientGlobals.session!.remote(#createChannel, [channel]) as FutureOr<bool>)) {
            await ClientGlobals.session!.remote(#joinChannel, [channel]);
            _showChannel();
          }
        });

        return;
      case 'kick user':
        showInputModal('Kick user', option, (user) async {
          if (!await (ClientGlobals.session!.remote(#kickChannelUser, [user]) as FutureOr<bool>))
            ClientGlobals.session!.alert('You can\'t kick that player.');
        });
        return;
      case 'channel options':
        showModal('Channel options', option);
        return;
    }

    throw ArgumentError(option);
  }

  bool handleSubmit() {
    if (input == null || input!.isEmpty) return false;
    var id = querySelector('.console-left .active')!.id, list = id.split('-');

    // Handles commands

    if (input!.startsWith('/')) {
      ClientGlobals.session!.remote(#command, [input]);
      input = null;
      return false;
    }

    if (list[0] == 'alert') {
      ClientGlobals.session!.remote(#messagePublic, [input]);
      input = null;
      return false;
    }

    if (list[0] == 'chat') if (list[1].isEmpty)
      ClientGlobals.session!.remote(#messagePublic, [input]);
    else {
      openChat(list[1]);

      if (list[1] != ClientGlobals.session!.username)
        privateMessages[list[1]]!.add({
          'timestamp': timestamp,
          'from': ClientGlobals.session!.username,
          'value': input
        });

      _autoScroll();
      ClientGlobals.session!.remote(#messageContact, [list[1], input]);
    }
    else
      ClientGlobals.session!.remote(#messageChannel, [input]);

    input = null;
    return false;
  }

  void increaseUnreadPrivate(String? key) {
    var value = _unreadPrivate[key] ?? 0;
    _unreadPrivate[key] = value + 1;
  }

  bool isMod([String? user]) =>
      channelMods.contains(user ?? ClientGlobals.session!.username);

  bool isOwner([String? user]) =>
      channelOwners.contains(user ?? ClientGlobals.session!.username);

  void leaveChannel() {
    ClientGlobals.session!.remote(#leaveChannel);
    _channelMessages.clear();

    // Shows the public chat.

    showChat('');
  }

  void openChat(String? user) {
    if (privateMessages.containsKey(user)) return;
    privateMessages[user] = Queue();

    // Loads historic messages.

    Future(() async {
      Map<String?, dynamic> messageHistory =
          await (ClientGlobals.session!.remote(#privateMessages, [user]) as FutureOr<Map<String?, dynamic>>);

      messageHistory.forEach((key, data) {
        data['timestamp'] =
            _timestamp(DateTime.fromMillisecondsSinceEpoch(data['time']));

        privateMessages[user]!.add(data);
      });
    });
  }

  void removeContact(String user) {
    ClientGlobals.session!.remote(#removeContact, [user]);
  }

  void removeIgnore(String user) {
    ClientGlobals.session!.remote(#removeIgnore, [user]);
  }

  void resetUnreadPrivate(String key) {
    _unreadPrivate.remove(key);
  }

  void scroll() {
    _scroll = true;
  }

  void showChat(String user) {
    Future(() async {
      var element;

      // In rare cases it can take multiple cycles for the element to show up.

      await until(() => (element = querySelector('#chat-${user} a')) != null);
      element.click();
      _scroll = true;
      if (user == '') unreadPublic = 0;
    });
  }

  void trade(String dollId) {
    ClientGlobals.session!.remote(#openTrade, [dollId]);
  }

  void _autoScroll() {
    var element = querySelector('.console-left-output');

    if (element != null)
      _scroll = _scroll ||
          element.scrollHeight <= element.clientHeight + element.scrollTop + 1;

    _changeDetectorRef.markForCheck();
  }

  void _closeModal() {
    if (querySelector('.modal.in') != null) {
      querySelector('button.close')?.click();
      _changeDetectorRef.markForCheck();
    }
  }

  void _showChannel() {
    Future(() async {
      var element;

      // In rare cases it can take multiple cycles for the element to show up.

      await until(() => (element = querySelector('#group-chat a')) != null);
      element.click();
      _scroll = true;
      unreadChannel = 0;
    });
  }

  String _timestamp(DateTime date) {
    date = date.toUtc();

    return date.isBefore(DateTime.parse('${DateTime.now().toUtc()}'
            .replaceFirst(_accurateTimePattern, '00:00:00.000')))
        ? '[${_datePattern.firstMatch('$date')!.group(0)}]'
        : '[${_timePattern.firstMatch('$date')!.group(0)}]';
  }
}
