import 'dart:collection';
import 'dart:html';
import 'dart:js';
import 'dart:math';

import 'package:ngdart/angular.dart';
import 'package:ngforms/angular_forms.dart';
import 'package:logging/logging.dart';
import 'package:towerclimbonline/client.dart';
import 'package:towerclimbonline/config.dart';
import 'package:towerclimbonline/util.dart';

@Component(
    selector: 'camera-component',
    directives: [coreDirectives, formDirectives],
    templateUrl: 'camera_component.html',
    changeDetection: ChangeDetectionStrategy.onPush)
class CameraComponent {
  final Set<String> terrain = Set();

  final Map<String, Map<String, String>> terrainStyles = {},
      foregroundTerrainStyles = {};

  final int tileSize = 16, marginTop = -57;
  final Map<String?, String> rippleStyle = {};
  final Set<Missile> missiles = Set();
  final Queue<int> _fps = Queue();
  Set<Doll> _dolls = Set();
  Set<String> _loadedImages = Set(), _brokenImages = Set();

  int _lastClickTime = 0,
      _minZ = 0,
      _frames = 0,
      _frameTime = now,
      _nocache = now;

  Point<int>? _pointer;
  Point<num> _rippleLocation = const Point(0, 0);
  num? _zoom;
  final ChangeDetectorRef _changeDetectorRef;

