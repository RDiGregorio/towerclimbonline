part of util;

class Exchange extends OnlineObject {
  Map<String, List<int>> _sellingUpgrades = {}, _buyingUpgrades = {};

  Exchange() {
    internal
      ..['buy'] = ObservableMap()
      ..['sell'] = ObservableMap();
  }

  ObservableMap get browseBuyOffers => internal['buy'];

  ObservableMap get browseSellOffers => internal['sell'];

  ExchangeOffer buy(String username, String item, int price, int amount) {
    var buyOffer = ExchangeOffer(username, item, price, amount),
        sellOffers = _findSellOffers(item, price);

    for (var i = 0; buyOffer.remaining > 0 && i < sellOffers.length; i++) {
      amount = min(buyOffer.remaining, sellOffers[i].remaining);
      buyOffer.progress += amount;
      buyOffer.internal['bought'] ??= sellOffers[i].soldItem;
      sellOffers[i].progress += amount;
      sellOffers[i].change += sellOffers[i].price * amount;

      if (buyOffer.price > sellOffers[i].price)
        buyOffer.change += (buyOffer.price - sellOffers[i].price) * amount;
    }

    return _buyOffers(item)[buyOffer.id] = buyOffer;
  }

  /// Removes invalid buying offers.

  void clean() => Map.from(internal['buy']).forEach((key, value) {
        var item = Item.fromDisplayText(key);

        if (item.displayTextWithoutAmount != key || !item.tradable)
          internal['buy'].remove(key);
      });

  void close(ExchangeOffer offer) {
    _buyOffers(offer.key).remove(offer.id);
    _sellOffers(offer.key).remove(offer.id);
  }

  List<int> findBuyingUpgrades(String key) {
    // TODO: need to index items by their bonuses
    // use getBonus, comparison text, etc

    if (_buyingUpgrades.containsKey(key)) return _buyingUpgrades[key];
    internal['buy'];
    return null;
  }

  List<int> findSellingUpgrades(String key) {
    // TODO: need to index items by their bonuses

    if (_sellingUpgrades.containsKey(key)) return _sellingUpgrades[key];
    internal['sell'];
    return null;
  }

  Item itemFromKey(String key) {
    var offers = _sellOffers(key);
    if (offers.isEmpty) return null;
    return offers.values.first.item.copy;
  }

  ExchangeOffer sell(
      String username, String key, int price, int amount, Item item) {
    var sellOffer = ExchangeOffer(username, key, price, amount, item),
        buyOffers = _findBuyOffers(key, price);

    for (var i = 0; sellOffer.remaining > 0 && i < buyOffers.length; i++) {
      amount = min(sellOffer.remaining, buyOffers[i].remaining);
      sellOffer.progress += amount;
      sellOffer.change += buyOffers[i].price * amount;
      buyOffers[i].progress += amount;
      buyOffers[i].internal['bought'] ??= item.copy;
    }

    return _sellOffers(key)[sellOffer.id] = sellOffer;
  }

  ExchangeOffer sync(ExchangeOffer offer) =>
      _buyOffers(offer.key)[offer.id] ??
      _sellOffers(offer.key)[offer.id] ??
      offer;

  ObservableMap _buyOffers(String item) =>
      internal['buy'][item] ??= ObservableMap();

  List<dynamic> _findBuyOffers(String item, int price) =>
      _sorted(_buyOffers(item).values.where((offer) => offer.price >= price));

  List<dynamic> _findSellOffers(String item, int price) =>
      _sorted(_sellOffers(item).values.where((offer) => offer.price <= price));

  ObservableMap _sellOffers(String item) =>
      internal['sell'][item] ??= ObservableMap();

  List<dynamic> _sorted(Iterable<dynamic> offers) => List.from(offers)
    ..sort((first, second) => first.price.compareTo(second.price));
}
