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

  String get text {
    var result = <String>[];

    String format(dynamic item, [num rate]) {
      var result = item.displayText;

      if (rate != null)
        result += ' (${formatNumberWithPrecision(rate * 100)}%)';

      return result;
    }

    _always.forEach((function) => result.add(format(function(), 1)));

    _uncommon.forEach((function) =>
        result.add(format(function(), 1 / 10 / _uncommon.length)));

    _rare.forEach(
        (function) => result.add(format(function(), 1 / 100 / _rare.length)));

    _random.forEach(
        (function) => result.add(format(function(), 1 / _random.length)));

    return result.join(', ');
  }

  List<Item> get drops {
    var result = <Item>[];

    add(list) {
      var function = randomValue(list);
      if (function != null) result.add(function());
    }

    _always.forEach((function) => result.add(function()));
    // Uncommon drops are at 10% and rare drops are at 1%.

    if (randomDouble < 0.1) add(_uncommon);
    if (randomDouble < 0.01) add(_rare);

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
