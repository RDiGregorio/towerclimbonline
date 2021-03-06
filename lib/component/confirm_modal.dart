import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:towerclimbonline/client.dart';

@Component(
    selector: 'confirm-modal',
    directives: [coreDirectives, formDirectives],
    templateUrl: 'confirm_modal.html')
class ConfirmModal {
  String get message => ClientGlobals.currentModalMessage;

  void choice(bool input) => handleInputModalSubmit('$input');
}
