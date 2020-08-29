part of util;

/// Generally, [veryVeryFast] and [veryVerySlow] should be avoided.

class CoolDown {
  static const int veryVeryFast = 600,
      veryFast = 1200,
      fast = 1800,
      average = 2400,
      slow = 3000,
      verySlow = 3600,
      veryVerySlow = 4200;
}
