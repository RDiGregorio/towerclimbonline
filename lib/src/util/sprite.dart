part of util;

class Sprite {
  final Doll doll;
  Point<num>? _currentLocation;
  int _change = 0, _size;

  Sprite(this.doll, [this._size = 1]) {
    _currentLocation = doll.currentLocation;
    _change = now;
  }

  Rectangle<num> get bounds {
    var point = location!;
    return Rectangle(point.x, point.y, _size, _size);
  }

  Point<num>? get location {
    if (doll.walkingCoolDown == null) return doll.currentLocation;

    _currentLocation = gridApproachPoint(_currentLocation!, doll.currentLocation,
        (now - _change) / doll.walkingCoolDown!);

    _change = now;
    return _currentLocation;
  }

  void set location(Point<num>? location) {
    _currentLocation = location;
  }
}
