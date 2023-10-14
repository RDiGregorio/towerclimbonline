part of util;

class RandomShop {
  static int _day;
  static Map<String, List<Item>> _shops;

  static List<Item> generate(Account account, Doll shop) {
    if (_day != daysSinceEpoch) {
      _day = daysSinceEpoch;
      _shops = {};
    }

    _shops[shop.id] ??= [secretRare, secretRare, secretRare];

    return List<Item>.from(
        _shops[shop.id].map((item) => _transform(account, shop, item.copy)));
  }

  static Item _transform(Account account, Doll shop, Item item) {
    var shopLevel = floorToLevel(account.currentFloor),
        playerCombatLevel = account.sheet.combat.level;

    // The same formula is used for drop upgrades. However, combat is used
    // instead of luck here. 2.1875 simulates Gozag and 3 lucky items.

    playerCombatLevel = (playerCombatLevel * 2.1875).floor();
    num amount = playerCombatLevel / 20;

    // An implied tool is used.

    amount += amount * shopLevel / 100;

    amount = amount.floor();
    var multiplier = big(max(1, amount)) + extraResources(shopLevel, amount),
        bonus = calculateDropBonus(playerCombatLevel, multiplier);

    item.bonus = bonus;

    // Players perform 1,500 gathering actions per hour. A decent nuclear
    // reactor produces 10+ energy per uranium.

    // A secret rare is worth 2,500 gathering actions for players that can kill
    // 1 boss per minute.

    // As such, a +0 secret rare is worth about 25,000 energy or Ξ250,000. The
    // final price is multiplied by 8 to account for cyan sparkling nodes.

    var price = multiplier * big(250000) * big(8);
    item.internal['price'] = '$price';
    return item;
  }
}
