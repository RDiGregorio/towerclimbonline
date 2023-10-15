import 'dart:async';
import 'dart:html';

import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:logging/logging.dart';
import 'package:towerclimbonline/client.dart';
import 'package:towerclimbonline/component/game_component.dart';
import 'package:towerclimbonline/config.dart';
import 'package:towerclimbonline/util.dart';

@Component(
    selector: 'app-component',
    templateUrl: 'app_component.html',
    directives: [coreDirectives, formDirectives, GameComponent])
class AppComponent {
  WebSocket? socket;
  int? _players;
  String message = '';
  bool tooManyConnections = false;

  Map<String, String> get backgroundStyle => const {};

  String get currentPage => '${window.location}'.split('/').last;

  String get players {
    if (_players != null) return 'Players online: $_players';
    return message;
  }

  bool get showNav => currentPage != 'play';

  AppComponent() {
    Logger.root.level = Config.debug ? Level.INFO : Level.WARNING;

    Logger.root.onRecord
        .listen((LogRecord record) async => print('${record.message}'));

    init();
  }

  void init() {
    if (tooManyConnections) {
      message = ClientGlobals.loginMessage = 'too many connections';
      return;
    }

    ClientGlobals.session = null;

    Future(() async {
      message = ClientGlobals.loginMessage = 'connecting...';

      function() async {
        String host = Config.debug ? Config.debugHost : Config.host;

        socket = window.location.href.startsWith('https') || Config.app
            ? await getSecureSocket('www.towerclimbonline.com', Config.port + 1)
            : await getSocket(host, Config.port);

        if (socket == null) {
          message = ClientGlobals.loginMessage = 'unable to connect';
          Future(function);
        } else {
          socket!.onClose.first.then((event) {
            if (event.code == 4000) tooManyConnections = true;
          });

          ClientGlobals.loginMessage = '';
          _onConnect();
        }
      }

      function();
    });
  }

  void link(String url) => navigate(url);

  void _onConnect() {
    Future(() async {
      // Registers types.

      registerFactory(#ObservableEvent, () => ObservableEvent());
      registerFactory(#Session, () => Session());
      registerFactory(#Doll, () => Doll());
      registerFactory(#Item, () => Item());
      registerFactory(#ItemContainer, () => ItemContainer());
      registerFactory(#CharacterSheet, () => CharacterSheet());
      registerFactory(#Stat, () => Stat());
      registerFactory(#DollCustomization, () => DollCustomization());
      registerFactory(#CustomizationLayer, () => CustomizationLayer());
      registerFactory(#Buff, () => Buff());
      registerFactory(#ExchangeOffer, () => ExchangeOffer());

      ClientGlobals.session = Session()
        ..connect(socket)
        ..internal.getEvents(type: 'done').first.then((event) {
          // The delay allows navigating to other websites in Firefox.

          Future.delayed(Duration(seconds: 1), reload);
        });

      _updatePlayersOnline();
    });
  }

  Future<dynamic> _updatePlayersOnline() async {
    _players = await (ClientGlobals.session!.remote(#playersOnline, const []) as FutureOr<int?>);
  }
}
