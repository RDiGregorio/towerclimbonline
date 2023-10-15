import 'dart:convert';
import 'dart:html';

import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:towerclimbonline/client.dart';
import 'package:towerclimbonline/util.dart';

@Component(
    selector: 'editor-component',
    directives: [coreDirectives, formDirectives],
    templateUrl: 'editor_component.html')
class EditorComponent {
  WebSocket? _socket;

  String? mode = 'default',
      text = '',
      flags = '',
      object = '',
      fgColor = '',
      bgColor = '';

  int mouseX = 0, mouseY = 0;
  bool fill = false;
  List<dynamic>? cells = const [];

  EditorComponent() {
    getSocket('localhost', 9998)
        .then((socket) => (_socket = socket)!.onMessage.listen((event) {
              try {
                var map = json.decode(event.data);
                cells = map['cells'];
                flags = map['flags'];
              } catch (error, stackTrace) {
                print(error);
                print(stackTrace);
              }
            }));
  }

  Map<String, String> cellStyle(int x, int y) {
    var cell = _cell(x, y), color;

    if (_isStairs(cell[0]))
      color = 'white';
    else if (cell[0]?.startsWith('@') == true)
      color = stringColor(cell[0]);
    else
      color = cell[1];

    return {'color': color, 'background-color': cell[2]};
  }

  String cellText(int x, int y) {
    var result = _cell(x, y)[0];
    if (result == null || result.isEmpty) return '\n';
    if (_isStairs(result)) return '⚑';
    if (result[0] == '@') return '▲';
    return result[0];
  }

  void generate() {
    cells = List.generate(100, (index) => List.filled(100, null, growable: false));
  }

  void handleClick(int x, int y) {
    var list = [object, null, null];
    if (fgColor?.isNotEmpty == true) list[1] = fgColor;
    if (bgColor?.isNotEmpty == true) list[2] = bgColor;

    fill
        ? _fill(x, y, _cell(mouseX = x, mouseY = y), list)
        : cells![mouseX = x][mouseY = y] = list;
  }

  void handleRightClick(MouseEvent event, int x, int y) {
    event.preventDefault();
    object = _cell(mouseX = x, mouseY = y)[0];
    fgColor = _cell(x, y)[1];
    bgColor = _cell(x, y)[2];
  }

  void handleSubmit() {
    if (mode == 'input')
      _socket!.send(json.encode(['load', text]));
    else if (mode == 'output')
      _socket!.send(json.encode([
        'save',
        text,
        {'flags': flags, 'cells': cells}
      ]));

    mode = 'default';
  }

  void regen() => _socket!.send(json.encode(const ['gen']));

  List<String> _cell(int x, int y) {
    var list = cells!.length > x ? cells![x] : const [];

    return List<String>.from(
        (list.length > y ? list[y] : null) ?? const [null, null, null]);
  }

  void _fill(int x, int y, List<String> oldCell, List<String?> newCell) {
    if (x < 0 || y < 0 || x > 99 || y > 99) return;

    if (_cell(x, y)[0] == oldCell[0] &&
        _cell(x, y)[1] == oldCell[1] &&
        _cell(x, y)[2] == oldCell[2]) {
      cells![x][y] = List.from(newCell);
      _fill(x - 1, y, oldCell, newCell);
      _fill(x + 1, y, oldCell, newCell);
      _fill(x, y - 1, oldCell, newCell);
      _fill(x, y + 1, oldCell, newCell);
    }
  }

  bool _isStairs(String value) {
    if (value == null) return false;

    return value == '@up stairs' ||
        value == '@down stairs' ||
        value.startsWith('@portal');
  }
}
