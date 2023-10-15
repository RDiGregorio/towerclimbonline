part of util;

class PathFinder {
  Map<Point<int>, Node> nodes = {};
  List<List<int?>>? path;
  Point<int> target;

  PathFinder(this.target);
}
