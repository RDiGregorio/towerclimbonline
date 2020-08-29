import 'dart:html';

import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:towerclimbonline/client.dart';
import 'package:towerclimbonline/util.dart';

@Component(
    selector: 'channel-modal',
    directives: [coreDirectives, formDirectives],
    templateUrl: 'channel_modal.html')
class ChannelModal {
  Iterable<String> get channelMods =>
      ClientGlobals.session.channelMods ?? const [];

  Iterable<String> get channelOwners =>
      ClientGlobals.session.channelOwners ?? const [];

  void addChannelMod() =>
      showInputModal('Add channel moderator', 'add mod', (user) {
        if (sanitizeName(user) == ClientGlobals.session.username)
          querySelector('button.close').click();

        return ClientGlobals.session.remote(#addChannelMod, [user]);
      });

  void addChannelOwner() => showInputModal('Add channel owner', 'add owner',
      (user) => ClientGlobals.session.remote(#addChannelOwner, [user]));

  void removeChannelMod() => showInputModal(
      'Remove channel moderator',
      'remove mod',
      (user) => ClientGlobals.session.remote(#removeChannelMod, [user]));

  void removeChannelOwner() =>
      showInputModal('Remove channel owner', 'remove owner', (user) {
        if (sanitizeName(user) == ClientGlobals.session.username)
          querySelector('button.close').click();

        return ClientGlobals.session.remote(#removeChannelOwner, [user]);
      });
}
