part of util;

class Stat extends OnlineObject {
  static const int maxLevelExperience = 19483731487981, maxLevel = 999;
  BigInt _cache = BigInt.zero;
  int _levelAfterAscension;

  BigInt get ascensionMultiplier => BigInt.one << ascensions;

  int get ascensions => internal['ascensions'] ?? 0;

  void set ascensions(int value) {
    var delta = experience - previousLevelExperience;
    setExperienceWithoutSplat(BigInt.zero);
    internal['ascensions'] = value;
    setExperienceWithoutSplat(delta);
  }

  BigInt get experience => big(internal['exp'] ?? 0);

  void set experience(dynamic value) => _setExperience(big(value), true);

  String get experienceText => internal['exp text'] ?? '0';

  void set experienceText(String text) => internal['exp text'] = text;

  int get internalLevel => _level;

  int get level => _level * (ascensions + 1);

  int get levelAfterAscension {
    if (_cache != experience) {
      _cache = experience;
      var copy = Stat();
      copy.ascensions = ascensions;
      copy.setExperienceWithoutSplat(experience);
      copy.ascensions++;
      _levelAfterAscension = copy.internalLevel;
    }

    return _levelAfterAscension;
  }

  BigInt get nextLevelExperience {
    if (_level >= maxLevel) return BigInt.from(maxFinite);
    return experienceFromLevel(_level + 1);
  }

  String get nextLevelExperienceText => internal['next level text'];

  BigInt get previousLevelExperience => experienceFromLevel(_level);

  int get _level => min(internal['lvl'] ?? 1, maxLevel);

  bool ascend() {
    if (_level < maxLevel) return false;
    ascensions++;
    return true;
  }

  BigInt experienceFromLevel(int level) =>
      ExperienceCurve.experienceFromLevel(level) * ascensionMultiplier;

  void recalculate() {
    var previousLevel = _level;
    setExperienceWithoutSplat(experience);
    if (_level < previousLevel) setLevel(previousLevel);
  }

  void setExperienceWithoutSplat(BigInt value) => _setExperience(value, false);

  void setLevel(int value) =>
      _setExperience(experienceFromLevel(min(value, maxLevel)), false);

  int _levelFromExperience(BigInt experience) =>
      ExperienceCurve.levelFromExperience(experience ~/ ascensionMultiplier);

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
