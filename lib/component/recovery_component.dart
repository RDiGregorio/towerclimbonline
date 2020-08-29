import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:towerclimbonline/client.dart';

@Component(
    selector: 'recovery-component',
    directives: [coreDirectives, formDirectives],
    templateUrl: 'recovery_component.html')
class RecoveryComponent {
  String username = '', code = '', password = '', message = '';
  bool showPassword = false, sent = false, error = false;

  void cancel() {
    ClientGlobals.currentView = 'login';
  }

  void recover() {
    ClientGlobals.session
        .remote(#login, [null, username, null, false, code, password]).then(
            (result) => result
                ? ClientGlobals.currentView = 'game'
                : message = 'invalid recovery code');
  }

  void send() {
    ClientGlobals.session.remote(#sendRecoveryEmail, [username]).then(
        (result) => result ? sent = true : error = true);
  }
}
