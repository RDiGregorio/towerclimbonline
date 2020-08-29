part of util;

class Stat extends OnlineObject {
  static const int maxLevelExperience = 25450468793770, maxLevel = 600;

  int get ascensions => internal['ascensions'] ?? 0;

  void set ascensions(int value) {
    setExperienceWithoutSplat(BigInt.zero);
    internal['ascensions'] = value;
    internal['next level text'] = formatNumber(nextLevelExperience);
  }

  BigInt get experience => big(internal['exp'] ?? 0);

  void set experience(dynamic value) => _setExperience(big(value), true);

  String get experienceText => internal['exp text'] ?? '0';

  void set experienceText(String text) => internal['exp text'] = text;

  int get internalLevel => _level;

  int get level => _level * (ascensions + 1);

  BigInt get nextLevelExperience {
    if (_level >= maxLevel) return BigInt.from(maxFinite);
    return _experienceFromLevel(_level + 1);
  }

  String get nextLevelExperienceText => internal['next level text'];

  BigInt get previousLevelExperience => _experienceFromLevel(_level);

  int get _level => min(internal['lvl'] ?? 1, maxLevel);

  bool ascend() {
    if (level < maxLevel) return false;
    ascensions++;
    return true;
  }

  void setExperienceWithoutSplat(BigInt value) => _setExperience(value, false);

  void setLevel(int value) =>
      _setExperience(_experienceFromLevel(min(value, maxLevel)), false);

  BigInt _experienceFromLevel(int level) {
    var result = pow(exp(level - 1), 1 / 25) * 1000 - 1000;
    return big(result.ceil()) * (BigInt.one << ascensions);
  }

  int _levelFromExperience(BigInt experience) {
    num result = (experience ~/ (BigInt.one << ascensions)).toInt();
    if (result <= 0) return 1;
    if (result >= maxLevelExperience) return maxLevel;
    result = pow((result + 1000) / 1000, 25);
    return log(result).floor() + 1;
  }

  void _setExperience(BigInt value, bool showSplat) {
    var previousLevel = _level,
        previousExperience = big(internal['exp'] ?? 0),
        gainedExperience = value - previousExperience;

    internal
      ..['exp'] = '$value'
      ..['lvl'] = _levelFromExperience(value);

    // Needed to display experience correctly client side.

    experienceText = formatNumber(experience);
    internal['next level text'] = formatNumber(nextLevelExperience);

    if (showSplat) {
      internal.addEvent(
          ObservableEvent(type: 'xp', data: {'value': '$gainedExperience'}));

      if (_level > previousLevel)
        internal.addEvent(ObservableEvent(type: 'level up'));
    }
  }
}
