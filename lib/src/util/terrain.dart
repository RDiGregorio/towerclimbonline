part of util;

/// Higher values take precedence over lower values for things like collision
/// detection. Negative values are not supported.

class Terrain {
  static const int land = 0, doll = 1, water = 2, obstacles = 3, walls = 4;
}
