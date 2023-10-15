import 'dart:async';
import 'dart:html';
import 'dart:math';

import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:towerclimbonline/client.dart';
import 'package:towerclimbonline/component/examine_item_modal.dart';
import 'package:towerclimbonline/util.dart';

@Component(
    selector: 'item-modal',
    directives: [coreDirectives, formDirectives],
    templateUrl: 'item_modal.html',
    changeDetection: ChangeDetectionStrategy.OnPush)
class ItemModal implements OnDestroy {
  // The modals with search inputs are: action, item, crafting, and trade.

  String? mode = 'use', filter, searchInput = '';
  List<Item> filteredItems = [];
  final ChangeDetectorRef _changeDetectorRef;
  StreamSubscription<ObservableEvent>? _subscription, _equipmentSubscription;

  ItemModal(this._changeDetectorRef) {
    _subscription = ClientGlobals.session!.internal
        .getEvents(path: ['items'], type: 'change').listen((event) {
      // Resets the item list because of a new item stack.

      if (event.path!.length == 3) reset();

      // Updates item amounts.

      _changeDetectorRef.markForCheck();
    });

    _equipmentSubscription = ClientGlobals.session!.internal
        .getEvents(type: 'change')
        .listen((event) {
      if (event.path!.isNotEmpty &&
          ['equip', 'left', 'right', 'options'].contains(event.path!.first))
        _changeDetectorRef.markForCheck();
    });

    Future(reset);
  }

  String get autoHeal {
    var result = big(ClientGlobals.session!.options!['auto heal'] ?? 0)!;
    result = BigIntUtil.min(result, maxInput);

    return result == BigInt.zero
        ? 'disabled'
        : '${formatCurrency(result, false)} health';
  }

  String get autoPotion {
    var result = ClientGlobals.session!.options!['auto potion'] ?? false;
    return result ? 'on' : 'off';
  }

