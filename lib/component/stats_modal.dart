import 'dart:math';

import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:towerclimbonline/client.dart';
import 'package:towerclimbonline/util.dart';

@Component(
    selector: 'stats-modal',
    directives: [coreDirectives, formDirectives],
    templateUrl: 'stats_modal.html')
class StatsModal {
  static ExperienceRate tracker;
  int step = 1;

  int get agilityBuffs => sheet.agilityBuffs;

  int get dexterityBuffs => sheet.dexterityBuffs;

  String get experiencePerHour =>
      formatCurrency(max<int>(0, tracker.experiencePerHour), false);

  String get god => godName(ClientGlobals.session.god) ?? 'none';

  int get healthBuffs => sheet.healthBuffs;

  int get intelligenceBuffs => sheet.intelligenceBuffs;

  CharacterSheet get sheet => ClientGlobals.session.sheet;

  int get strengthBuffs => sheet.strengthBuffs;

  String get xpMode => ClientGlobals.session.options['xp mode'] ?? 'default';

  void set xpMode(String mode) {
    ClientGlobals.session.remote(#setOption, ['xp mode', mode]);
  }

  void ascend(Stat stat) {
    ClientGlobals.session.remote(#ascend, [stat.id]);
  }

  String displayAscensions(Stat stat) =>
      stat.ascensions < 1 ? '' : ' × ${stat.ascensions + 1}';

  String displayExperience(Stat stat) {
    var result = stat.internalLevel < Stat.maxLevel
        ? '${formatCurrency(stat.experienceText, false)}' +
            ' / ${formatCurrency(stat.nextLevelExperienceText, false)}'
        : formatCurrency(stat.experienceText, false);

    return '$result experience';
  }

  String displayNumber(int value) => formatNumber(value);

  String displayNumberWithPrecision(num value) =>
      formatNumberWithPrecision(value);

  String displayTotalExperience(String experience) =>
      formatCurrency(experience, false);

  String formatStatBuff(int statBuff) => formatNumber(statBuff);

  void gainStat(String stat) {
    if (sheet.unspentPoints > 0 || step == -1)
      ClientGlobals.session.remote(#gainStat, [stat, step]);
  }

  bool isMaxLevel(Stat stat) => stat.internalLevel >= Stat.maxLevel;

  String progress(Stat stat) {
    num percent = 0;

    try {
      percent = stat == null
          ? 0
          : (stat.experience - stat.previousLevelExperience) *
              BigInt.from(100) /
              (stat.nextLevelExperience - stat.previousLevelExperience);
    } catch (error) {
      // Caused by very large numbers.
    }

    return formatNumberWithPrecision(percent);
  }

  void resetStats() {
    ClientGlobals.session.remote(#resetStats, const []);
  }

  void track() {
    tracker = ExperienceRate(ClientGlobals.session.sheet);
  }
}
