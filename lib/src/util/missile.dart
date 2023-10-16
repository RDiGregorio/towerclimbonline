part of util;

class Missile {
  final String image;
  final Doll source, target;
  final Map<String, String> outerStyle = {}, innerStyle = {};
  late Point<int> _location;
  int _time = now;
  bool aoe;

  Missile(this.image, this.source, this.target, [this.aoe = false]) {
    _location = source.currentLocation;
  }

  int get age => now - _time;

  Rectangle<int> get bounds => Rectangle(0, 0, 16, 16);

  Point<num> get location {
    return approachPoint(
        aoe
            ? Point(target.currentLocation.x, target.currentLocation.y - 1)
            : _location,
        target.currentLocation,
        age / 100);
  }
}
