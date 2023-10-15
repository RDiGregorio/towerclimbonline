import 'dart:html';

import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:towerclimbonline/client.dart';
import 'package:towerclimbonline/util.dart';

@Component(
    selector: 'trade-modal',
    directives: [coreDirectives, formDirectives],
    templateUrl: 'trade_modal.html')
class TradeModal {
  late List<Item> _sortedItems;

  // The modals with search inputs are: action, item, crafting, and trade.

  String searchInput = '';

  TradeModal() {
    _sortedItems = List<Item>.from(items.values)..sort(compareItems as int Function(Item, Item)?);
  }

  bool get accepted => ClientGlobals.tradeAccepted;

  BigInt? get gold => ClientGlobals.session!.gold;

  String get itemClasses =>
      youFinalizedTrade && theyFinalizedTrade ? 'disabled' : '';

  Map<String, dynamic> get items =>
      ClientGlobals.session!.items?.items ?? const {};

  Iterable<Item> get sortedItems =>
      _sortedItems.where((item) => item.displayTextWithoutAmount!
          .toLowerCase()
          .contains(searchInput.toLowerCase()));

  String get theirTradeGold =>
      formatCurrency(ClientGlobals.session!.targetTradeGold);

  Map<String, Item> get theirTradeOffer => Map<String, Item>.from(
      ClientGlobals.session!.targetTradeOffer?.items ?? const {});

  bool get theyFinalizedTrade => ClientGlobals.session!.theyFinalizedTrade;

  bool get youFinalizedTrade => ClientGlobals.session!.youFinalizedTrade;

  String get yourTradeGold => formatCurrency(ClientGlobals.session!.tradeGold);

  Map<String, Item> get yourTradeOffer =>
      Map<String, Item>.from(ClientGlobals.session!.tradeOffer?.items ?? {});

  void addTradeGold() {
    showInputModal('Amount (coins)', 'add gold',
        (input) => ClientGlobals.session!.remote(#addTradeGold, [input]));

    querySelector('#input-modal-toggle')!.click();
  }

  void addTradeItem(Item item) {
    if (youFinalizedTrade && theyFinalizedTrade) return;

    showInputModal(
        'Amount (${item.displayTextWithoutAmount})',
        'add item',
        (input) =>
            ClientGlobals.session!.remote(#addTradeItem, [item.id, input]));

    querySelector('#input-modal-toggle')!.click();
  }

  void complete() {
    ClientGlobals.tradeAccepted = true;
    ClientGlobals.session!.remote(#completeTrade, const []);
  }

  void finalize() {
    ClientGlobals.session!.remote(#finalizeTrade, const []);
  }

  String format(dynamic gold) => formatNumber(gold);

  String formatGold(dynamic value) => formatCurrency(value);

  Map<String, String> goldStyle(int value) => currencyStyle(value);

  String? itemName(Item item) {
    try {
      return item.displayText;
    } catch (error) {
      return missingItemName;
    }
  }

  void removeTradeGold() {
    if (youFinalizedTrade && theyFinalizedTrade) return;

    showInputModal('Amount (coins)', 'remove gold',
        (input) => ClientGlobals.session!.remote(#removeTradeGold, [input]));

    querySelector('#input-modal-toggle')!.click();
  }

  void removeTradeItem(Item item) {
    if (youFinalizedTrade && theyFinalizedTrade) return;

    showInputModal(
        'Amount (${item.displayTextWithoutAmount})',
        'remove item',
        (input) =>
            ClientGlobals.session!.remote(#removeTradeItem, [item.id, input]));

    querySelector('#input-modal-toggle')!.click();
  }
}
