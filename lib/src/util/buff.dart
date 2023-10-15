part of util;

class Buff extends OnlineObject {
  late int _now;

  Buff({int? duration, Iterable<int>? egos}) {
    internal
      ..['dur'] = duration
      ..['epoch'] = _now = Clock.time
      ..['epoch ms'] = DateTime.now().millisecondsSinceEpoch;

    if (egos != null) internal['egos'] = List.from(egos);
  }

  int get age => _now - epoch;

  int get ageMs => now - epochMs;

  /// Returns how long the buff lasts (in game ticks).

  num get duration => internal['dur'] ?? double.infinity;

  num get durationMs => duration * ServerGlobals.tickDelay;

  List<int> get egos => List.from(internal['egos'] ?? const []);

  int get epoch => internal['epoch'] ?? 0;

  int get epochMs => internal['epoch ms'] ?? 0;

  /// FIXME: use ticks instead of milliseconds (milliseconds are used because
  /// ticks aren't accurate between server restarts).

  bool get expired => ageMs >= durationMs;

  num get remaining => max(0, duration - age);

  num get remainingMs => max(0, durationMs - ageMs);

  void tick(int amount) {
    _now += amount;
  }
}
