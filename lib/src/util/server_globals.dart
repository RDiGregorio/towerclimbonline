part of util;

/// Used primarily server side. Some values may also be used client side.

class ServerGlobals {
  static Set<dynamic> sockets = Set();
  static bool shuttingDown = false;
  static Stage playerSpawnStage = null;

  static const int sight = 10,
      tickDelay = 200,
      timeBonusMultiplier = 24,
      temporaryBossMinutes = 5,

      // To maximize experience and drops, players should try to average 1 hour
      // a day for a month.

      maxTimeBonus = millisecondsPerDay * 30;
}
