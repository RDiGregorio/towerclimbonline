import 'dart:convert';
import 'dart:html';

import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:towerclimbonline/client.dart';
import 'package:towerclimbonline/component/action_modal.dart';
import 'package:towerclimbonline/component/actions_component.dart';
import 'package:towerclimbonline/component/camera_component.dart';
import 'package:towerclimbonline/component/channel_modal.dart';
import 'package:towerclimbonline/component/confirm_modal.dart';
import 'package:towerclimbonline/component/console_component.dart';
import 'package:towerclimbonline/component/crafting_modal.dart';
import 'package:towerclimbonline/component/customize_modal.dart';
import 'package:towerclimbonline/component/examine_item_modal.dart';
import 'package:towerclimbonline/component/exchange_modal.dart';
import 'package:towerclimbonline/component/floor_input_modal.dart';
import 'package:towerclimbonline/component/high_scores_modal.dart';
import 'package:towerclimbonline/component/int_input_modal.dart';
import 'package:towerclimbonline/component/item_modal.dart';
import 'package:towerclimbonline/component/login_component.dart';
import 'package:towerclimbonline/component/mini_map_component.dart';
import 'package:towerclimbonline/component/option_modal.dart';
import 'package:towerclimbonline/component/recovery_component.dart';
import 'package:towerclimbonline/component/shop_modal.dart';
import 'package:towerclimbonline/component/stats_modal.dart';
import 'package:towerclimbonline/component/string_input_modal.dart';
import 'package:towerclimbonline/component/text_modal.dart';
import 'package:towerclimbonline/component/trade_modal.dart';
import 'package:towerclimbonline/content.dart';
import 'package:towerclimbonline/util.dart';

@Component(
    selector: 'game-component',
    directives: [
      coreDirectives,
      formDirectives,
      LoginComponent,
      RecoveryComponent,
      CameraComponent,
      ConsoleComponent,
      ActionsComponent,
      MiniMapComponent,
      IntInputModal,
      StringInputModal,
      FloorInputModal,
      ConfirmModal,
      ShopModal,
      ActionModal,
      ChannelModal,
      CraftingModal,
      CustomizeModal,
      ExchangeModal,
      HighScoresModal,
      ItemModal,
      ExamineItemModal,
      OptionModal,
      TradeModal,
      StatsModal,
      TextModal
    ],
    templateUrl: 'game_component.html')
class GameComponent {
  GameComponent() {
    ClientGlobals.currentView = 'login';
    registerItems(const {});
    Crafting.init();
  }

  String? get inputModalTitle => ClientGlobals.currentInputModalTitle;

  String get inputModalType {
    if (ClientGlobals.currentInputModal == 'teleport') return 'teleport';
    if (ClientGlobals.currentInputModal == 'examine') return 'examine';
    if (ClientGlobals.currentInputModal == 'text') return 'text';

    return ClientGlobals.currentInputModal == 'confirm'
        ? 'confirm'
        : const [
            'add contact',
            'add ignore',
            'add mod',
            'add owner',
            'create channel',
            'join channel',
            'kick user',
            'remove contact',
            'remove ignore',
            'remove mod',
            'remove owner'
          ].contains(ClientGlobals.currentInputModal)
            ? 'string'
            : 'int';
  }

  String? get modal => ClientGlobals.currentModal;

  String? get modalTitle => ClientGlobals.currentModalTitle;

  String? get view => ClientGlobals.currentView;

  void handleClose() {
    if (ClientGlobals.currentModal == 'customize')
      ClientGlobals.session!.remote(#customize, [
        json.encode(ClientGlobals.session!.doll!.customization,
            toEncodable: mapWrapperEncoder)
      ]);

    ClientGlobals.currentModalTitle = null;
    ClientGlobals.currentModal = null;
    ClientGlobals.clickedActionIndex = null;
    ClientGlobals.session!.remote(#handleClosedModal, const []);
  }

  void reload(bool login) {
    if (!login) window.localStorage[ClientGlobals.preventLoginCookie!] = 'true';
    window.location.reload();
  }
}
