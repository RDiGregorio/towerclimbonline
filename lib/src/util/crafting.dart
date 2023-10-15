part of util;

class Crafting {
  static Map<Item, String> _upgradeText = {};

  static Map<String, Set<String>>

      // [_craftedFrom] has "ingredients" as keys and "what is made" as values
      // As such, _craftedFrom[x] is what is "crafted from" x.

      _craftedFrom = {},

      // [_craftedTo] has "what is made" as keys and "ingredients" as values
      // As such, _craftedTo[x] is what is "crafted to" x.

      _craftedTo = {};

  static void add(String result, Iterable<String> ingredients) {
    List.from(ingredients)
      ..add(result)
      ..where((ingredient) => !itemExists(ingredient)).forEach((ingredient) =>
          Logger.root.info('warning: $ingredient does not exist'));

    assert(!_craftedTo.containsKey(result));
    _craftedTo[result] = Set.from(ingredients);

    ingredients.forEach((ingredient) {
      _craftedFrom[ingredient] ??= Set();
      _craftedFrom[ingredient]!.add(result);
    });
  }

  /// Returns what is crafted from [key].

  static Set<String> craftedFrom(String? key) =>
      Set<String>.from((_craftedFrom[key] ?? const []) as Iterable<dynamic>);

  /// Returns what is crafted to [key].

  static Set<String> craftedTo(String? key, [bool upgrade = false]) => upgrade
      ? Set<String>.from([setBonus(key!, getBonus(key)! - 1)])
      : Set<String>.from((_craftedTo[key] ?? const []) as Iterable<dynamic>);

