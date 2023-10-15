import 'dart:async';
import 'dart:js';

import 'package:ngdart/angular.dart';
import 'package:ngforms/angular_forms.dart';
import 'package:logging/logging.dart';
import 'package:towerclimbonline/client.dart';
import 'package:towerclimbonline/config.dart';
import 'package:towerclimbonline/util.dart';

@Component(
    selector: 'option-modal',
    directives: [coreDirectives, formDirectives],
    templateUrl: 'option_modal.html')
class OptionModal {
  static Future<dynamic>? _throttle;

  String oldPassword = '',
      newPassword = '',
      message = '',
      repeatNewPassword = '',
      newEmail = '',
      script = 'alert("hello world")';

  String get directMessages =>
      ClientGlobals.session!.options!['online status'] ?? 'on';

  void set directMessages(String mode) {
    ClientGlobals.session!.remote(#setOption, ['online status', mode]);
  }

  String get email => ClientGlobals.session!.email ?? 'none';

  int get lastEmailReset => ClientGlobals.session!.lastEmailReset ?? 0;

  num get mapSize {
    var map = ClientGlobals.session?.options ?? {};
    return map['map size'] ?? 100;
  }

  void set mapSize(dynamic value) {
    value = clamp(parseInteger(value)!, 100, 200);

    if (_throttle == null) {
      _throttle = Future.delayed(const Duration(milliseconds: 100), () {
        ClientGlobals.session?.remote(#setOption, ['map size', value]);
        _throttle = null;
      });
    }
  }

  String get pendingEmail => ClientGlobals.session!.pendingEmail ?? 'none';

  String get pendingReset {
    if (pendingEmail == 'none') return '';

    var result = DateTime.fromMillisecondsSinceEpoch(lastEmailReset)
        .add(Config.emailResetDelay)
        .difference(DateTime.now())
        .inHours;

    return '(${formatNumber(result)} hours)';
  }

  String get petAggro {
    var result = ClientGlobals.session!.options!['pet aggro'] ?? false;
    return result ? 'on' : 'off';
  }

  void set petAggro(String mode) {
    ClientGlobals.session!.remote(#setOption, ['pet aggro', mode == 'on']);
  }

  String get progressDisplay =>
      ClientGlobals.session!.options!['progress'] ?? 'combat';

  void set progressDisplay(String mode) {
    ClientGlobals.session!.remote(#setOption, ['progress', mode]);
  }

  String get showEvasionPercent {
    var result = ClientGlobals.session!.options!['ev percent'] ?? false;
    return result ? 'on' : 'off';
  }

  void set showEvasionPercent(String mode) {
    ClientGlobals.session!.remote(#setOption, ['ev percent', mode == 'on']);
  }

  String get showEvents {
    var result = ClientGlobals.session!.options!['show splats'] ?? true;
    return result ? 'on' : 'off';
  }

  void set showEvents(String mode) {
    ClientGlobals.session!.remote(#setOption, ['show splats', mode == 'on']);
  }

  String get showFps {
    var result = ClientGlobals.session!.options!['show fps'] ?? false;
    return result ? 'on' : 'off';
  }

  void set showFps(String mode) {
    ClientGlobals.session!.remote(#setOption, ['show fps', mode == 'on']);
  }

  String get stealth {
    var result = ClientGlobals.session!.options!['stealth'] ?? true;
    return result ? 'on' : 'off';
  }

  void set stealth(String mode) {
    ClientGlobals.session!.remote(#setOption, ['stealth', mode == 'on']);
  }

  num get zoom => ClientGlobals.zoom;

  void set zoom(dynamic value) {
    ClientGlobals.zoom = value;
  }

  void changePassword() {
    Future(() async {
      if (await (ClientGlobals.session!
          .remote(#setPassword, [oldPassword, newPassword]) as FutureOr<bool>)) {
        message = 'success';
        oldPassword = '';
        newPassword = '';
        repeatNewPassword = '';
        return;
      }

      message = 'error';
    });
  }

  void loop() {
    Future.delayed(const Duration(milliseconds: ServerGlobals.tickDelay), () {
      runZoned(run, onError: (error, trace) {
        Logger.root.severe(error);
        Logger.root.severe(trace);
      });

      loop();
    });
  }

  void run() {
    context.callMethod('eval', [script]);
  }

  void updateEmail() {
    ClientGlobals.session!.remote(#setOption, ['email', newEmail]);
    newEmail = '';
  }
}
