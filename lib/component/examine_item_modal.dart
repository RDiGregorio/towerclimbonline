import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:towerclimbonline/client.dart';
import 'package:towerclimbonline/util.dart';

@Component(
    selector: 'examine-item-modal',
    directives: [coreDirectives, formDirectives],
    templateUrl: 'examine_item_modal.html')
class ExamineItemModal {
  static Item item;
  String input;

  ExamineItemModal() {
    ClientGlobals.inputModals.add(this);
  }

  String get accuracy {
    var weapon, armor = [];
    if (item.info?.slot == #weapon)
      weapon = item;
    else
      armor.add(item);

    return formatNumber(calculateAccuracyPercentBonus(weapon, armor));
  }

  Set<String> get craftingInformation {
    var result = Set<String>();

    Crafting.craftedFrom(item.comparisonText).forEach((product) {
      var ingredients = Crafting.craftedTo(product);
      result.add('${ingredients.join(' + ')} → $product');
    });

    return result;
  }

  int get damage => item.damage;

  String get damageUpgrades {
    if (item.info?.slot != #weapon) return '0';
    return formatNumber(_upgrades(item.bonus));
  }

  num get defenseUpgrades {
    var slot = item.info?.slot;
    if (slot == null || slot == #weapon || slot == #cloak) return 0;
    return damageReductionPercent(item.defense + item.bonus / 10);
  }

  List<String> get egos {
    var egos = item?.egos ?? const [];

    return List.from(egos
        .map((ego) => Ego.longDescriptionFor(item, ego))
        .where((value) => value != null))
      ..sort();
  }

  String get evasionBonus => formatNumber(calculateEvasionPercentBonus([item]));

  String get examineText => item.examineText(ClientGlobals.session.sheet) ?? '';

  Set<String> get ingredientFor => Crafting.craftedFrom(item.comparisonText);

  int _upgrades(int bonus) => damageIncreasePercent(bonus);
}