  void set autoPotion(String mode) {
    ClientGlobals.session!.remote(#setOption, ['auto potion', mode == 'on']);
  }

  int get defenseBonus => ClientGlobals.session!.equipped!.values
      .fold(0, (defense, item) => defense + item.defense as int);

  num get defenseUpgrades => damageReductionPercent(_nonWeapons
      .where((item) => !item.upgradesIncreaseEvasion)
      .fold(defenseBonus, (result, item) => result + item.bonus / 10));

  List<String> get defensiveEgos {
    Iterable<String> egoDescriptions(Item item) =>
        item.egos.map((ego) => Ego.longDescriptionFor(item, ego) ?? 'error');

    return List.from(_nonWeapons.expand(egoDescriptions))..sort();
  }

  Iterable<Item> get displayedItems => filteredItems.where((item) =>
      item.displayTextWithoutAmount!
          .toLowerCase()
          .contains(searchInput!.toLowerCase()) &&
      item.amount > 0);

  List<String> get equipment => List.from(ClientGlobals.session!.equipped!.values
      .map((item) => item.displayTextWithoutAmount))
    ..sort();

  String get evasionBonus => formatNumber(
      calculateEvasionPercentBonus(ClientGlobals.session!.equipped!.values));

  Map<String, Item> get items =>
      Map<String, Item>.from(ClientGlobals.session!.items?.items ?? const {});

  String get leftAccuracyBonus => formatNumber(calculateAccuracyPercentBonus(
      ClientGlobals.session!.primaryWeapon, _nonWeapons));

  int get leftDamageBonus => _nonWeapons.fold(
      ClientGlobals.session!.primaryWeapon?.damage ?? 0,
      (result, item) => result + item.damage);

  String get leftDamageUpgrades {
    var upgrades = ClientGlobals.session!.primaryWeapon?.bonus ?? 0;
    return formatNumber(_upgrades(upgrades));
  }

  String get loadout => ClientGlobals.session!.options!['loadout'] ?? '0';

  void set loadout(String selection) {
    ClientGlobals.session!.remote(#setOption, ['loadout', selection]);
  }

  List<String> get primaryEgos {
    var weapon = primaryWeapon, egos = weapon?.egos ?? const [];

    return List.from(
        egos.map((ego) => Ego.longDescriptionFor(weapon!, ego) ?? 'error'))
      ..sort();
  }

  Item? get primaryWeapon => ClientGlobals.session!.primaryWeapon;

  String get rightAccuracyBonus => formatNumber(calculateAccuracyPercentBonus(
      ClientGlobals.session!.secondaryWeapon, _nonWeapons));

  int get rightDamageBonus => _nonWeapons.fold(
      ClientGlobals.session!.secondaryWeapon?.damage ?? 0,
      (result, item) => result + item.damage);

  String get rightDamageUpgrades {
    var upgrades = ClientGlobals.session!.secondaryWeapon?.bonus ?? 0;
    return formatNumber(_upgrades(upgrades));
  }

  List<String> get secondaryEgos {
    var weapon = secondaryWeapon, egos = secondaryWeapon?.egos ?? const [];

    return List.from(
        egos.map((ego) => Ego.longDescriptionFor(weapon!, ego) ?? 'error'))
      ..sort();
  }

  Item? get secondaryWeapon => ClientGlobals.session!.secondaryWeapon;

  List<Item> get sortedItems =>
      List<Item>.from(items.values)..sort(compareItems as int Function(Item, Item)?);

  String? get weaponDisplay {
    var list = List.from(ClientGlobals.session!.equipped!.values
        .where(
            (item) => item.info?.slot == #weapon || item.info?.slot == #shield)
        .map((item) => item.displayTextWithoutAmount));

    return list.isEmpty
        ? null
        : _displayList(List.from(list.map((value) => addEllipsis(value, 20))));
  }

  List<Item> get _filteredItems {
    function(slots) => List<Item>.from(
        sortedItems.where((item) => slots.contains(item.info?.slot)));

    if (filter == 'weapons') return function(const [#weapon, #shield]);
    if (filter == 'body') return function(const [#body]);
    if (filter == 'back') return function(const [#cloak]);
    if (filter == 'hands') return function(const [#gloves]);
    if (filter == 'feet') return function(const [#boots]);
    if (filter == 'head') return function(const [#helmet]);
    if (filter == 'accessory') return function(const [#ring]);
    if (filter == 'neck') return function(const [#amulet]);

    if (filter == 'food')
      return List<Item>.from(sortedItems.where((item) => item.food));

    if (filter == 'potion')
      return List<Item>.from(sortedItems.where((item) => item.potion));

    if (filter == 'scroll')
      return List<Item>.from(sortedItems.where((item) => item.scroll));

    if (filter == 'other')
      return List<Item>.from(sortedItems.where((Item item) {
        if (item.potion || item.scroll) return true;
        if (item.equipment || item.food) return false;
        return true;
      }));

    return sortedItems;
  }

  Iterable<Item> get _nonWeapons =>
      List<Item>.from(ClientGlobals.session!.equipped!.values
          .where((item) => ![#weapon, #thrown].contains(item.info?.slot)));

  String buttonText(String key) {
    function(slot) => ClientGlobals.session!.equipped!.values
        .firstWhere((item) => item.info?.slot == slot, orElse: () => null);

    var result;

    switch (key) {
      case 'body':
        result = function(#body);
        break;
      case 'back':
        result = function(#cloak);
        break;
      case 'hands':
        result = function(#gloves);
        break;
      case 'feet':
        result = function(#boots);
        break;
      case 'accessory':
        result = function(#ring);
        break;
      case 'neck':
        result = function(#amulet);
        break;
      case 'head':
        result = function(#helmet);
        break;
      case 'other':
        result = function(#thrown);
        break;
    }

    return addEllipsis(result?.displayTextWithoutAmount ?? key, 20);
  }

  void disableAutoHeal() {
    ClientGlobals.session!.remote(#setOption, ['auto heal', 0]).then(
        (result) => _changeDetectorRef.markForCheck());
  }

  String displayImage(String action) => abilityDisplayImage(action);

  bool doubleEquipped(String action) =>
      ClientGlobals.session!.equipped!['double equipped']?.id == action;

  bool equipped(String action) =>
      ClientGlobals.session!.equipped?.containsKey(action) == true;

  void handleItemClick(Item item) {
    if (mode == 'use') {
      ClientGlobals.session!.remote(#useItem, [item.id]).then(
          (result) => _changeDetectorRef.markForCheck());

      return;
    }

    showInputModal(
        '${item.displayTextWithoutAmount}', 'examine', (input) => null);

    ExamineItemModal.item = item;
    querySelector('#input-modal-toggle')!.click();
  }

  String itemClasses(Item item) =>
      ClientGlobals.session!.equipped?.containsKey(item.id) == true
          ? 'active'
          : 'transparent';

  String itemDescription(Item item) {
    if (item.food == true) {
      var heal = item.healingAmount;
      return 'consumable (heals ${heal.toStringAsFixed(2)}% health)';
    }

    if (item.equipment) return 'equipment';
    if (item.consumable == true) return 'consumable';
    return '';
  }

  String? itemImage(Item item) => item.info?.image;

  String? itemName(Item item) {
    try {
      return item.displayText;
    } catch (error) {
      return missingItemName;
    }
  }

  void ngOnDestroy() {
    _subscription!.cancel();
    _equipmentSubscription!.cancel();
  }

  reset() {
    filteredItems = _filteredItems;
    _changeDetectorRef.markForCheck();
  }

  void setAutoHeal() {
    showInputModal('Threashold', 'auto heal', (input) {
      ClientGlobals.session!.remote(#setOption, [
        'auto heal',
        min(maxFinite, parseInteger(input)),
      ]).then((result) => _changeDetectorRef.markForCheck());
    });

    querySelector('#input-modal-toggle')!.click();
  }

  void toggleMode(String value) {
    mode != value ? mode = value : mode = null;
  }

  updateFilter(String value) {
    filter == value ? filter = null : filter = value;
    reset();
  }

  String _displayList(List<String> list) => list.join(", <br>");

  int _upgrades(int bonus) => damageIncreasePercent(bonus);
}
