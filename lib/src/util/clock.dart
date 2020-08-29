part of util;

class Clock {
  static int _time = 0;
  static Stream<dynamic> _ticks;

  static Stream<dynamic> get ticks {
    if (_ticks == null) throw StateError('not yet started');
    return _ticks;
  }

  static int get time => _time;

  static start([Duration duration]) {
    if (_ticks != null) throw StateError('already started');
    var time = 0, controller = StreamController();
    _ticks = controller.stream.asBroadcastStream();

    tick() {
      _time = time;
      return time++;
    }

    run() => Future(() {
          controller.add(tick());
          run();
        });

    duration != null
        ? Metronome.periodic(duration).listen((value) => controller.add(tick()))
        : run();
  }
}