  CameraComponent(this._changeDetectorRef) {
    if (ClientGlobals.session?.internal == null) return;
    animationLoop(() => _changeDetectorRef.markForCheck());

    ClientGlobals.session!.internal
      ..getEvents(type: 'jump').forEach((event) {
        var doll = unwrap(ClientGlobals.session)
            .getPath(List<String>.from(event.path!));

        if (doll == null) return;

        // Clears missiles when the player jumps.

        doll.sprite.location = doll.currentLocation;
        if (doll.id == ClientGlobals.session!.doll?.id) missiles.clear();
      })
      ..getEvents(type: 'splat').forEach((event) {
        var doll = unwrap(ClientGlobals.session)
                .getPath(List<String>.from(event.path!)),
            showSplats = ClientGlobals.session!.options!['show splats'] ?? true;

        if (doll != null && showSplats)
          doll.splats
              .add(Splat(event.data!['value'], now, event.data!['classes']));
      })
      ..getEvents(type: 'missile').forEach((event) {
        var source = ClientGlobals.session!.view![event.data!['source']],
            target = ClientGlobals.session!.view![event.data!['target']];

        if (source != null && target != null)
          missiles.add(Missile(event.data!['image'], source, target));
      })
      ..getEvents(type: 'aoe').forEach((event) {
        var source = ClientGlobals.session!.view![event.data!['source']],
            target = ClientGlobals.session!.view![event.data!['target']];

        if (source != null && target != null)
          missiles.add(Missile(event.data!['image'], source, target, true));
      });

    animationLoop(() {
      _updateFrames();
      if (ClientGlobals.session?.view == null) return;

      // Handles smooth zoom.

      var zoomSpeed = .1;
      _zoom ??= ClientGlobals.zoom;
      if (_zoom! < ClientGlobals.zoom) _zoom = _zoom! + zoomSpeed;
      if (_zoom! > ClientGlobals.zoom) _zoom = _zoom! - zoomSpeed;

      if ((_zoom! - ClientGlobals.zoom).abs() < zoomSpeed)
        _zoom = ClientGlobals.zoom;

      // A ripple appears after a click.

      var ripple = now - _lastClickTime,
          rippleLocation = _clientPoint(_rippleLocation);

      ripple > 1000
          ? rippleStyle.clear()
          : (rippleStyle
            ..['left'] = '${rippleLocation.x}px'
            ..['top'] = '${rippleLocation.y}px'
            ..['opacity'] = '${1 - ripple / 1000}'
            ..['width'] = '${ripple / 50}px'
            ..['height'] = '${ripple / 50}px'
            ..['transform'] =
                'translate(${ripple / -100}px, ${ripple / -100}px)');

      // [terrain] and [dolls] are changed as little as possible.

      var sections = ClientGlobals.session!.terrainSections
        ..forEach((point, name) {
          point = _clientPoint(point);

          (terrainStyles[name] ??= {})
            ..['left'] = '${point.x}px'
            ..['top'] = '${point.y}px'
            ..['transform'] = 'scale($zoom, $zoom)';

          (foregroundTerrainStyles[name] ??= {})
            ..['left'] = '${point.x}px'

            // A 1 pixel gap is added.

            ..['top'] = '${point.y - zoom! * 15}px'
            ..['z-index'] = '1'
            ..['transform'] = 'scale($zoom, $zoom)';
        });

      var values = sections.values.map((value) => '$value');

      terrain
        ..retainWhere(values.contains)
        ..addAll(values);

      _dolls
        ..retainWhere(ClientGlobals.session!.view!.values.contains)
        ..addAll(List<Doll>.from(ClientGlobals.session!.view!.values))
        ..forEach((doll) {
          if (!doll.internal.containsKey('frames')) doll.internal['frames'] = 0;
          if (doll.internal['frames'] < 2) doll.internal['frames']++;

          var spriteLocation = _clientPoint(doll.sprite.location),
              index = spriteLocation.y - doll.sprite.bounds.height,

              // FIXME: zIndex can still be negative.

              // Sorts sprites by their y axis and prevents a negative z-index.

              zIndex = (_minZ = min(_minZ, index as int)).abs() +
                  spriteLocation.y * 2 -
                  doll.sprite.bounds.height;

          doll.style
            ..['left'] = '${spriteLocation.x}px'
            ..['top'] = '${spriteLocation.y}px'
            ..['transform'] = 'scale($zoom, $zoom)'
            ..['z-index'] = '$zIndex';

          num hitBox = 1 / min(2, zoom!);
          doll.hitBoxStyle['transform'] = 'scale($hitBox, $hitBox)';

          if (doll.dead) {
            // Tracking frames prevents a doll from performing a death animation
            // if a player logs in near a dead doll.

            if (doll.internal['frames'] < 2) doll.style['display'] = 'none';

            // CSS transitions are not used for opacity because they cause
            // rendering issues with layers above the transitioning layer.

            if (!doll.internal.containsKey('death time'))
              doll.internal['death time'] = now;

            var opacity =
                max(0, 1 - (now - doll.internal['death time']) / 1000);

            doll.style['pointer-events'] = 'none';

            // 0 opacity may not work, so display is instead set to none.

            opacity > 0
                ? doll.style['opacity'] = formatNumberWithPrecision(opacity)
                : doll.style['display'] = 'none';
          } else {
            doll..internal.remove('death time')..style.remove('display');

            if (ClientGlobals.session!.hiddenDolls.containsKey(doll.id))
              doll.style
                ..['opacity'] = doll.boss || doll.player ? '0.25' : '0'
                ..['pointer-events'] = 'none';
            else
              doll.style..remove('pointer-events')..remove('opacity');

            if (ClientGlobals.session!.tappedItemSources.containsKey(doll.id))
              doll.style['pointer-events'] = 'none';
          }

          // Handles opened chests.

          if (ClientGlobals.session!.recentChests[doll.id] == true)
            doll.style['opacity'] = '0.5';

          if (doll == ClientGlobals.session!.doll)
            doll.style['pointer-events'] = 'none';

          // Handles overhead public chat messages.

          var messageElement = querySelector('#message-${doll.id}');

          if (messageElement != null) {
            var messageOffset = ((doll.sprite.bounds.width * zoom! * tileSize -
                        messageElement.clientWidth) /
                    2)
                .floor();

            doll.messageStyle
              ..['left'] = '${spriteLocation.x + messageOffset}px'
              ..['z-index'] = '2'
              ..['top'] = '${spriteLocation.y - 20}px';
          }

          var bounds = doll.sprite.bounds,
              width = bounds.width * zoom! * tileSize,
              height = bounds.height * zoom! * tileSize;

          // Handles the health bar.

          doll.healthBarStyle
            ..['left'] = '${spriteLocation.x}px'
            ..['top'] = '${spriteLocation.y + height}px'
            ..['z-index'] = '1'
            ..['transform'] = 'scale($zoom, $zoom)';

          var ratio = doll.maxHealth == null || doll.maxHealth == BigInt.zero
                  ? 0
                  : doll.health / doll.maxHealth!,
              red = (255 - ratio * 255).floor();

          // Doubling the color values makes the bar brighter.

          doll.innerHealthBarStyle
            ..['width'] = '${(ratio * 100).floor()}%'
            ..['background-color'] = 'rgb(${red * 2}, ${(255 - red) * 2}, 0)';

          // Handles damage and effect splats.

          var opacityList = [];

          _splats(doll).forEach((time, Splat splat) {
            var splatElement = querySelector('#splat-${splat.id}');

            if (splatElement != null) {
              var xOffset = ((width - splatElement.clientWidth) / 2).floor(),
                  yOffset = -max(0, ((now - time) / 10).floor()),
                  opacity = 2 + yOffset / 50;

              opacityList.add(opacity);

              splat.style
                ..['left'] = '${spriteLocation.x + xOffset}px'
                ..['top'] = '${spriteLocation.y + yOffset}px'
                ..['z-index'] = '2'
                ..['opacity'] = '$opacity';
            }
          });
        });

      // Handles arrows, bullets, and so on.

      List.from(missiles).forEach((missile) {
        var distance =
            missile.location.distanceTo(missile.target.currentLocation);

        // Prevents strange arrow movements.

        if (distance < .2 ||
            missile.source.currentLocation
                    .distanceTo(missile.target.currentLocation) <
                distance) {
          missiles.remove(missile);
          return;
        }

        var location = _clientPoint(missile.location),
            targetLocation = _clientPoint(missile.target.currentLocation),
            radians = atan2(
                location.y - targetLocation.y, location.x - targetLocation.x);

        missile.outerStyle
          ..['left'] = '${location.x}px'
          ..['top'] = '${location.y}px'
          ..['transform'] = 'scale($zoom, $zoom)';

        missile.innerStyle['transform'] = 'rotate(${radians}rad)';
      });
    });
  }

