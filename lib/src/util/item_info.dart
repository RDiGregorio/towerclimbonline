part of util;

// todo: have a rename variable to handle renamed items

class ItemInfo {
  static const List<Symbol> equipmentSlots = [
    #weapon,
    #shield,
    #helmet,
    #body,
    #cloak,
    #boots,
    #gloves,
    #amulet,
    #ring,
    #thrown,
    #none
  ];

  final bool consumed;
  final Symbol slot;
  final Function use;
  final int coolDown, damage, defense, evasion, accuracy, heal;
  final String image, missile;
  final List<int> egos;

  ItemInfo(
      {this.consumed = false,
      this.slot,
      this.coolDown = CoolDown.average,
      this.accuracy = 0,
      this.evasion = 0,
      this.defense = 0,
      this.damage = 0,
      this.heal = 0,
      this.missile,
      this.image = 'image/missing.png',
      this.egos = const [],
      bool this.use(Doll doll, Item item)}) {
    assert(slot == null || equipmentSlots.contains(slot));
  }
}
