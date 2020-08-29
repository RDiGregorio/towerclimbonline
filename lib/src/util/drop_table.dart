part of util;

class DropTable {
  List<Function> _always = [], _uncommon = [], _rare = [], _random = [];

  List<Item> get all {
    var result = <Item>[];
    _always.forEach((function) => result.add(function()));
    _uncommon.forEach((function) => result.add(function()));
    _rare.forEach((function) => result.add(function()));
    _random.forEach((function) => result.add(function()));
    return result;
  }

  List<Item> get drops {
    var result = <Item>[];

    add(list) {
      var function = randomValue(list);
      if (function != null) result.add(function());
    }

    _always.forEach((function) => result.add(function()));
    var value = randomDouble;

    // Uncommon drops are at 10% and rare drops are at 1%.

    if (value < 0.1) add(_uncommon);
    if (value < 0.01) add(_rare);

    // An item from the random items is always dropped.

    if (_random.isNotEmpty) {
      var function = randomValue(_random);
      result.add(function());
    }

    return result;
  }

  void addAlways(Item function()) => _always.add(function);

  void addRandom(Item function()) => _random.add(function);

  void addRare(Item function()) => _rare.add(function);

  void addUncommon(Item function()) => _uncommon.add(function);
}
