part of util;

class ExperienceRate {
  CharacterSheet _sheet;
  late int _startingMilliseconds;
  late BigInt _startingExperience;

  ExperienceRate(this._sheet) {
    _startingMilliseconds = now;
    _startingExperience = _sheet.totalExperience;
  }

  int get experiencePerHour {
    var elapsed = round(_elapsedMilliseconds, -3);

    return elapsed <= 0
        ? 0
        : _gainedExperience * millisecondsPerHour ~/ elapsed;
  }

  int get _elapsedMilliseconds => now - _startingMilliseconds;

  int get _gainedExperience =>
      (_sheet.totalExperience - _startingExperience).toInt();
}
