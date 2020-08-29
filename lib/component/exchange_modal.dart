import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:towerclimbonline/client.dart';
import 'package:towerclimbonline/util.dart';

@Component(
    selector: 'exchange-modal',
    directives: [coreDirectives, formDirectives],
    templateUrl: 'exchange_modal.html')
class ExchangeModal {
  String item = '', price = '', amount = '';
  List<ExchangeOffer> exchangeBrowser = const [];

  Iterable<ExchangeOffer> get buyOffers =>
      List<ExchangeOffer>.from(ClientGlobals.session.exchangeBuyOffers.values);

  Iterable<ExchangeOffer> get sellOffers =>
      List<ExchangeOffer>.from(ClientGlobals.session.exchangeSellOffers.values);

  void browseBuy() => _browse('buy');

  void browseSell() => _browse('sell');

  void buy() {
    ClientGlobals.session.remote(#exchangeBuy,
        [item.trim().toLowerCase(), parseInteger(price), parseInteger(amount)]);

    _reset();
  }

  void close(ExchangeOffer offer) {
    ClientGlobals.session.remote(#exchangeClose, [offer.id]);
    _reset();
  }

  bool disabled(String input) =>
      input == null ||
      input.isEmpty ||
      !input.toLowerCase().contains(numberPattern) ||
      parseInteger(input) < 1;

  String formatBrowsingOffer(ExchangeOffer offer) {
    var result = offer.soldItem != null ? 'sell ' : 'buy ';
    result += offer.key;
    result += ' (${formatCurrency(offer.price)})';
    return result;
  }

  String formatOffer(ExchangeOffer offer) {
    var result = offer.soldItem != null ? 'sell ' : 'buy ';
    result += offer.key;

    result +=
        ' (${formatNumber(offer.progress)}/${formatNumber(offer.amount)})';

    return result;
  }

  void sell() {
    ClientGlobals.session.remote(#exchangeSell,
        [item.trim().toLowerCase(), parseInteger(price), parseInteger(amount)]);

    _reset();
  }

  void _browse(String key) {
    Future(() async {
      var result = await ClientGlobals.session.remote(#browseExchange, [key]);
      var list = <ExchangeOffer>[];

      result.values.forEach((map) => map.values
          .where((offer) => !offer.complete)
          .forEach((offer) => list.add(offer)));

      exchangeBrowser = _sortedOffers(list);
    });
  }

  void _reset() {
    item = price = amount = '';
    exchangeBrowser = const [];
  }

  Iterable<ExchangeOffer> _sortedOffers(Iterable<ExchangeOffer> offers) =>
      List.from(offers)
        ..sort((first, second) => compareItemNames(first.key, second.key));
}