  Map<String, String> get backgroundStyle {
    var stage = ClientGlobals.session?.stage,
        black = {'background-color': 'black'},
        orange = {'background-color': 'rgb(255, 140, 0)'},
        blue = {'background-color': 'lightskyblue'};

    if (ClientGlobals.session?.stageFlags
            ?.containsKey('background-color: orange') ==
        true) return orange;

    if (ClientGlobals.session?.stageFlags
            ?.containsKey('background-color: lightskyblue') ==
        true) return blue;

    if (stage == null || stage.startsWith('procgen')) return black;

    if (const [
      'tutorial0',

      // Lava.

      'dungeon20',
      'dungeon21',
      'dungeon22',
      'dungeon23',
      'dungeon24',

      // Void.

      'dungeon30',
      'dungeon31',
      'dungeon32',
      'dungeon33',
      'dungeon34',

      // Snake (only the first is black).

      'dungeon35',

      // Underwater (42, 43 and 44 are beach themed).

      'dungeon40',
      'dungeon41',

      // Blood (49 has a different theme).

      'dungeon45',
      'dungeon46',
      'dungeon47',
      'dungeon48'
    ].contains(stage)) return black;

    return const {};
  }

  Set<Doll> get dolls => _dolls;

  bool? get hasFocus => context.callMethod('eval', ['document.hasFocus()']);

  /// Prevents performance issues from too many missiles.

  Iterable<Missile> get visibleMissiles =>

      // Reversed to show the last 100 missiles.

      List<Missile>.from(missiles).reversed.take(100);

  num? get zoom => _zoom;

  bool brokenImage(String value, [String? modifier]) =>
      _brokenImages.contains(_applyModifier(value, modifier));

  /// Returns true if [doll] is the current player.

  bool currentPlayer(Doll doll) =>
      ClientGlobals.session!.doll != null &&
      ClientGlobals.session!.doll!.id == doll.id;

  String displayBuffs(Doll doll) {
    // The player's buffs are not displayed under their health bar.

    if (doll == null ||
        ClientGlobals.session?.doll?.id == null ||
        doll.id == ClientGlobals.session!.doll!.id) return '';

    // Only some buffs are displayed.

    var result = [];

    if (['agi+', 'str+', 'dex+', 'int+'].any(doll.buffKeys.contains))
      result.add('buffed');

    if (['agi-', 'str-', 'dex-', 'int-'].any(doll.buffKeys.contains))
      result.add('debuffed');

    if (doll.buffKeys.contains('frozen')) result.add('frozen');
    if (doll.buffKeys.contains('burned')) result.add('burned');
    if (doll.buffKeys.contains('poisoned')) result.add('poisoned');
    return result.join(', ');
  }

