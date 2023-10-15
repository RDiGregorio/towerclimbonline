import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:towerclimbonline/client.dart';
import 'package:towerclimbonline/util.dart';

@Component(
    selector: 'action-modal',
    directives: [coreDirectives, formDirectives],
    templateUrl: 'action_modal.html',
    changeDetection: ChangeDetectionStrategy.OnPush)
class ActionModal {
  List<Item> _sortedItems = [];

  // The modals with search inputs are: action, item, crafting, and trade.

  String searchInput = '';
  final ChangeDetectorRef _changeDetectorRef;

  ActionModal(this._changeDetectorRef) {
    Future(() {
      _sortedItems = List.from(items.values)..sort(compareItems as int Function(Item, Item)?);
      _changeDetectorRef.markForCheck();
    });
  }

  Map<String, bool> get abilities =>
      Map<String, bool>.from(ClientGlobals.session!.abilities ?? const {});

  Map<String, Item> get items =>
      Map<String, Item>.from(ClientGlobals.session!.items?.items ?? const {});

  List<String> get sortedAbilities => List.from(abilities.keys)..sort();

  Iterable<Item> get sortedItems =>
      _sortedItems.where((item) => item.displayTextWithoutAmount!
          .toLowerCase()
          .contains(searchInput.toLowerCase()));

  String abilityImage(String ability) => abilityDisplayImage(ability);

  String abilityName(String ability) => abilityDisplayName(ability);

  bool doubleEquipped(String action) =>
      ClientGlobals.session!.equipped!['double equipped']?.id == action;

  void handleAbilityClick(String ability) {
    ClientGlobals.session!
        .remote(#setAction, [ability, ClientGlobals.clickedActionIndex]);

    hideModal();
  }

  void handleItemClick(Item item) {
    ClientGlobals.session!
        .remote(#setAction, [item.id, ClientGlobals.clickedActionIndex]);

    hideModal();
  }

  String itemClasses(Item item) =>
      ClientGlobals.session!.equipped?.containsKey(item.id) == true
          ? 'active'
          : 'transparent';

  String? itemName(Item item) {
    try {
      return item.displayText;
    } catch (error) {
      return missingItemName;
    }
  }
}
