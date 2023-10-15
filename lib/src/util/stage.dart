part of util;

/// Holds information for collision detection and finding nearby dolls. It
/// doesn't hold graphical information (that can be stored somewhere else based
/// on the stage name).

class Stage<T extends Doll?> extends OnlineObject {
  final String? id;
  int? keepAlive = 0, _sectionWidth, _sectionHeight, _timestamp;
  Map<Point<int>, Map<Point<int>, int>> _sections = {};
  Space<T> _space = Space(), _userDollSpace = Space();
  Map<String?, T> _dollsByName = {};
  SetMultimap<Point<int>, T> _dollsByLocation = SetMultimap();
  Map<Point<int>, String> _sectionNames = {};
  List<Point<int>>? _traversableLocations;

  Stage(this.id, this._sectionWidth, this._sectionHeight);

  Rectangle<int> get bounds => Rectangle<int>(
      0,
      0,
      _sections.keys.fold(0, (dynamic result, point) => max<int>(result, point.x)) +
          _sectionWidth!,
      _sections.keys.fold(0, (dynamic result, point) => max<int>(result, point.y)) +
          _sectionHeight!);

  Map<String?, T> get dolls => UnmodifiableMapView(_dollsByName);

  Map<String, dynamic> get flags => internal['flags'] ?? {};

  Doll? get stairsDown =>
      dolls.values.firstWhereOrNull((doll) => doll!.isStairsDown);

  Doll? get stairsUp =>
      dolls.values.firstWhereOrNull((doll) => doll!.isStairsUp);

  int get timestamp => _timestamp ?? 0;

  void set timestamp(int value) => _timestamp = value;

  void addDoll(T doll, [Point<int>? location]) {
    if (dolls.containsKey(doll!.id)) removeDoll(dolls[doll.id]!);

    if (doll.temporary)
      Future.delayed(
          const Duration(minutes: ServerGlobals.temporaryBossMinutes),
          () => removeDoll(doll));

    doll._stage = this;
    if (location != null) doll.internal['loc'] = [location.x, location.y];
    _dollsByLocation.add(doll.currentLocation, doll);
    _space.add(doll.currentLocation, _dollsByName[doll.id] = doll);

    // Sets [doll.account.mostRecentStage].

    if (doll.account != null) {
      _userDollSpace.add(doll.currentLocation, doll);
      doll.updateLastTeleportTime();

      doll.account!
        ..internal['stage'] = id
        ..sessions.forEach((session) {
          // Sets up the terrain sections that are visible client side.

          var map = {};

          _sectionNames
              .forEach((point, name) => map['${point.x} ${point.y}'] = name);

          replaceMap(
              (session..internal['stage'] = id).internal['tmx'] ??=
                  ObservableMap(),
              map);
        });
    } else
      doll..spawnStage = this
        ..spawnLocation = doll.currentLocation;
  }

  Set<T> dollsAt(Point<int> location) => Set.from(_dollsByLocation[location]);

  int? getTerrain(Point<int> location) => (_sections[Point(
          location.x - location.x % _sectionWidth!,
          location.y - location.y % _sectionHeight!)] ??
      const {})[Point(location.x % _sectionWidth!, location.y % _sectionHeight!)];

  bool land(Point<int> location) =>
      (getTerrain(location) ?? double.infinity) <= Terrain.land;

  void moveDoll(T doll, Point<int> location) {
    assert(doll!.stage == this);

    _dollsByLocation
      ..remove(doll!.currentLocation, doll)
      ..add(location, doll);

    if (doll.account != null)
      _userDollSpace
        ..remove(doll)
        ..add(location, doll);

    _space
      ..remove(doll)
      ..add(location, doll);

    doll.internal['loc'] = [location.x, location.y];
  }

  Point<int>? randomTraversableLocation(Doll doll) {
    traversableLocations() {
      _traversableLocations = [];
      var bottomRight = bounds.bottomRight;

      for (var x = 0; x < bottomRight.x; x++)
        for (var y = 0; y < bottomRight.y; y++) {
          var point = Point(x, y);

          if (traversable(doll, point, Terrain.land))
            _traversableLocations!.add(point);
        }

      return _traversableLocations!.isEmpty
          ? const [Point(0, 0)]
          : _traversableLocations;
    }

    return randomValue(_traversableLocations ??= traversableLocations());
  }

  void removeDoll(T doll) {
    if (doll!.account != null) _userDollSpace.remove(doll);
    _dollsByLocation.remove(doll.currentLocation, doll);
    _dollsByName.remove((doll.._stage = null).id);
    _space.remove(doll);
  }

  /// Searches all dolls.

  Iterable<T> search(Rectangle<num> rectangle) => _space.search(rectangle);

  /// If [_sectionWidth] and [_sectionHeight] are 100, for example, valid
  /// [location]s are [0, 0], [100, -200], [500, 600], and so on.

  void setCollisionMap(String? name, Map<Point<int>, int> collision,
      [Point<int> location = const Point(0, 0)]) {
    // Sets up collision detection.

    assert(location.x % _sectionWidth! == 0 && location.y % _sectionHeight! == 0);
    _sectionNames[location] = 'image/terrain/$name.png';
    _sections[location] = Map.from(collision);
  }

  bool traversable(Doll doll, Point<int> location, int? pass) {
    var terrainType = getTerrain(location);

    return terrainType != null &&
        dollsAt(location).fold(
                terrainType,
                (dynamic terrainType, doll) =>
                    max<num>(terrainType, doll!.canPassThis!)) <=
            pass!;
  }

  /// Searches only user dolls.

  Iterable<T> userSearch(Rectangle<num> rectangle) =>
      _userDollSpace.search(rectangle);
}