  String? displayImage(Doll doll) =>
      ClientGlobals.session!.tappedItemSources.containsKey(doll.id)
          ? doll.tappedImage
          : doll.image;

  Map<String, String> displayNameStyle(Doll doll) =>
      _groundedImage(doll) ? {} : {'margin-top': '-${round(16 * zoom!, 2)}px'};

  int dollSize(Doll doll) {
    if (_groundedImage(doll)) return 16;
    return 32;
  }

  Map<String, String> dollStyle(Doll doll, [String? flag]) {
    Map<String, String> result = {};

    // Yellow sparkles (4 × resources).

    if (flag == 'sparkles' &&
        ClientGlobals.session!.goodItemSources[doll.id] == 2)
      result['filter'] = 'sepia(1) saturate(10000%)';

    // Cyan sparkles (8 × resources).

    if (flag == 'sparkles' &&
        ClientGlobals.session!.goodItemSources[doll.id] == 3)
      result['filter'] = 'brightness(0.5) sepia(1) saturate(10000%) invert(1)';

    if (!_groundedImage(doll)) {
      result['margin-left'] = '-8.5px';
      result['margin-top'] = '-16px';
    }

    return result;
  }

  String formatSplat(String splat) => splat.replaceAllMapped(
      RegExp('\\d+'), (match) => formatCurrency(int.parse(match[0]!), false));

  bool goodResource(Doll doll) =>
      ClientGlobals.session!.goodItemSources.containsKey(doll.id);

