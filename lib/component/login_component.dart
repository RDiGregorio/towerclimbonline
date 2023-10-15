import 'dart:async';
import 'dart:html';

import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:towerclimbonline/client.dart';
import 'package:towerclimbonline/util.dart';

@Component(
    selector: 'login-component',
    directives: [coreDirectives, formDirectives],
    templateUrl: 'login_component.html')
class LoginComponent {
  String? username = '', password = '', captchaResponse = '';
  bool showPassword = false, newAccount = false, loginDisabled = false;
  int? _players;

  LoginComponent() {
    var cookies = List.from(window.localStorage.keys
        .where((key) => key.startsWith(RegExp('towerclimbonline/'))));

    if (cookies.isNotEmpty) {
      var list = List.from(cookies[0].split('/'));

      if (list.length == 2) {
        if (window.localStorage.containsKey(ClientGlobals.preventLoginCookie))
          window.localStorage.remove(ClientGlobals.preventLoginCookie);
        else {
          username = list[1];
          password = window.localStorage.remove(cookies[0]);
        }

        until(() => ready).then((result) {
          if (username != '' &&
              password != '' &&
              ClientGlobals.currentView != 'game') login();
        });
      } else
        clearCookies();
    }

    until(() => ClientGlobals.session != null).then((result) async => _players =
        await (ClientGlobals.session!.remote(#playersOnline, const [])
            as FutureOr<int?>));
  }

  String get message => ClientGlobals.loginMessage;

  String get players => 'players online: ${_players ?? ''}';

  bool get ready => ClientGlobals.session != null;

  void expire() {
    captchaResponse = '';

    Future(() async {
      await window.animationFrame;
    });
  }

  void login() {
    loginDisabled = true;

    if (ClientGlobals.session != null)
      Future(() async {
        if (await (ClientGlobals.session!.remote(
                #login, [captchaResponse, username, password, newAccount])
            as FutureOr<bool>)) {
          // Saving the cookie is delayed to allow alts in different browser
          // tabs to automatically log back in after updates.

          Future.delayed(const Duration(seconds: 1), () {
            ClientGlobals.username = username;
            return window.localStorage['towerclimbonline/$username'] =
                password!;
          });

          ClientGlobals.session!.internal
              .getEvents(type: 'end')
              .listen((event) {
            // An "end" event happens when a session is kicked because a player
            // logs in somewhere else (for example, when duplicating a browser
            // tab).

            ClientGlobals.currentView = 'end';
          });

          ClientGlobals.currentView = 'game';
        } else {
          ClientGlobals.loginMessage = newAccount
              ? 'username unavailable'
              : 'invalid username or password';
        }

        loginDisabled = false;
      });
  }

  void recaptcha(String response) {
    captchaResponse = response;
  }

  void recovery() {
    ClientGlobals.currentView = 'recovery';
  }

  void link(String url) => navigate(url);
}
