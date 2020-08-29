part of util;

class Missile {
  final String image;
  final Doll source, target;
  final Map<String, String> outerStyle = {}, innerStyle = {};
  Point<int> _location;
  int _time = now;

  Missile(this.image, this.source, this.target) {
    _location = source.currentLocation;
  }

  int get age => now - _time;

  Rectangle<int> get bounds => const Rectangle(0, 0, 16, 16);

  Point<num> get location =>
      approachPoint(_location, target.currentLocation, age / 100);
}
