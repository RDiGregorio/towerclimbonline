part of util;

class Idler {
  final Duration duration;
  Object? _object;
  Function _onIdle;

  Idler(this.duration, this._onIdle());

  void reset() {
    var object = Object();
    _object = object;
    Future.delayed(duration, () {
      if (_object == object) _onIdle();
    });
  }
}
