part of util;

/// Uses an R-tree internally for fast searches.

class Space<E> {
  RTree<E> _tree = RTree();
  Expando<RTreeDatum<E>> _expando = Expando();

  void add(Point<num> location, E value) {
    remove(value);

    _tree.insert(_expando[value!] =
        RTreeDatum(Rectangle(location.x, location.y, 1, 1), value));
  }

  void remove(E value) {
    if (_expando[value!] != null) {
      _tree.remove(_expando[value]!);
      _expando[value] = null;
    }
  }

  Iterable<E> search(Rectangle<num> rectangle) => _tree
      .search(Rectangle(rectangle.left, rectangle.top, rectangle.width + 1,
          rectangle.height + 1))
      .where((datum) => rectangle.containsPoint(datum.rect.topLeft))
      .map((datum) => datum.value);
}
