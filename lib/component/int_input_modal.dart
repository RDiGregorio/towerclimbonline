import 'package:ngdart/angular.dart';
import 'package:ngforms/angular_forms.dart';
import 'package:towerclimbonline/client.dart';
import 'package:towerclimbonline/util.dart';

@Component(
    selector: 'int-input-modal',
    directives: [coreDirectives, formDirectives],
    templateUrl: 'int_input_modal.html')
class IntInputModal {
  String? input;

  IntInputModal() {
    ClientGlobals.inputModals.add(this);
  }

  bool get disabled =>
      input == null ||
      input!.isEmpty ||
      !input!.toLowerCase().contains(numberPattern) ||
      parseBigInteger(input)! < BigInt.one;

  void add(int amount) {
    var parsed = parseBigInteger(input) ?? BigInt.zero,
        result = BigIntUtil.max(BigInt.zero, parsed + big(amount)!);

    input = '$result';
  }

  void handleSubmit() => handleInputModalSubmit(input);
}
