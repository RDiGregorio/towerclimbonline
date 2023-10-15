import 'dart:math';

import 'package:ngdart/angular.dart';
import 'package:ngforms/angular_forms.dart';
import 'package:towerclimbonline/client.dart';
import 'package:towerclimbonline/util.dart';

@Component(
    selector: 'floor-input-modal',
    directives: [coreDirectives, formDirectives],
    templateUrl: 'floor_input_modal.html')
class FloorInputModal {
  String? input;

  FloorInputModal() {
    ClientGlobals.inputModals.add(this);
  }

  bool get disabled =>
      input == null ||
      input!.isEmpty ||
      !input!.toLowerCase().contains(numberPattern) ||
      parseInteger(input)! < 1;

  bool get procGen {
    var mode = ClientGlobals.session!.options!['teleport mode'] ?? 'static';
    return mode != 'static';
  }

  void set procGen(bool value) => ClientGlobals.session!
      .remote(#setOption, ['teleport mode', value ? 'proc gen' : 'static']);

  void add(int amount) {
    var parsed = parseInteger(input) ?? 0;
    input = '${max<int>(0, parsed + amount)}';
  }

  void handleSubmit() => handleInputModalSubmit(input);
}
