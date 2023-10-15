part of util;

class ExchangeOffer extends OnlineObject {
  ExchangeOffer(
      [String? username,
      String? key,
      BigInt? price,
      BigInt? amount,
      Item? soldItem,
      int? bonus]) {
    internal
      ..['name'] = username
      ..['key'] = key?.trim()
      ..['price'] = '$price'
      ..['amount'] = '$amount'
      ..['change'] = '0'
      ..['progress'] = '0'
      ..['sold'] = soldItem?.copy
      ..['bought'] = ObservableMap()
      ..['bonus'] = bonus;
  }

  BigInt? get amount => big(internal['amount']);

  int get bonus {
    if (soldItem != null) return soldItem!.bonus;
    return internal['bonus'] ?? 0;
  }

  List<Item> get boughtItems => List<Item>.from(internal['bought'].values);

  BigInt? get change => big(internal['change']);

  void set change(BigInt? change) {
    internal['change'] = '$change';
  }

  bool get complete => remaining <= BigInt.zero;

  String? get key => internal['key']?.trim();

  BigInt? get price => big(internal['price']);

  BigInt? get progress => big(internal['progress']);

  void set progress(BigInt? progress) {
    internal['progress'] = '$progress';
  }

  BigInt get remaining => amount! - progress!;

  /// Returns the item being sold if there is one. Returns null if this is an
  /// offer to buy.

  Item? get soldItem => internal['sold'];

  String? get username => internal['name'];

  void addBoughtItem(Item item, BigInt amount) {
    var copy = item.copy;
    copy.setAmount(amount);
    internal['bought'][copy.id] = copy;
    progress += amount;
  }
}
