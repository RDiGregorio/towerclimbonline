import 'dart:math';

import 'package:ngdart/angular.dart';
import 'package:ngforms/angular_forms.dart';
import 'package:towerclimbonline/client.dart';
import 'package:towerclimbonline/util.dart';

@Component(
    selector: 'mini-map-component',
    directives: [coreDirectives, formDirectives],
    templateUrl: 'mini_map_component.html',
    changeDetection: ChangeDetectionStrategy.onPush)
class MiniMapComponent {
  final ChangeDetectorRef _changeDetectorRef;

  MiniMapComponent(this._changeDetectorRef) {
    // TODO: use a better performing way to check for changes.

    animationLoop(() => _changeDetectorRef.markForCheck());
  }

  Iterable<dynamic> get dolls =>
      (ClientGlobals.session?.importantDolls ?? {}).values.where((doll) =>
          !doll.dead &&
          sectionKey(doll.currentLocation) ==
              sectionKey(ClientGlobals.session?.doll?.currentLocation));

  int get height {
    var map = ClientGlobals.session?.options ?? {};
    return map['map size'] ?? 100;
  }

  Map<String, String> get style => {
        'background-image': terrain ?? '',
        'width': '${width}px',
        'height': '${height}px'
      };

  String? get terrain {
    var location = ClientGlobals.session?.doll?.currentLocation;
    if (location == null) return null;
    var result = ClientGlobals.session!.terrainSections[sectionKey(location)];
    if (result == null) return null;

    // The cache is cleared when the browser is refreshed.

    return 'url("../$result?nocache=${ClientGlobals.start}")';
  }

  int get width {
    var map = ClientGlobals.session?.options ?? {};
    return map['map size'] ?? 100;
  }

  Map<String, String> pointStyle(Doll? doll) {
    num x = doll?.currentLocation?.x ?? 0, y = doll?.currentLocation?.y ?? 0;
    x = (x % 100) * width ~/ 100;
    y = (y % 100) * height ~/ 100;
    var result = {'left': '${x}px', 'top': '${y}px'}, color = 'magenta';

    if (doll?.player == true) color = 'white';

    if (doll?.altar == true ||
        doll?.shop == true ||
        doll?.isStairsUp == true ||
        doll?.isStairsDown == true ||
        doll?.infoName == 'tutorial' ||
        doll?.infoName == 'gravestone') color = 'gold';

    if (doll?.infoName == 'chest')
      color = ClientGlobals.session!.recentChests[doll!.id] != true
          ? 'cyan'
          : 'black';

    if (doll?.boss == true) {
      color = 'red';

      // Bosses blink if killing them will unlock a new floor.

      var difficulty =
          doll?.difficulty ?? stageToFloor(ClientGlobals.session?.stage) ?? 0;

      if (ClientGlobals.session!.highestFloor <= difficulty)
        result['animation'] = 'blinker 1s step-start infinite';
    }

    result['background-color'] = color;
    result['border-left-color'] = color;
    result['border-top-color'] = color;

    return result;
  }

  Point<int> sectionKey(Point<int>? location) => location == null
      ? Point<int>(0, 0)
      : Point<int>(location.x ~/ 100 * 100, location.y ~/ 100 * 100);
}
