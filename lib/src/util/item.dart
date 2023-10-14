part of util;

/// If an ego or something similar needs to be stripped from an item, it can be
/// done on login.

class Item extends OnlineObject {
  static const String dummyItemName = 'error';
  static RegExp _bonus = RegExp(r'\+\d+ ');
  static const int _basePrice = 10;
  String _comparisonText, _displayTextWithoutAmount, _amountText, _displayText;

  Item([String infoName, int amount = 1, List<int> egos]) {
    if (infoName?.isNotEmpty != true) return;

    infoName = infoName?.trim()?.toLowerCase();
    var bonus;

    if (infoName?.startsWith(_bonus) == true) {
      infoName = infoName.replaceFirstMapped(_bonus, (match) {
        bonus = int.parse(match[0]);
        return '';
      });
    }

    internal
      ..['info'] = infoName
      ..['amount'] = amount
      ..['egos'] = egos
      ..['bonus'] = bonus;

    _updateAmountText();
  }

  factory Item.fromDisplayText(String text) {
    text = text.toLowerCase();
    var bonus = 0;

    if (text.startsWith(_bonus))
      text = text.replaceFirstMapped(_bonus, (match) {
        bonus = max(0, int.parse(match[0]));
        return '';
      });

    var infoName = itemInfoName(text);

    // Returns a dummy item if the item doesn't exist.

    if (infoName == null) return Item(dummyItemName);
    text = removeLast(text, infoName);
    var item = Item(infoName);

    if (item.canUpgrade)
      item = Item(infoName, 1, Ego.parse(text))..bonus = bonus;

    return item;
  }

  int get accuracy => info?.accuracy ?? 0;

  int get amount => small(internal['amount']);

  void set amount(int amount) {
    internal['amount'] = amount;
    _updateAmountText();
  }

  String get amountText => internal['amount text'];

  void set amountText(String text) {
    internal['amount text'] = text;
  }

  int get attackRange =>
      egos.contains(Ego.ballistic) || egos.contains(Ego.magic) ? 5 : 1;

  int get bonus => internal['bonus'] ?? 0;

  void set bonus(int value) {
    // Clears cached display text to allow it to be recalculated.

    _comparisonText = null;
    _displayTextWithoutAmount = null;
    internal['bonus'] = value;
  }

  bool get canUpgrade {
    if (infoName == null || getAmount() <= BigInt.zero) return false;
    if (food) return true;
    if (equipment) return info.slot != #thrown;
    if (potion) return true;

    return const ['nuclear reactor', 'philosopher\'s stone', 'puzzle box']
        .contains(infoName);
  }

  /// Returns the display text without the bonus or amount.

  String get comparisonText {
    if (_comparisonText != null) return _comparisonText;
    var result = infoName;

    // Egos are sorted alphabetically.

    (List.from((internal['egos'] ?? const [])
            .map((ego) => Ego.descriptions[ego] ?? 'error'))
          ..sort())
        .reversed
        .forEach((ego) => result = '$ego $result');

    return _comparisonText = result;
  }

  bool get consumable =>
      food || (potion && !equipment) || infoName == 'nuclear bomb';

  /// Returns a copy of this [Item] with a different [id].

  Item get copy {
    var result = Item(), id = result.id;

    return result
      ..internal.addAll(internal)
      ..internal['id'] = id;
  }

  int get damage => info?.damage ?? 0;

  int get defense => info?.defense ?? 0;

  String get displayText {
    var result = displayTextWithoutAmount;
    if (amount == 1) return result;

    return _amountText == amountText
        ? _displayText
        : _displayText =
            '$result × ${formatCurrency(_amountText = amountText, false)}';
  }

  String get displayTextWithoutAmount {
    if (_displayTextWithoutAmount != null) return _displayTextWithoutAmount;
    var result = infoName;

    // Egos are sorted alphabetically.

    (List.from((internal['egos'] ?? const [])
            .map((ego) => Ego.descriptions[ego] ?? 'error'))
          ..sort())
        .reversed
        .forEach((ego) => result = '$ego $result');

    if (bonus != 0) result = '+$bonus $result';
    return _displayTextWithoutAmount = result;
  }

  List<int> get egos {
    var result = List<int>.from(info?.egos ?? const [])
      ..addAll(List<int>.from(internal['egos'] ?? const []));

    if (result.contains(Ego.crystal)) result.remove(Ego.metal);

    if (result.contains(Ego.rainbow))
      result
        ..remove(Ego.rainbow)
        ..addAll([
          Ego.electric,
          Ego.fire,
          Ego.ice,
          Ego.gravity,
          Ego.acid,
          Ego.poison
        ]);

    if (result.contains(Ego.demon))
      result
        ..remove(Ego.demon)
        ..addAll([Ego.sickness, Ego.confusion, Ego.blindness]);

    if (info?.slot == #weapon &&
        ![Ego.ballistic, Ego.magic, Ego.charm].any(result.contains))
      result.add(Ego.melee);

    return result;
  }

  bool get equipment => info?.slot != null;

  int get evasion => info?.evasion ?? 0;

  bool get food => egos.contains(Ego.food);

