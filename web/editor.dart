import 'package:angular/angular.dart';

import 'package:towerclimbonline/component/editor_component.template.dart'
    as ng;

void main() {
  disableDebugTools();
  runApp(ng.EditorComponentNgFactory);
}
