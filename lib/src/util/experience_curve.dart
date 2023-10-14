part of util;

class ExperienceCurve {
  static Map<int, BigInt> _table;

  static BigInt experienceFromLevel(int level) {
    _populate();
    return _table[level];
  }

  static int levelFromExperience(BigInt experience) {
    _populate();

    return _table.keys.firstWhere((level) => _table[level] > experience,
            orElse: () => Stat.maxLevel + 1) -
        1;
  }

  static void _populate() {
    if (_table != null) return;
    _table = {};

    for (var i = 1; i <= Stat.maxLevel; i++) {
      var result = 50 * (i - 1) * pow(1.02, i);
      _table[i] = big(result);
    }
  }
}
