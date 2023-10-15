import 'package:ngdart/angular.dart';
import 'package:ngforms/angular_forms.dart';
import 'package:towerclimbonline/client.dart';

@Component(
    selector: 'text-modal',
    directives: [coreDirectives, formDirectives],
    templateUrl: 'text_modal.html')
class TextModal {
  String? input;

  String? get text => ClientGlobals.currentModalMessage;

  void choice(bool input) => handleInputModalSubmit('$input');
}
