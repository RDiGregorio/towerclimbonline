part of util;

class ItemContainer extends OnlineObject {
  ItemContainer() {
    internal['items'] = ObservableMap();
  }

  /// Items are stored by their display text without amounts.

  Map<String, dynamic> get items => UnmodifiableMapView(internal['items']);

  /// The amount added is [item.amount * amountMultiplier].

  void addItem(Item item, [int amountMultiplier = 1]) {
    var text = item.text, stack = items[text];
    var newAmount = item.getAmount() * BigInt.from(amountMultiplier);

    if (stack == null) {
      item.setAmount(newAmount);
      internal['items'][text] = item;
      return;
    }

    stack.addAmount(newAmount);
  }

  bool containsAll(ItemContainer container) =>
      container.items.values.every((item) => count(item.text) >= item.amount);

  int count(String text) => items[text]?.amount ?? 0;

  bool deleteItem(Item item) {
    var result = false;

    List.from(items.keys).forEach((key) {
      if (item == internal['items'][key]) {
        internal['items'].remove(key);
        result = true;
      }
    });

    return result;
  }

  /// [text] can be either an item's id or key.

  Item getItem(String text) =>
      internal['items'][text] ??
      items.values.firstWhere((item) => item.id == text, orElse: () => null);

  Item getItemByDisplayText(String text) =>
      items.values.firstWhere((item) => item.displayTextWithoutAmount == text,
          orElse: () => null);

  void removeAll(ItemContainer container) => container.items.values
      .forEach((item) => removeItem(item.text, item.amount));

  bool removeItem(String text, [int amount = 1]) {
    if (amount < 1) return false;
    var item = getItem(text);
    if (item == null || item.amount < amount) return false;
    item.removeAmount(amount);
    if (item.amount <= 0) internal['items'].remove(item.text);
    return true;
  }

  /// Warning: dangerous function. If [beforeTest] returns true, the item is
  /// destroyed and replaced with [after].

  void replaceAll(bool beforeTest(Item item), Item after(),
      {bool carryAmount = true,
      bool carryBonus = true,
      bool multiplyAmounts = false}) {
    assert(!carryAmount || !multiplyAmounts);
    var values = List.from(items.values);

    for (var i = 0; i < values.length; i++) {
      Item beforeItem = values[i];

      if (beforeTest(values[i])) {
        deleteItem(beforeItem);
        var afterItem = after();

        if (carryAmount)
          afterItem.amount = beforeItem.amount;
        else if (multiplyAmounts) afterItem.amount *= beforeItem.amount;

        if (carryBonus) afterItem.bonus = beforeItem.bonus;
        addItem(afterItem);
      }
    }
  }
}
