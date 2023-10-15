import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:towerclimbonline/client.dart';
import 'package:towerclimbonline/util.dart';

@Component(
    selector: 'exchange-modal',
    directives: [coreDirectives, formDirectives],
    templateUrl: 'exchange_modal.html')
class ExchangeModal {
  String? item = '', price = '', amount = '', mode = 'buy';
  List<ExchangeOffer> exchangeBrowser = const [];
  List<Item>? _sortedItems;
  bool browsing = false;

  Iterable<ExchangeOffer> get buyOffers =>
      List<ExchangeOffer>.from(ClientGlobals.session!.exchangeBuyOffers!.values);

  String? get exchangeMode => mode;

  void set exchangeMode(String? mode) => setMode(mode);

  Map<String, Item> get items =>
      Map<String, Item>.from(ClientGlobals.session!.items?.items ?? const {});

  Iterable<ExchangeOffer> get sellOffers =>
      List<ExchangeOffer>.from(ClientGlobals.session!.exchangeSellOffers!.values);

  List<Item> get sortedItems =>
      _sortedItems ??= List<Item>.from(items.values)..sort(compareItems as int Function(Item, Item)?);

  void browseBuy() => _browse('buy');

  void browseSell() => _browse('sell');

  void buy() async {
    await ClientGlobals.session!
        .remote(#exchangeBuy, [item!.trim().toLowerCase(), price, amount]);

    Future.delayed(Duration(milliseconds: ServerGlobals.tickDelay), _reset);
  }

  void clickBrowsedOffer(ExchangeOffer offer) {
    if (offer.soldItem != null)
      // The player wants to buy [offer].

      setMode('buy', offer);
    else {
      // The player wants to sell [offer].

      List<Item> matches = List<Item>.from(items.values.where((Item item) =>
          item.comparisonText == offer.key && item.bonus >= offer.bonus));

      if (matches.isEmpty) {
        ClientGlobals.session!.alert('You don\'t have any of that item.');
        return;
      }

      // The match with the smallest bonus is used.

      var match = matches
          .reduce((left, right) => left.bonus < right.bonus ? left : right);

      setMode('sell', offer, match.bonus);
    }
  }

  void close(ExchangeOffer offer) async {
    await ClientGlobals.session!.remote(#exchangeClose, [offer.id]);
    Future.delayed(Duration(milliseconds: ServerGlobals.tickDelay), _reset);
  }

  bool disabled(String input) =>
      input == null ||
      input.isEmpty ||
      !input.toLowerCase().contains(numberPattern) ||
      parseInteger(input)! < 1;

  bool disabledItem(String input) => input == null || input.trim().isEmpty;

  String formatBrowsingOffer(ExchangeOffer offer) {
    var result = offer.soldItem != null ? 'sell ' : 'buy ', key = offer.key;
    if (offer.bonus > 0) key = '+${offer.bonus} $key';
    result += key!;

    // The maximum displayed price is only client side.

    var offerPrice = BigIntUtil.min(offer.price!, maxInput);
    result += ' (${formatCurrency(offerPrice)})';
    return result;
  }

  String formatOffer(ExchangeOffer offer) {
    var result = offer.soldItem != null ? 'sell ' : 'buy ', key = offer.key;
    if (offer.bonus > 0) key = '+${offer.bonus} $key';
    result += key!;

    result += ' (${formatCurrency(offer.progress, false)}' +
        '/${formatCurrency(offer.amount, false)})';

    return result;
  }

  void offer() {
    mode == 'buy' ? buy() : sell();
  }

  void sell() async {
    await ClientGlobals.session!
        .remote(#exchangeSell, [item!.trim().toLowerCase(), price, amount]);

    Future.delayed(Duration(milliseconds: ServerGlobals.tickDelay), _reset);
  }

  void setMode(String? value, [ExchangeOffer? offer, int? bonus]) {
    if (mode == value) return;
    mode = value;
    _reset();
    if (offer == null) return;
    var key = offer.key;
    bonus ??= offer.bonus;
    if (bonus > 0) key = '+$bonus $key';
    item = key;
    var offerPrice = BigIntUtil.min(offer.price!, ClientGlobals.session!.gold!);
    price = '$offerPrice';
    amount = '1';
  }

  void _browse(String key) {
    Future(() async {
      var result = await ClientGlobals.session!.remote(#browseExchange, [key]);
      var list = <ExchangeOffer>[];

      result.values.forEach((map) => map.values
          .where((offer) => !offer.complete)
          .forEach((offer) => list.add(offer)));

      exchangeBrowser = _sortedOffers(list) as List<ExchangeOffer>;
      browsing = true;
    });
  }

  void _reset() {
    browsing = false;
    item = price = amount = '';
    exchangeBrowser = [];
    _sortedItems = null;
  }

  Iterable<ExchangeOffer> _sortedOffers(Iterable<ExchangeOffer> offers) =>
      List.from(offers)
        ..sort((first, second) => compareItemNames(first.key!, second.key!));
}
