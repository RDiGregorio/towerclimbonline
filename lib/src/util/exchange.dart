part of util;

class Exchange extends OnlineObject {
  Exchange() {
    internal
      ..['buy'] = ObservableMap()
      ..['sell'] = ObservableMap();
  }

  ObservableMap get browseBuyOffers => internal['buy'];

  ObservableMap get browseSellOffers => internal['sell'];

  ExchangeOffer buy(
      String username, String key, BigInt price, BigInt amount, int bonus) {
    var buyOffer = ExchangeOffer(username, key, price, amount, null, bonus),
        sellOffers = _findSellOffers(key, price, bonus);

    for (var i = 0;
        buyOffer.remaining > BigInt.zero && i < sellOffers.length;
        i++) {
      amount = BigIntUtil.min(buyOffer.remaining, sellOffers[i].remaining);
      buyOffer.addBoughtItem(sellOffers[i].soldItem, amount);
      sellOffers[i].progress += amount;
      sellOffers[i].change += sellOffers[i].price * amount;

      if (buyOffer.price > sellOffers[i].price)
        buyOffer.change += (buyOffer.price - sellOffers[i].price) * amount;
    }

    return _buyOffers(key)[buyOffer.id] = buyOffer;
  }

  /// Removes all offers.

  void clear() {
    internal['buy'].clear();
    internal['sell'].clear();
  }

  void close(ExchangeOffer offer) {
    _buyOffers(offer.key).remove(offer.id);
    _sellOffers(offer.key).remove(offer.id);
  }

  ExchangeOffer sell(
      String username, String key, BigInt price, BigInt amount, Item item) {
    var sellOffer = ExchangeOffer(username, key, price, amount, item),
        buyOffers = _findBuyOffers(key, price, item.bonus);

    for (var i = 0;
        sellOffer.remaining > BigInt.zero && i < buyOffers.length;
        i++) {
      amount = BigIntUtil.min(sellOffer.remaining, buyOffers[i].remaining);
      sellOffer.progress += amount;
      sellOffer.change += buyOffers[i].price * amount;
      buyOffers[i].addBoughtItem(item, amount);
    }

    return _sellOffers(key)[sellOffer.id] = sellOffer;
  }

  ExchangeOffer sync(ExchangeOffer offer) =>
      _buyOffers(offer.key)[offer.id] ??
      _sellOffers(offer.key)[offer.id] ??
      offer;

  ObservableMap _buyOffers(String item) =>
      internal['buy'][item] ??= ObservableMap();

  List<dynamic> _findBuyOffers(String item, BigInt price, int bonus) =>

      // Finds buyers for an equal or lower bonus and an equal or higher price.

      _sorted(_buyOffers(item)
          .values
          .where((offer) => offer.bonus <= bonus && offer.price >= price));

  List<dynamic> _findSellOffers(String item, BigInt price, int bonus) =>

      // Finds sellers for an equal or higher bonus or an equal or lower price.

      _sorted(_sellOffers(item)
          .values
          .where((offer) => offer.price <= price && offer.bonus >= bonus));

  ObservableMap _sellOffers(String item) =>
      internal['sell'][item] ??= ObservableMap();

  List<dynamic> _sorted(Iterable<dynamic> offers) => List.from(offers)
    ..sort((first, second) {
      // Lowest price, highest bonus (favors buyers).

      var result = first.price.compareTo(second.price);
      return result != 0 ? result : second.bonus.compareTo(first.bonus);
    });
}
