part of util;

class ItemContainer extends OnlineObject {
  ItemContainer() {
    internal['items'] = ObservableMap();
  }

  /// Items are stored by their display text without amounts.

  Map<String, dynamic> get items => UnmodifiableMapView(internal['items']);

  /// The amount added is [item.amount * amountMultiplier].

  void addItem(Item item, [dynamic amountMultiplier = 1]) {
    var text = item.text, stack = items[text];
    var newAmount = item.getAmount()! * big(amountMultiplier)!;

    if (stack == null) {
      item.setAmount(newAmount);
      internal['items'][text] = item;
      return;
    }

    stack.addAmount(newAmount);
  }

  BigInt bigCount(String text) => items[text]?.getAmount() ?? BigInt.zero;

  bool containsAll(ItemContainer container) =>
      container.items.values.every((item) => count(item.text) >= item.amount);

  int count(String? text) => items[text]?.amount ?? 0;

  bool deleteItem(Item? item) {
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

  Item? getItem(String? text) =>
      internal['items'][text] ??
      items.values.firstWhere((item) => item.id == text, orElse: () => null);

  Item? getItemByDisplayText(String text) =>
      items.values.firstWhere((item) => item.displayTextWithoutAmount == text,
          orElse: () => null);

  List<Item> getItemsByComparisonText(String? text) => List<Item>.from(
      items.values.where((item) => item.comparisonText == text));

  void removeAll(ItemContainer container) => container.items.values
      .forEach((item) => removeItem(item.text, item.getAmount()));

  bool removeItem(String? text, [dynamic amount = 1]) {
    amount = big(amount);
    if (amount < BigInt.one) return false;
    var item = getItem(text);
    if (item == null || item.getAmount()! < amount) return false;
    item.removeAmount(amount);
    if (item.getAmount()! <= BigInt.zero) internal['items'].remove(item.text);
    return true;
  }
}
