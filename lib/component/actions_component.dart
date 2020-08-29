import 'dart:html';
import 'dart:math';

import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:towerclimbonline/client.dart';
import 'package:towerclimbonline/component/mini_map_component.dart';
import 'package:towerclimbonline/util.dart';

@Component(
    selector: 'actions-component',
    directives: [coreDirectives, formDirectives, MiniMapComponent],
    templateUrl: 'actions_component.html',
    changeDetection: ChangeDetectionStrategy.OnPush)
class ActionsComponent {
  bool showMenu = false;
  final Map<String, String> eraserStyle = {};
  final List<String> _actions = List.filled(100, null);
  final List<String> buffs = [];
  String _pressed = '';
  int _hp = 0, _mp = 0, _maxHp = 0, _maxMp = 0;

  final List<int> _keys = const [
    KeyCode.ONE,
    KeyCode.TWO,
    KeyCode.THREE,
    KeyCode.FOUR,
    KeyCode.FIVE,
    KeyCode.SIX,
    KeyCode.SEVEN,
    KeyCode.EIGHT,
    KeyCode.NINE,
    KeyCode.ZERO
  ];

  final ChangeDetectorRef _changeDetectorRef;

  ActionsComponent(this._changeDetectorRef) {
    animationLoop(() {
      _changeDetectorRef.markForCheck();

      buffs
        ..clear()
        ..addAll(ClientGlobals.session?.buffs?.keys?.map(_buffDescription) ??
            const []);
    });

    // Explains the game to new players.

    until(() => ClientGlobals.session?.flags != null).then((result) {
      ClientGlobals.currentModalMessage = [
        '<p>Your goal is to reach the top of the tower.</p>',
        '<p>Defeating a floor\'s boss unlocks the next floor.</p>',
        '<p>You are given a time bonus for being offline, which multiplies experience and item rewards, so there is no advantage to playing many hours a day.</p>'
      ].join('');

      if (!ClientGlobals.session.getFlag('read guide')) {
        showInputModal(
            'Information',
            'text',
            (result) =>
                ClientGlobals.session.remote(#setFlag, ['read guide', true]));

        querySelector('#input-modal-toggle')?.click();
      }
    });

    if (ClientGlobals.session == null) return;

    // Inputs are focused if the key isn't enter or numeric.

    window.onKeyDown.forEach((event) {
      if (event.keyCode == KeyCode.ESC) {
        document.activeElement.blur();
        hideModal();
        return;
      }

      if (document.activeElement is InputElement) return;

      if (event.keyCode == KeyCode.ENTER) {
        var element = querySelector('#conversation-ok');

        if (element != null) {
          element.click();
          return;
        }
      }

      if (showingModal('#input-modal')) {
        querySelector('#input-modal input').focus();
        return;
      }

      var index = _keys.indexOf(event.keyCode);

      if (index != -1) {
        var action = ClientGlobals.session?.actions[index];
        if (action != null) handleActionClick(action, index);
        return;
      }

      querySelector('input').focus();
    });

    ClientGlobals.session.internal
      ..getEvents(type: 'change', path: const ['actions']).forEach((event) =>
          event.path.length < 2
              ? ClientGlobals.session.actions
                  .forEach((key, value) => _actions[key] = value)
              : _actions[int.parse(event.path[1])] = event.data['value']);
  }

  Iterable<String> get actions =>

      // Actions are reduced for performance.

      _actions.take(window.innerWidth ~/ 70);

  bool get canPvP => ClientGlobals.session.canPvP ?? false;

  int get floor {
    var stage = ClientGlobals.session?.stage;

    if (stage == null ||
        stage.startsWith('tutorial') ||
        stage.startsWith('bonus')) return 0;

    return parseInteger(
            RegExp(r'\d+').firstMatch(ClientGlobals.session.stage).group(0)) +
        1;
  }

  int get foodEaten => ClientGlobals.session?.doll?.foodEaten ?? 0;

  int get fps => ClientGlobals.fps;

  BigInt get gold => ClientGlobals.session.gold;

  Map<String, String> get goldStyle => const {};

  int get hp {
    var result = ClientGlobals.session?.doll?.health;
    return result == null ? _hp : _hp = result;
  }

  int get maxHp {
    var result = ClientGlobals.session?.doll?.maxHealth;
    return result == null ? _maxHp : _maxHp = result;
  }

  int get maxMp {
    var result = ClientGlobals.session?.doll?.maxEnergy;
    return result == null ? _maxMp : _maxMp = result;
  }

  int get mp {
    var result = ClientGlobals.session?.doll?.energy;
    return result == null ? _mp : _mp = result;
  }

  List<String> get pendingActions => ClientGlobals.session.pendingActions;

  int get progress {
    try {
      var sheet = ClientGlobals.session?.sheet;
      if (sheet == null) return 0;
      var level = sheet.internal[progressDisplay ?? 'combat'];

      return small(level == null
          ? BigInt.zero
          : (level.experience - level.previousLevelExperience) *
              BigInt.from(100) ~/
              (level.nextLevelExperience - level.previousLevelExperience));
    } catch (error) {
      // Caused by very large numbers.

      return 0;
    }
  }

  String get progressDisplay {
    var map = ClientGlobals.session?.options;
    if (map == null) return null;
    return map['progress'];
  }

  int get remainingTimeBonus =>
      (ClientGlobals.session?.timeBonusEnd ?? 0) - now;

  String get remainingTimeBonusSeconds =>
      formatNumber(max<int>(0, remainingTimeBonus ~/ 1000));

  String get restartTime {
    var time = ClientGlobals.session?.restartTime ?? 0;
    if (time == 0) return '';

    var seconds =
        formatNumber(max<int>(0, Duration(milliseconds: time - now).inSeconds));

    if (seconds == '0') return '';
    return 'update in ' + '$seconds seconds';
  }

  bool get showFps {
    var map = ClientGlobals.session?.options;
    if (map == null) return false;
    return map['show fps'] ?? false;
  }

  String actionClasses(String action) {
    var result = '';
    if (action == null || action == '') return 'btn-default';

    if (equipped(action)) {
      result += pendingActions.contains(action) || _pressed == action
          ? 'btn-primary active'
          : 'btn-primary';

      if (doubleEquipped(action)) result += ' yellow-text';
      return result;
    }

    result += pendingActions.contains(action) || _pressed == action
        ? 'btn-default active'
        : 'btn-default';

    return result;
  }

  String dataTarget(String action) =>
      eraserStyle.isEmpty && missingAction(action) ? '#action-modal' : '';

  String dataToggle(String action) =>
      eraserStyle.isEmpty && missingAction(action) ? 'modal' : '';

  /// The result is formatted for use on the action bar.

  String displayText(String action) {
    var result = '';
    if (action == null || action == '') return result;

    if (hasAbility(action))
      result = action;
    else if (hasItem(action))
      result =
          ClientGlobals.session.items.getItem(action).displayTextWithoutAmount;

    return addEllipsis(result);
  }

  bool doubleEquipped(String action) =>
      ClientGlobals.session.equipped['double equipped']?.id == action;

  bool equipped(String action) =>
      ClientGlobals.session.equipped?.containsKey(action) == true;

  String format(int value) => formatCurrency(max(0, value), false);

  String formatGold(dynamic value) => formatCurrency(value, true);

  void handleActionClick(String action, int index) {
    showMenu = false;

    if (eraserStyle.isEmpty) {
      ClientGlobals.clickedActionIndex = index;

      if (missingAction(action))
        showModal('Actions', 'actions');
      else if (hasItem(action))
        ClientGlobals.session.remote(#useItem, [action]);
      else if (hasAbility(action)) {
        if (action == 'teleport') {
          _closeAll();

          // Teleport is special cased because it requires arguments.

          showInputModal('Floor', 'teleport', (input) {
            _closeAll();

            ClientGlobals.session.remote(#teleport, [
              BigIntUtil.min(big(Session.maxFloor), parseBigInteger(input))
                  .toInt(),
              ClientGlobals.session.options['teleport mode'] == 'proc gen'
            ]);
          });

          querySelector('#input-modal-toggle')?.click();
          return;
        }

        _pressed = action;

        ClientGlobals.session
            .remote(#useAbility, [action]).then(_updatePressed);
      }
    } else
      ClientGlobals.session.remote(#setAction, [null, index]);
  }

  void handleEraserClick() {
    eraserStyle.isEmpty
        ? eraserStyle['color'] = 'rgb(255, 0, 0)'
        : eraserStyle.clear();
  }

  void handleMenuClick(String action) {
    showMenu = false;

    switch (action) {
      case 'logout':
        Future(() async {
          if (await ClientGlobals.session.remote(#logout, const [])) {
            window.localStorage
                .remove('towerclimbonline/${ClientGlobals.username}');

            reload();
          } else
            ClientGlobals.session.alert(alerts[#noCombat]);
        });

        return;
      case 'items':
        showModal('Items', action);
        return;
      case 'abilities':
        showModal('Abilities', action);
        return;
      case 'crafting':
        showModal('Crafting', action);
        return;
      case 'customize':
        showModal('Looks', action);
        return;
      case 'options':
        showModal('Options', action);
        return;
      case 'stats':
        showModal('Stats', action);
        return;
      case 'exchange':
        showModal('Exchange', action);
        return;
      case 'scores':
        showModal('Leaderboards', action);
        return;
    }

    throw ArgumentError(action);
  }

  void handleShowMenu() {
    if (!showMenu) _closeAll();
    showMenu = !showMenu;
  }

  bool hasAbility(String name) =>
      ClientGlobals.session.abilities?.containsKey(name) == true;

  bool hasItem(String id) {
    // FIXME: [hasItem] is taking 19% of the performance.

    if (id == null) return false;
    return ClientGlobals.session.items?.getItem(id) != null;
  }

  bool missingAction(String action) =>
      action == null || action == '' || !hasAbility(action) && !hasItem(action);

  String _buffDescription(String key) {
    num remainingEstimate = ClientGlobals.session.buffs[key]?.remainingMs ?? 0;

    Map<String, String> longDescription = {
      'regen': 'regenerating',
      'invisibility': '+100% stealth',
      'frozen': 'frozen',
      'poisoned': 'poisoned',
      'agi+': '+50% agility',
      'str+': '+50% strength',
      'dex+': '+50% dexterity',
      'int+': '+50% intelligence',
      'spd+': 'fast movement',
      'str-': '-50% strength',
      'dex-': '-50% dexterity',
      'int-': '-50% intelligence',
      'pker': 'player killer',
      'extra life': 'revived',
      'resist fire': 'resisting fire',
      'resist ice': 'resisting ice',
      'resist electric': 'resisting electric',
      'resist poison': 'resisting poison',
      'resist gravity': 'resisting gravity',
      'resist acid': 'resisting acid'
    };

    // the short description is used for resists.

    key = longDescription[key] ?? '[error] $key';

    if (remainingEstimate.isFinite)
      return key + ' (${formatNumber(remainingEstimate ~/ 1000)} seconds)';

    return key;
  }

  void _closeAll() {
    querySelectorAll('.modal-header button.close')
        ?.forEach((element) => element.click());
  }

  void _updatePressed(dynamic result) {
    Future.delayed(const Duration(milliseconds: 200))
        .then((result) => _pressed = '');
  }
}
