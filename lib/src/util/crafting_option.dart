part of util;

class CraftingOption {
  String item;
  Set<String> ingredients;
  Set<int> bonuses;

  CraftingOption(this.item, this.ingredients, this.bonuses);

  static Set<CraftingOption> fromIngredients(Iterable<Item> ingredients) {
    Map<String, Set<String>> map = {};
    Map<String, Set<int>> bonuses = {};

    ingredients.forEach((ingredient) =>
        Crafting.craftedFrom(ingredient.comparisonText).forEach((option) {
          map[option] ??= Set();
          map[option].add(ingredient.comparisonText);
          bonuses[option] ??= Set();
          var bonus = getBonus(ingredient.displayTextWithoutAmount);
          if (ingredient.canUpgrade) bonuses[option].add(bonus);
        }));

    Set<CraftingOption> result = Set();

    map.keys
        .where(
            (option) => Crafting.craftedTo(option).every(map[option].contains))
        .forEach((option) =>
            result.add(CraftingOption(option, map[option], bonuses[option])));

    return result;
  }
}
