import 'dart:async';
import 'dart:html';

import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:towerclimbonline/client.dart';
import 'package:towerclimbonline/util.dart';

@Component(
    selector: 'crafting-modal',
    directives: [coreDirectives, formDirectives],
    templateUrl: 'crafting_modal.html',
    changeDetection: ChangeDetectionStrategy.OnPush)
class CraftingModal implements OnDestroy {
  // The modals with search inputs are: action, item, crafting, and trade.

  String selected, searchInput = '', action = 'craft';

  List<String> options = const [],
      upgradeOptions = const [],
      ingredients = const [];

  bool _resetFlag = true, loading = false, canCleanup = true;
  Map<String, String> _upgradeOptionsCache = {}, _amountsCache = {};
  Map<String, Item> _itemFromDisplayTextCache = {};
  StreamSubscription<ObservableEvent> _subscription;
  final ChangeDetectorRef _changeDetectorRef;
  BigInt _startingExperience;

  CraftingModal(this._changeDetectorRef) {
    _subscription = ClientGlobals.session.items.internal
        .getEvents(type: 'change', path: ['items']).listen((event) async {
      // A flag is used to improve performance when repeatedly upgrading items.

      _resetFlag = true;
      await window.animationFrame;

      if (_resetFlag) {
        _resetFlag = false;
        _reset();
      }
    });

    Future(_reset);
  }

  bool get canRepeatUpgrade =>
      _crafted != null &&
      _crafted.amount > 1 &&
      _crafted.bonus > 0 &&
      _crafted.canUpgrade;

  String get crafted => _crafted?.displayText;

  int get craftedAmount => _crafted?.amount ?? 0;

  Iterable<String> get filteredOptions {
    var list = action == 'craft' ? options : upgradeOptions;

    return searchInput.isEmpty
        ? list
        : list.where((value) => formatOption(value.toLowerCase())
            .contains(searchInput.toLowerCase()));
  }

  String get formattedGainedExperience =>
      formatCurrency(gainedExperience, false);

  BigInt get gainedExperience {
    var experience = sheet.crafting.experience +
        sheet.metalworking.experience +
        sheet.cooking.experience;

    return experience - startingExperience;
  }

  Map<String, Item> get items =>
      Map<String, Item>.from(ClientGlobals.session.items?.items ?? const {});

  CharacterSheet get sheet => ClientGlobals.session?.sheet;

  bool get showMessage => crafted != null && craftedAmount > 0;

  BigInt get startingExperience {
    if (_startingExperience == null)
      _startingExperience = sheet.crafting.experience +
          sheet.metalworking.experience +
          sheet.cooking.experience;

    return _startingExperience;
  }

  Item get _crafted => ClientGlobals.session.crafted;

  Symbol get _remoteAction => action == 'craft' ? #craft : #upgrade;

  void addCraft(String option) {
    selected = option;

    if (action == 'craft') {
      ingredients = List.from(Item.fromDisplayText(option).ingredients)..sort();
    } else
      // Upgrade options have an extra +1 that must be removed.

      ingredients = [setBonus(option, getBonus(option) - 1)];

    _changeDetectorRef.markForCheck();
  }

  void askAmount() {
    showInputModal('Amount (${formatOption(selected)})', 'craft item', (input) {
      ClientGlobals.session.remote(_remoteAction, [selected, input]);
      selected = null;
      ingredients = const [];
      canCleanup = true;
    });

    querySelector('#input-modal-toggle').click();
  }

  void cleanupItems() {
    // The crafting modal must be closed and reopened before repeating this.

    if (canCleanup) {
      canCleanup = false;
      ClientGlobals.session.remote(#cleanupItems, []);
    }
  }

  void craftAll() {
    if (ingredients.isNotEmpty) {
      ClientGlobals.session.remote(_remoteAction, [selected, null]);
      selected = null;
      ingredients = const [];
      canCleanup = true;
      // _changeDetectorRef.markForCheck();
    }
  }

  String formatOption(String option) {
    if (action == 'craft') return option;

    if (_upgradeOptionsCache.containsKey(option))
      return _upgradeOptionsCache[option];

    // Upgrade options have an extra +1 that must be removed.

    return _upgradeOptionsCache[option] =
        setBonus(option, getBonus(option) - 1);
  }

  String ingredientAmount(String ingredient) {
    if (_amountsCache.containsKey(ingredient)) return _amountsCache[ingredient];
    _amountsCache[ingredient] = '';

    Future(() {
      _changeDetectorRef.markForCheck();

      return _amountsCache[ingredient] = formatCurrency(
          ClientGlobals.session.items
                  .getItemByDisplayText(ingredient)
                  ?.amount ??
              0,
          false);
    });

    return _amountsCache[ingredient];
  }

  String itemName(Item item) {
    try {
      return item.displayText;
    } catch (error) {
      return missingItemName;
    }
  }

  void maxUpgrade() {
    var text = Item.fromDisplayText(selected).comparisonText;

    showInputModal('Remaining amount ($text)', 'craft item', (input) {
      ClientGlobals.session.remote(#maxUpgrade, [selected, input]);

      selected = null;
      ingredients = const [];
    });

    querySelector('#input-modal-toggle').click();
  }

  void ngOnDestroy() {
    _subscription.cancel();
  }

  void setAction(String value) {
    if (action != value) {
      action = value;
      selected = null;
      ingredients = const [];
      _reset();
    }
  }

  void _reset() {
    // FIXME: the dirty check isn't working (so it's commented out for now)
    // if (_dirty) loading = true;

    if (items != null) {
      if (action == 'craft')
        Future(() {
          if (true) {
            List<Item> optionItems = List<Item>.from(
                Crafting.optionsWithBonuses(items.values).map((text) =>
                    _itemFromDisplayTextCache[text] ??=
                        Item.fromDisplayText(text)))
              ..sort(compareItems);

            options = List.from(
                optionItems.map((item) => item.displayTextWithoutAmount));
          }

          _amountsCache.clear();
          _changeDetectorRef.markForCheck();
          loading = false;
        });
      else
        Future(() {
          if (true) {
            List<Item> upgradeOptionItems = List<Item>.from(
                Crafting.upgradeOptions(items.values).map((text) =>
                    _itemFromDisplayTextCache[text] ??=
                        Item.fromDisplayText(text)))
              ..sort(compareItems);

            upgradeOptions = List.from(upgradeOptionItems
                .map((item) => item.displayTextWithoutAmount));
          }

          _amountsCache.clear();
          _changeDetectorRef.markForCheck();
          loading = false;
        });
    }

    _changeDetectorRef.markForCheck();
  }
}
