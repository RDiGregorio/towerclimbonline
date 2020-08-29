import 'dart:convert';

import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:logging/logging.dart';
import 'package:towerclimbonline/client.dart';
import 'package:towerclimbonline/config.dart';
import 'package:towerclimbonline/util.dart';

/// The customization is sent to the server when the modal closes in app.dart.

@Component(
    selector: 'customize-modal',
    directives: [coreDirectives, formDirectives],
    templateUrl: 'customize_modal.html')
class CustomizeModal {
  bool get debug => Config.debug;

  String get debugText => json.encode(ClientGlobals.session.doll.customization,
      toEncodable: mapWrapperEncoder);

  void set debugText(String text) {
    try {
      ClientGlobals.session.doll.customization =
          json.decode(text, reviver: mapWrapperDecoder);
    } catch (error) {
      Logger.root.warning('invalid JSON');
    }
  }

  Doll get doll => ClientGlobals.session.doll;

  bool get female => doll.customization.gender == 'female';

  bool get male => doll.customization.gender == 'male';
}
