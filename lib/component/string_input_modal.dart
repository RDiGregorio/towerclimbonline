import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:towerclimbonline/client.dart';

@Component(
    selector: 'string-input-modal',
    directives: [coreDirectives, formDirectives],
    templateUrl: 'string_input_modal.html')
class StringInputModal {
  String? input;

  StringInputModal() {
    ClientGlobals.inputModals.add(this);
  }

  void handleSubmit() => handleInputModalSubmit(input);
}