  num get healingAmount => min<num>(100, info.heal + info.heal * bonus / 100);

  ItemInfo get info => _itemInfo[infoName];

  String get infoName => internal['info'];

  Set<String> get ingredients =>
      Set<String>.from(Crafting.craftedTo(comparisonText).map((text) {
        var item = Item.fromDisplayText(text);
        if (item.canUpgrade) item.bonus = bonus;
        return item.displayTextWithoutAmount;
      }));

  String get missile {
    var result = null, egoSet = Set<int>.from(egos);
    if (!egoSet.contains(Ego.magic)) return null;

    Set<int> colors = Set.from([
          Ego.fire,
          Ego.ice,
          Ego.electric,
          Ego.gravity,
          Ego.acid,
          Ego.poison
        ]),
        intersection = Set.from(egoSet.where(colors.contains));

    if (intersection.length > 1) return result;
    if (intersection.contains(Ego.fire)) return 'image/missile/red_bolt.png';
    if (intersection.contains(Ego.ice)) return 'image/missile/cyan_bolt.png';
    if (intersection.contains(Ego.acid)) return 'image/missile/brown_bolt.png';

    if (intersection.contains(Ego.electric))
      return 'image/missile/yellow_bolt.png';

    if (intersection.contains(Ego.gravity))
      return 'image/missile/black_bolt.png';

    if (intersection.contains(Ego.poison))
      return 'image/missile/green_bolt.png';

    return result;
  }

  bool get potion => displayTextWithoutAmount.contains('potion');

  BigInt get price => big(internal['price'] ?? _basePrice);

  bool get scroll => displayTextWithoutAmount.contains('scroll');

  int get sellingPrice {
    if (!tradable) return 0;
    return _basePrice ~/ 2;
  }

  Map<String, String> get style => const {};

  String get text {
    var result = '$infoName',
        combination = Set.from(internal['egos'] ?? const [])
            .fold(0, (result, ego) => result + (pow(2, ego)));

    if (combination != 0) result = '$result $combination';
    if (bonus != 0) result = '+$bonus $result';
    return result;
  }

  bool get thrown => info?.slot == #thrown;

  bool get tool => [Ego.mining, Ego.fishing, Ego.gathering].any(egos.contains);

  bool get tradable => true;

  bool get twoHanded => egos.contains(Ego.twoHanded);

  bool get upgradesIncreaseEvasion => info?.slot == #cloak;

  /// Adds a [BigInt].

  void addAmount(dynamic amount) {
    setAmount(big(internal['amount']) + big(amount));
  }

  Item copyWithEgos(Iterable<int> egos) {
    var result = copy;
    result.internal['egos'] ??= [];

    egos.forEach((ego) {
      if (!result.egos.contains(ego)) result.internal['egos'].add(ego);
    });

    return result;
  }

  String examineText(CharacterSheet sheet) {
    if (food) return 'heals ${healingAmount.toStringAsFixed(2)}% health';

    if (thrown) {
      var intBuffs = sheet.intelligenceBuffs, dexBuffs = sheet.dexterityBuffs;
      return 'attacks target with +$intBuffs% damage and +$dexBuffs% accuracy';
    }

    if (infoName == 'agility potion') return '+50% agility';
    if (infoName == 'strength potion') return '+50% strength';
    if (infoName == 'dexterity potion') return '+50% dexterity';
    if (infoName == 'intelligence potion') return '+50% intelligence';
    if (infoName == 'puzzle box') return 'a mesmerizing puzzle box';

    if (infoName == 'philosopher\'s stone') {
      var gold = formatNumberWithPrecision(1 + safeLog(bonus));
      return 'converts 1 blood potion to $gold gold';
    }

    if (infoName == 'nuclear reactor') {
      var energy = formatNumberWithPrecision(1 + safeLog(bonus));
      return 'converts 1 uranium to $energy energy';
    }

    if (infoName == 'nuclear bomb')
      return 'kills all targets without reward' +
          ' except for bosses, players, and pets';

    if (egos.contains(Ego.fishing)) {
      var modifier = bonus;
      return '+${formatNumber(modifier)}% fishing';
    }

    if (egos.contains(Ego.mining)) {
      var modifier = bonus;
      return '+${formatNumber(modifier)}% mining';
    }

    if (egos.contains(Ego.gathering)) {
      var modifier = bonus;
      return '+${formatNumber(modifier)}% gathering';
    }

    if (egos.contains(Ego.thieving)) {
      // Having multiple +25% stealth items makes up for not having something
      // like a mining helmet for stealth.

      var modifier = bonus;
      return '+${formatNumber(modifier)}% stealth';
    }

    return null;
  }

  /// Returns a [BigInt].

  BigInt getAmount() {
    return big(internal['amount']);
  }

  /// Removes a [BigInt].

  void removeAmount(dynamic amount) {
    setAmount(big(internal['amount']) - big(amount));
  }

  /// Sets a [BigInt].

  void setAmount(dynamic amount) {
    internal['amount'] = formatNumber(amount);
    _updateAmountText();
  }

  void _updateAmountText() {
    amountText = formatNumber(internal['amount']);
  }
}
