import 'dart:math';

import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:towerclimbonline/client.dart';
import 'package:towerclimbonline/util.dart';

@Component(
    selector: 'mini-map-component',
    directives: [coreDirectives, formDirectives],
    templateUrl: 'mini_map_component.html')
class MiniMapComponent {
  Iterable<dynamic> get dolls =>
      (ClientGlobals.session?.importantDolls ?? {}).values.where((doll) =>
          !doll.dead &&
          sectionKey(doll.currentLocation) ==
              sectionKey(ClientGlobals.session?.doll?.currentLocation));

  Map<String, String> get style => {'background-image': terrain};

  String get terrain {
    var location = ClientGlobals.session?.doll?.currentLocation;
    if (location == null) return null;
    var result = ClientGlobals.session.terrainSections[sectionKey(location)];
    if (result == null) return null;
    return 'url("../$result")';
  }

  Map<String, String> pointStyle(Doll doll) {
    var x = doll?.currentLocation?.x ?? 0, y = doll?.currentLocation?.y ?? 0;

    var result = {'left': '${x % 100}px', 'top': '${y % 100}px'};

    if (doll?.player == true) {
      var color = 'white';
      result['background-color'] = color;
      result['border-left-color'] = color;
      result['border-top-color'] = color;
    }

    if (doll?.boss == true) {
      // Bosses blink if killing them will unlock a new floor.

      var difficulty =
          doll?.difficulty ?? stageToFloor(ClientGlobals.session?.stage) ?? 0;

      if (ClientGlobals.session.highestFloor <= difficulty)
        result['animation'] = 'blinker 1s step-start infinite';
    }

    return result;
  }

  Point<int> sectionKey(Point<int> location) => location == null
      ? Point<int>(0, 0)
      : Point<int>(location.x ~/ 100 * 100, location.y ~/ 100 * 100);
}
