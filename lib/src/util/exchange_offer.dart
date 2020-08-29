part of util;

class ExchangeOffer extends OnlineObject {
  ExchangeOffer(
      [String username, String key, int price, int amount, Item soldItem]) {
    internal
      ..['name'] = username
      ..['key'] = key?.trim()
      ..['price'] = price
      ..['amount'] = amount
      ..['change'] = 0
      ..['progress'] = 0
      ..['sold'] = soldItem?.copy;
  }

  int get amount => internal['amount'];

  Item get boughtItem {
    if (internal['bought'] == null) return null;
    return internal['bought'].copy..amount = 1;
  }

  int get change => internal['change'];

  void set change(int change) {
    internal['change'] = change;
  }

  bool get complete => remaining <= 0;

  String get key => internal['key']?.trim();

  int get price => internal['price'];

  int get progress => internal['progress'];

  void set progress(int progress) {
    internal['progress'] = progress;
  }

  int get remaining => amount - progress;

  /// Returns the item being sold if there is one. Returns null if this is an
  /// offer to buy.

  Item get soldItem {
    if (internal['sold'] == null) return null;
    return internal['sold'].copy..amount = 1;
  }

  String get username => internal['name'];
}
