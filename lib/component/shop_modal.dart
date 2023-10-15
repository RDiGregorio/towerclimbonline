import 'dart:async';
import 'dart:html';

import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:towerclimbonline/client.dart';
import 'package:towerclimbonline/util.dart';

@Component(
    selector: 'shop-modal',
    directives: [coreDirectives, formDirectives],
    templateUrl: 'shop_modal.html',
    changeDetection: ChangeDetectionStrategy.OnPush)
class ShopModal implements OnDestroy {
  List<Item> sortedItems = [];
  String? filter, searchInput = '';
  final ChangeDetectorRef _changeDetectorRef;

  late StreamSubscription<ObservableEvent> _subscription;
  ShopModal(this._changeDetectorRef) {
    _subscription = ClientGlobals.session!.internal.getEvents(
        type: 'change', path: ['items']).listen((event) => _updateItems());

    Future(_updateItems);
  }

  Iterable<Item> get displayedItems => sortedItems.where((item) =>
      item.displayTextWithoutAmount!
          .toLowerCase()
          .contains(searchInput!.toLowerCase()) &&
      item.amount > 0);

  Map<String?, dynamic> get items =>
      ClientGlobals.session!.items?.items ?? const {};

  Map<String?, dynamic> get shopItems =>
      ClientGlobals.session!.shopItems ?? const {};

  List<Item> get sortedShopItems =>
      List<Item>.from(shopItems.values)..sort(compareItems as int Function(Item, Item)?);

  void buyItem(Item item) {
    showInputModal(
        'Amount (${item.displayTextWithoutAmount})',
        'buy',
        (input) async =>
            await ClientGlobals.session!.remote(#buyItem, [item.id, input]));

    querySelector('#input-modal-toggle')!.click();
  }

  String formatBuyingPrice(Item item) => formatCurrency(item.price);

  String formatSellingPrice(Item item) => formatCurrency(item.sellingPrice);

  String? itemImage(Item item) => item.info!.image;

  String? itemName(Item item) => item.displayText;

  void ngOnDestroy() {
    _subscription.cancel();
  }

  void sellItem(Item item) {
    showInputModal('Amount (${item.displayTextWithoutAmount})', 'sell',
        (input) => ClientGlobals.session!.remote(#sellItem, [item.id, input]));

    querySelector('#input-modal-toggle')!.click();
  }

  void _updateItems() {
    sortedItems = List<Item>.from(items.values)..sort(compareItems as int Function(Item, Item)?);
    _changeDetectorRef.markForCheck();
  }
}