  void handleClick(MouseEvent event, [Doll? doll]) {
    event.preventDefault();
    _lastClickTime = now;
    replaceMap(rippleStyle, {'border-color': doll == null ? 'yellow' : 'red'});
    var point = _serverPoint(event.client);
    _rippleLocation = point;

    doll != null
        ? ClientGlobals.session!.remote(#click, [doll.id])
        : ClientGlobals.session!
            .remote(#walk, [point.x.floor(), point.y.floor()]);
  }

  /// Zooms. The min zoom is half the default and the max zoom is double the
  /// default.

  void handleMouseWheel(WheelEvent event) {
    _scroll(event.deltaY.sign as int);
  }

  void handlePointerDown(TouchEvent event) {
    _pointer = event.touches!.first.client as Point<int>?;
  }

  void handlePointerMove(TouchEvent event) {
    if (_pointer != null) {
      var pointer = event.touches!.first.client;
      // This never worked well, so instead zoom is done in the options.
      // _scroll((pointer.y - _pointer.y).sign);
      _pointer = pointer as Point<int>?;
    }
  }

  void handlePointerUp(TouchEvent event) {
    _pointer = null;
  }

  bool hasShadow(Doll? doll) {
    if (doll?.image == null) return true;
    if (doll!.image.endsWith('jellyfish.png')) return true;
    if (doll.image.endsWith('fish.png')) return false;
    if (doll.image.endsWith('stairs.png')) return false;
    if (doll.image.endsWith('altar.png')) return false;
    return true;
  }

  Map<String, String> healthBarIconStyle(Doll doll) {
    var result = Map<String, String>.from(doll.healthBarStyle);
    return result;
  }

  bool hideDisplayName(Doll doll) => _hideDisplayName(doll);

  String nocache(String value, [String? modifier]) {
    value = _applyModifier(value, modifier);

    if (value.startsWith('image/terrain/procgen') && _loadedImages.add(value))
      ImageElement(src: value).onError.forEach((error) {
        Logger.root.severe('$error');

        _brokenImages.add(value);
        // Attempts to reload broken terrain.

        Future.delayed(Duration(seconds: 1), () {
          Logger.root.info('reloading $value');
          _brokenImages.remove(value);
          _nocache++;
        });
      });

    // Needed for procedurally generated floors to display in the mobile app.

    if (Config.app && value.startsWith('image/terrain/procgen'))
      value = 'http://towerclimbonline.com/$value';

    return '$value?nocache=${ClientGlobals.start! + _nocache}';
  }

  Map<String, String> shadowStyle(Doll doll) {
    var result = {'border': '0'};

    // Some dolls have their shadow margins adjusted for their art. Strangely,
    // it only works when border is also set.

    if (doll.infoName == 'rat') result['margin-top'] = '-2.75px';
    if (doll.infoName == 'spider') result['margin-top'] = '-2.75px';
    if (doll.infoName == 'famine') result['margin-top'] = '-2.75px';
    if (doll.infoName == 'scorpion') result['margin-top'] = '-2.75px';
    if (doll.infoName == 'lion') result['margin-top'] = '-2.75px';
    if (doll.infoName == 'crab') result['margin-top'] = '-2.75px';
    if (doll.infoName == 'blue crab') result['margin-top'] = '-2.75px';
    if (doll.infoName == 'robot') result['margin-top'] = '-2.75px';
    if (doll.infoName == 'juggernaut') result['margin-top'] = '-2.75px';
    if (doll.infoName == 'king crab') result['margin-top'] = '-5.5px';
    if (doll.infoName == 'ascended crab') result['margin-top'] = '-5.5px';
    if (doll.infoName == 'spider demon') result['margin-top'] = '-5.5px';
    if (doll.infoName == 'giant death robot') result['margin-top'] = '-2.75px';
    return result;
  }

  String _applyModifier(String value, String? modifier) =>
      modifier == null ? value : value.replaceFirst('.png', '$modifier.png');

  Point<int> _clientPoint(Point<num>? serverPoint) {
    if (ClientGlobals.session!.doll == null) return const Point(0, 0);
    var point = ClientGlobals.session!.doll!.sprite.location,
        size = zoom! * tileSize;

    return Point(
        ((serverPoint!.x - point!.x) * size + (window.innerWidth! - size) / 2)
            .floor(),
        ((serverPoint.y - point.y) * size + (window.innerHeight! - size) / 2)
            .floor());
  }

  bool _groundedImage(Doll doll) {
    if (doll.player) return false;
    var image = doll?.image;
    if (image == null) return true;

    // Trees are the only ungrounded resource.

    if (doll.image.endsWith('jellyfish.png')) return false;
    if (image.endsWith('fish.png')) return true;
    if (image.endsWith('stairs.png')) return true;
    if (image.endsWith('chest.png')) return true;
    if (image.endsWith('rock.png')) return true;
    if (image.endsWith('altar.png')) return true;
    if (image.endsWith('gravestone.png')) return true;
    return false;
  }

  bool _hideDisplayName(Doll doll) {
    if (doll == null ||
        ClientGlobals.session?.hiddenDolls?.containsKey(doll.id) == true)
      return true;

    if (ClientGlobals.session?.doll?.id == null) return true;
    if (ClientGlobals.session!.doll!.id == doll.id) return true;
    if (doll.overheadText != null) return false;

    return doll.displayName == null ||
        doll.dead ||
        ClientGlobals.session!.doll == null ||
        !doll.boss && !doll.hideMessage;
  }

  void _scroll(int sign) => ClientGlobals.zoom = clamp(
      ClientGlobals.zoom - round(.1 * sign * ClientGlobals.zoom, 2), .5, 5);

  Point<num> _serverPoint(Point<num> clientPoint) {
    if (ClientGlobals.session!.doll == null) return const Point(0, 0);

    var point = ClientGlobals.session!.doll!.sprite.location,
        size = zoom! * tileSize;

    var result = Point(
        ((clientPoint.x - window.innerWidth! / 2 + size / 2) / size + point!.x),
        ((clientPoint.y - marginTop - window.innerHeight! / 2 + size / 2) /
                size +
            point.y));

    return result;
  }

  Map<int, Splat> _splats(Doll doll) {
    var map = <int, Splat>{}, step = 200;

    doll.splats.forEach((splat) {
      var time = splat.time ~/ step * step;
      while (map.containsKey(time)) time += step;
      map[time] = splat;
    });

    return map;
  }

  void _updateFrames() {
    if (now - _frameTime > 1000) {
      _frameTime = now;
      _fps.add(_frames);
      if (_fps.length > 5) _fps.removeFirst();

      ClientGlobals.fps =
          _fps.reduce((left, right) => left + right) ~/ _fps.length;

      _frames = 0;
    } else
      _frames++;
  }
}