  static void init() {
    // The items that can't be crafted are:
    // god items
    // super resist ring
    // super resist hat
    // invisibility boots
    // berserk ring

    _craftedFrom.clear();
    _craftedTo.clear();

    // Potions. Acid and blood potions can't be crafted.

    add('agility potion', ['herb']);
    add('strength potion', ['herb']);
    add('dexterity potion', ['herb']);
    add('intelligence potion', ['herb']);
    add('regen potion', ['herb']);
    add('fast potion', ['herb']);
    add('poison potion', ['herb']);
    add('confusion potion', ['herb']);
    add('blindness potion', ['herb']);
    add('sickness potion', ['herb']);

    add('miasma potion',
        const ['confusion potion', 'blindness potion', 'sickness potion']);

    // Egos weapons from potions.

    const ['poison', 'acid', 'blood'].forEach((ego) {
      add('$ego bow', ['bow', '$ego potion']);
      add('$ego book', ['book', '$ego potion']);
      add('$ego scythe', ['scythe', '$ego potion']);
      add('$ego dagger', ['dagger', '$ego potion']);
      add('$ego sword', ['sword', '$ego potion']);
      add('$ego battle axe', ['battle axe', '$ego potion']);
      add('$ego spear', ['spear', '$ego potion']);
      add('$ego scepter', ['scepter', '$ego potion']);
      add('$ego revolver', ['revolver', '$ego potion']);
      add('$ego rifle', ['rifle', '$ego potion']);
      add('$ego shotgun', ['shotgun', '$ego potion']);
      add('$ego demon whip', ['demon whip', '$ego potion']);
      add('$ego antimatter cannon', ['antimatter cannon', '$ego potion']);
      add('$ego wrath', ['wrath', '$ego potion']);

      // Crystal weapons.

      var crystalEgo = _crystalEgo(ego);
      add('$crystalEgo scythe', ['crystal scythe', '$ego potion']);
      add('$crystalEgo dagger', ['crystal dagger', '$ego potion']);
      add('$crystalEgo sword', ['crystal sword', '$ego potion']);
      add('$crystalEgo battle axe', ['crystal battle axe', '$ego potion']);
      add('$crystalEgo spear', ['crystal spear', '$ego potion']);
      add('$crystalEgo scepter', ['crystal scepter', '$ego potion']);
      add('$crystalEgo revolver', ['crystal revolver', '$ego potion']);
      add('$crystalEgo rifle', ['crystal rifle', '$ego potion']);
      add('$crystalEgo shotgun', ['crystal shotgun', '$ego potion']);

      // Energy weapons.

      var energyEgo = _energyEgo(ego);
      add('$energyEgo scythe', ['energy scythe', '$ego potion']);
      add('$energyEgo dagger', ['energy dagger', '$ego potion']);
      add('$energyEgo sword', ['energy sword', '$ego potion']);
      add('$energyEgo battle axe', ['energy battle axe', '$ego potion']);
      add('$energyEgo spear', ['energy spear', '$ego potion']);
      add('$energyEgo revolver', ['energy revolver', '$ego potion']);
      add('$energyEgo rifle', ['energy rifle', '$ego potion']);
      add('$energyEgo shotgun', ['energy shotgun', '$ego potion']);
      add('$energyEgo scepter', ['energy scepter', '$ego potion']);
    });

    // Egos weapons from scrolls.

    const ['fire', 'ice', 'electric', 'gravity'].forEach((ego) {
      add('$ego bow', ['bow', '$ego scroll']);
      add('$ego book', ['book', '$ego scroll']);
      add('$ego scythe', ['scythe', '$ego scroll']);
      add('$ego dagger', ['dagger', '$ego scroll']);
      add('$ego sword', ['sword', '$ego scroll']);
      add('$ego battle axe', ['battle axe', '$ego scroll']);
      add('$ego spear', ['spear', '$ego scroll']);
      add('$ego scepter', ['scepter', '$ego scroll']);
      add('$ego revolver', ['revolver', '$ego scroll']);
      add('$ego rifle', ['rifle', '$ego scroll']);
      add('$ego shotgun', ['shotgun', '$ego scroll']);
      add('$ego demon whip', ['demon whip', '$ego scroll']);
      add('$ego antimatter cannon', ['antimatter cannon', '$ego scroll']);
      add('$ego wrath', ['wrath', '$ego scroll']);

      // Crystal weapons.

      var crystalEgo = _crystalEgo(ego);
      add('$crystalEgo scythe', ['crystal scythe', '$ego scroll']);
      add('$crystalEgo dagger', ['crystal dagger', '$ego scroll']);
      add('$crystalEgo sword', ['crystal sword', '$ego scroll']);
      add('$crystalEgo battle axe', ['crystal battle axe', '$ego scroll']);
      add('$crystalEgo spear', ['crystal spear', '$ego scroll']);
      add('$crystalEgo scepter', ['crystal scepter', '$ego scroll']);
      add('$crystalEgo revolver', ['crystal revolver', '$ego scroll']);
      add('$crystalEgo rifle', ['crystal rifle', '$ego scroll']);
      add('$crystalEgo shotgun', ['crystal shotgun', '$ego scroll']);

      // Energy weapons.

      var energyEgo = _energyEgo(ego);
      add('$energyEgo scythe', ['energy scythe', '$ego scroll']);
      add('$energyEgo dagger', ['energy dagger', '$ego scroll']);
      add('$energyEgo sword', ['energy sword', '$ego scroll']);
      add('$energyEgo battle axe', ['energy battle axe', '$ego scroll']);
      add('$energyEgo spear', ['energy spear', '$ego scroll']);
      add('$energyEgo revolver', ['energy revolver', '$ego scroll']);
      add('$energyEgo rifle', ['energy rifle', '$ego scroll']);
      add('$energyEgo shotgun', ['energy shotgun', '$ego scroll']);
      add('$energyEgo scepter', ['energy scepter', '$ego scroll']);
    });

    // Gold.

    add('scepter', const ['gold']);

    // Rings.

    add('ring', const ['gold']);
    add('regen ring', const ['emerald', 'gold']);
    add('experience ring', const ['onyx', 'gold']);
    add('meteorite ring', const ['meteorite', 'gold']);
    add('burst ring', const ['rainbow diamond', 'gold']);

    // Amulets (defense replaces regen).

    add('golden charm', const ['gold']);
    add('power amulet', const ['ruby', 'gold']);
    add('evasion amulet', const ['sapphire', 'gold']);
    add('accuracy amulet', const ['diamond', 'gold']);
    add('defense amulet', const ['emerald', 'gold']);
    add('invisibility amulet', const ['onyx', 'gold']);
    add('life amulet', const ['rainbow diamond', 'gold']);
    add('reflection amulet', const ['meteorite', 'gold']);

    // Crowns.

    add('crown', const ['gold']);
    add('power crown', const ['gold', 'ruby']);
    add('evasion crown', const ['gold', 'sapphire']);
    add('accuracy crown', const ['gold', 'diamond']);
    add('regen crown', const ['gold', 'emerald']);
    add('experience crown', const ['gold', 'onyx']);
    add('dream crown', const ['rainbow diamond', 'gold']);
    add('meteorite crown', const ['meteorite', 'gold']);

    // Dragon scales.

    add('fire dragon armor', const ['fire dragon scales']);
    add('ice dragon armor', const ['ice dragon scales']);
    add('storm dragon armor', const ['storm dragon scales']);
    add('poison dragon armor', const ['poison dragon scales']);
    add('shadow dragon armor', const ['shadow dragon scales']);
    add('blessed dragon armor', const ['blessed dragon scales']);
    add('void dragon armor', const ['void dragon scales']);
    add('acid dragon armor', const ['acid dragon scales']);
    add('cosmic dragon armor', const ['cosmic dragon scales']);
    add('stardust dragon armor', const ['stardust dragon scales']);
    add('fire dragon cloak', const ['fire dragon scales']);
    add('ice dragon cloak', const ['ice dragon scales']);
    add('storm dragon cloak', const ['storm dragon scales']);
    add('poison dragon cloak', const ['poison dragon scales']);
    add('shadow dragon cloak', const ['shadow dragon scales']);
    add('blessed dragon cloak', const ['blessed dragon scales']);
    add('void dragon cloak', const ['void dragon scales']);
    add('acid dragon cloak', const ['acid dragon scales']);
    add('cosmic dragon cloak', const ['cosmic dragon scales']);
    add('stardust dragon cloak', const ['stardust dragon scales']);

    // Wood.

    add('bow', const ['wood']);
    add('book', const ['wood']);
    add('wooden charm', const ['wood']);
    add('guitar', const ['wood']);

    // Magic wood.

    add('fire scroll', const ['magic wood']);
    add('ice scroll', const ['magic wood']);
    add('electric scroll', const ['magic wood']);
    add('gravity scroll', const ['magic wood']);

    // Iron.

    // One handed burst weapons (katanas and smgs) can't be crafted.

    add('chain mail', const ['iron']);
    add('shield', const ['iron']);
    add('helmet', const ['iron']);
    add('dagger', const ['iron']);
    add('sword', const ['iron']);
    add('battle axe', const ['iron']);
    add('spear', const ['iron']);
    add('scythe', const ['iron']);

    // Firearms.

    add('revolver', const ['iron', 'gunpowder']);
    add('rifle', const ['iron', 'gunpowder']);
    add('shotgun', const ['iron', 'gunpowder']);

    // Leather.

    add('power boots', const ['ruby', 'hide']);
    add('evasion boots', const ['sapphire', 'hide']);
    add('accuracy boots', const ['diamond', 'hide']);
    add('regen boots', const ['emerald', 'hide']);
    add('experience boots', const ['onyx', 'hide']);
    add('power gloves', const ['ruby', 'hide']);
    add('evasion gloves', const ['sapphire', 'hide']);
    add('accuracy gloves', const ['diamond', 'hide']);
    add('regen gloves', const ['emerald', 'hide']);
    add('experience gloves', const ['onyx', 'hide']);
    add('cloak', const ['hide']);
    add('leash', const ['hide']);

    // Useless, but added for consistency.

    add('boots', const ['hide']);
    add('gloves', const ['hide']);
    add('hat', const ['hide']);
    add('leather jacket', const ['hide']);

    // Fur.

    add('fur hat', const ['fur']);
    add('fur coat', const ['fur']);
    add('fur scarf', const ['fur']);

    // Web.

    add('resist ballistic vest', const ['web']);

    // Fabric.

    add('silk robe', const ['web']);
    add('silk cloak', const ['web']);
    add('silk hat', const ['web']);
    add('ghostly robe', const ['ghostly fabric']);
    add('ghostly cloak', const ['ghostly fabric']);
    add('ghostly hat', const ['ghostly fabric']);
    add('distortion robe', const ['spacetime fabric']);
    add('distortion cloak', const ['spacetime fabric']);
    add('distortion hat', const ['spacetime fabric']);
    add('starlight robe', const ['starlight fabric']);
    add('starlight cloak', const ['starlight fabric']);
    add('starlight hat', const ['starlight fabric']);

    // Feathers.

    add('angel wings', const ['white feathers']);
    add('demon wings', const ['black feathers']);

    // Special.

    add('demon whip', const ['tentacle']);
    add('wrath', const ['meteorite', 'tentacle']);
    add('rainbow undecimber', const ['rainbow diamond', 'unicorn horn']);
    add('philosopher\'s stone', const ['blood potion']);

    // Cooking (1 ingredient).

    add('sushi', const ['fish']);
    add('teriyaki', const ['meat']);
    add('noodles', const ['grain']);
    add('salad', const ['vegetable']);
    add('ice cream', const ['milk']);
    add('yggdrasil smoothie', const ['yggdrasil fruit']);
    add('rainbow sushi', const ['rainbow fish']);

    // Cooking (2 ingredients).

    add('soup', const ['meat', 'vegetable']);
    add('sandwich', const ['meat', 'grain']);
    add('cereal', const ['milk', 'grain']);

    // Cooking (3 ingredients).

    add('pizza', const ['milk', 'grain', 'vegetable']);

    // Tools.

    add('pickaxe', const ['iron']);
    add('hatchet', const ['iron']);
    add('fishing rod', const ['wood']);

    // Crafting tools.

    // TODO: design and implement these

    // add('kitchen knife', const ['iron']);
    // add('anvil', const ['iron']);
    // add('crafting table', const ['wood']);

    // Crystal tools.

    add('crystal pickaxe', const ['seaweed']);
    add('crystal hatchet', const ['seaweed']);
    add('crystal fishing rod', const ['seaweed']);

    // Crystal armor.

    add('crystal thieving gloves', const ['seaweed']);
    add('crystal shield', const ['seaweed']);

    // Crystal weapons (no books or bows).

    add('crystal scythe', ['seaweed']);
    add('crystal dagger', ['seaweed']);
    add('crystal sword', ['seaweed']);
    add('crystal battle axe', ['seaweed']);
    add('crystal spear', ['seaweed']);
    add('crystal scepter', ['seaweed']);
    add('crystal revolver', ['seaweed', 'gunpowder']);
    add('crystal rifle', ['seaweed', 'gunpowder']);
    add('crystal shotgun', ['seaweed', 'gunpowder']);

    // Nukes.

    add('nuclear reactor', const ['uranium', 'iron']);
    add('nuclear bomb', const ['uranium', 'iron']);

    // Energy.

    const ['energy'].forEach((ego) {
      add('$ego scythe', ['iron', 'energy']);
      add('$ego dagger', ['iron', 'energy']);
      add('$ego sword', ['iron', 'energy']);
      add('$ego battle axe', ['iron', 'energy']);
      add('$ego spear', ['iron', 'energy']);
      add('$ego revolver', ['iron', 'energy']);
      add('$ego rifle', ['iron', 'energy']);
      add('$ego shotgun', ['iron', 'energy']);
      add('$ego scepter', const ['gold', 'energy']);
    });

    // Scrolls.

    add('annihilation scroll', const [
      'fire scroll',
      'ice scroll',
      'electric scroll',
      'gravity scroll'
    ]);

    // Antimatter.

    add('particle accelerator', ['annihilation scroll', 'iron']);
    add('antimatter cannon', ['particle accelerator', 'gold', 'energy']);

    // Other.

    add('flamethrower', ['iron', 'fire scroll']);
  }

  /// Used client side.

  static Set<String> optionsWithBonuses(Iterable<Item> items) {
    var result = Set<String>();

    CraftingOption.fromIngredients(items).forEach((option) =>
        option.bonuses!.isEmpty
            ? result.add(option.item)
            : option.bonuses!
                .forEach((bonus) => result.add(setBonus(option.item, bonus!))));

    return result;
  }

  static Set<String?> upgradeOptions(Iterable<Item> items) {
    var result = Set<String?>();

    result.addAll(items.where((item) => item.canUpgrade).map((item) =>
        _upgradeText.containsKey(item)
            ? _upgradeText[item]
            : _upgradeText[item] =
                setBonus(item.displayTextWithoutAmount!, item.bonus + 1)));

    return result;
  }

  static String _crystalEgo(String ego) {
    List<String> sorted = ['crystal', ego]..sort();
    return '${sorted[0]} ${sorted[1]}';
  }

  static String _energyEgo(String ego) {
    List<String> sorted = ['energy', ego]..sort();
    return '${sorted[0]} ${sorted[1]}';
  }
}
