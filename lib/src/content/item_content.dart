part of content;

void registerItems(Map<String, Stage<Doll>> stages) {
  registerFood(key, amount) => registerItemInfo(
      key,
      ItemInfo(
          consumed: true,
          heal: amount,
          use: (Doll doll, Item item) {
            if (doll.full) return false;

            if (doll.account != null &&
                item.bonus > doll.account.sheet.healthBuffs)
              doll.account.sheet.healthBuffs = item.bonus;

            return doll.heal(
                BigIntUtil.min(doll.maxHealth,
                    BigIntUtil.percent(doll.maxHealth, item.healingAmount)),
                true);
          },
          egos: const [Ego.food]));

  // Basic foods (low level).

  registerFood('fish', 5);
  registerFood('meat', 5);
  registerFood('milk', 5);
  registerFood('vegetable', 5);

  // 1 ingredient (low level).

  registerFood('sushi', 10);
  registerFood('teriyaki', 10);
  registerFood('ice cream', 10);
  registerFood('salad', 10);
  registerFood('noodles', 10);

  // Basic foods (high level).

  registerFood('rainbow fish', 15);
  registerFood('yggdrasil fruit', 15);
  registerFood('shellfish', 15);
  registerFood('shark', 15);

  // 1 ingredient (high level).

  registerFood('rainbow sushi', 20);
  registerFood('yggdrasil smoothie', 20);

  // 2 ingredients.

  registerFood('soup', 35);
  registerFood('sandwich', 35);
  registerFood('cereal', 35);

  // 3 ingredients.

  registerFood('pizza', 50);

  // Buff potions. Negative buffs last until the end of combat.

  registerPotion(String key, String buff, [List<int> egos = const []]) =>
      registerItemInfo(
          key,
          ItemInfo(
              consumed: true,
              egos: egos,
              use: (Doll doll, Item item) {
                // 5 minutes in game ticks. Each +1 adds 1%.

                var duration = 1500 + item.bonus * 15;

                if (buff == 'regen') {
                  doll.regenerate(duration);
                  return true;
                }

                // Permanently increases attributes.

                if (buff == 'agi+' &&
                    item.bonus > doll.account.sheet.agilityBuffs)
                  doll.account.sheet.agilityBuffs = item.bonus;

                if (buff == 'str+' &&
                    item.bonus > doll.account.sheet.strengthBuffs)
                  doll.account.sheet.strengthBuffs = item.bonus;

                if (buff == 'dex+' &&
                    item.bonus > doll.account.sheet.dexterityBuffs)
                  doll.account.sheet.dexterityBuffs = item.bonus;

                if (buff == 'int+' &&
                    item.bonus > doll.account.sheet.intelligenceBuffs)
                  doll.account.sheet.intelligenceBuffs = item.bonus;

                doll.buffs[buff] = Buff(duration: duration);
                return true;
              }));

  // Potion egos are only used for their descriptions when examining them.

  registerPotion('agility potion', 'agi+');
  registerPotion('strength potion', 'str+');
  registerPotion('dexterity potion', 'dex+');
  registerPotion('intelligence potion', 'int+');
  registerPotion('regen potion', 'regen', [Ego.regen]);
  registerPotion('fast potion', 'spd+', [Ego.fast]);

  // Weapons.

  // Daggers, bows, and whips have an accuracy bonus, but only 10 base damage.

  registerItemInfo(
      'dagger',
      ItemInfo(
          damage: 10,
          accuracy: 100,
          coolDown: CoolDown.average,
          egos: const [Ego.metal],
          slot: #weapon));

  registerItemInfo(
      'demon whip',
      ItemInfo(
          damage: 10,
          accuracy: 100,
          coolDown: CoolDown.average,
          egos: const [Ego.demon],
          slot: #weapon));

  registerItemInfo(
      'bow',
      ItemInfo(
          damage: 10,
          accuracy: 100,
          missile: 'image/missile/arrow.png',
          coolDown: CoolDown.average,
          egos: const [Ego.twoHanded, Ego.ballistic],
          slot: #weapon));

  // Books are both shields and weapons.

  registerWeaponInfo('book', 50, 'image/missile/white_bolt.png',
      const [Ego.twoHanded, Ego.magic, Ego.shield]);

  registerWeaponInfo(
      'annihilation book', 50, 'image/missile/white_bolt.png', const [
    Ego.twoHanded,
    Ego.magic,
    Ego.shield,
    Ego.fire,
    Ego.ice,
    Ego.electric,
    Ego.gravity
  ]);

  registerWeaponInfo(
      'supernova book', 50, 'image/missile/white_bolt.png', const [
    Ego.twoHanded,
    Ego.magic,
    Ego.shield,
    Ego.burst,
    Ego.energy,
    Ego.all
  ]);

  // Horns.

  registerWeaponInfo('unicorn horn', 50, null, const [Ego.magic, Ego.healing]);

  registerWeaponInfo('kirin horn', 50, 'image/missile/white_bolt.png',
      const [Ego.magic, Ego.electric, Ego.gravity, Ego.burst]);

  registerWeaponInfo('sword', 50, null, const [Ego.parry, Ego.metal]);

  // AOE weapons.

  registerWeaponInfo(
      'scythe', 50, null, const [Ego.twoHanded, Ego.metal, Ego.all]);

  registerWeaponInfo('scepter', 50, 'image/missile/white_bolt.png',
      const [Ego.metal, Ego.twoHanded, Ego.magic, Ego.all]);

  // Special weapons.

  registerWeaponInfo('rubber chicken', 0, null, const [Ego.death]);
  registerWeaponInfo('rainbow undecimber', 50, null, const [Ego.rainbow]);

  // Spears.

  registerWeaponInfo('spear', 50, null, const [Ego.metal, Ego.stun]);

  // A burst berserk spear.

  registerWeaponInfo(
      'gungnir', 50, null, const [Ego.metal, Ego.burst, Ego.berserk, Ego.stun]);

  // Burst weapons.

  registerWeaponInfo(
      'katana', 50, null, const [Ego.metal, Ego.burst, Ego.parry]);

  registerWeaponInfo('rifle', 50, 'image/missile/white_bolt.png',
      const [Ego.twoHanded, Ego.burst, Ego.ballistic, Ego.metal]);

  registerWeaponInfo('smg', 50, 'image/missile/white_bolt.png',
      const [Ego.burst, Ego.ballistic, Ego.metal]);

  // The magic equivalent of a fire rifle.

  registerWeaponInfo('flamethrower', 50, 'image/missile/red_bolt.png',
      const [Ego.twoHanded, Ego.magic, Ego.fire, Ego.burst, Ego.metal]);

  // Revolvers.

  registerWeaponInfo('revolver', 50, 'image/missile/white_bolt.png',
      const [Ego.ballistic, Ego.metal]);

  // Weapons with maximum damage also have 250 base damage.

  registerWeaponInfo('shotgun', 250, 'image/missile/white_bolt.png', const [
    Ego.twoHanded,
    Ego.ballistic,
    Ego.metal,
    Ego.maximumDamage,
    Ego.stun
  ]);

  registerWeaponInfo(
      'battle axe', 250, null, const [Ego.metal, Ego.maximumDamage]);

  // Wrath is a berserk battle axe.

  registerWeaponInfo(
      'wrath', 250, null, const [Ego.berserk, Ego.metal, Ego.maximumDamage]);

  registerWeaponInfo('guitar', 50, null,
      const [Ego.twoHanded, Ego.magic, Ego.healing, Ego.all]);

  // An antimatter shotgun. Antimatter uses black bolts.

  registerWeaponInfo(
      'antimatter cannon', 250, 'image/missile/black_bolt.png', const [
    Ego.twoHanded,
    Ego.ballistic,
    Ego.metal,
    Ego.maximumDamage,
    Ego.stun,
    Ego.antimatter
  ]);

  // Armor.

  registerArmorInfo('shield', null, #shield, 0, 0, [Ego.metal, Ego.shield]);
  registerArmorInfo('chain mail', null, #body, 15, 0, const [Ego.metal]);

  registerArmorInfo('aegis armor', null, #body, 30, 0,
      const [Ego.resistBallistic, Ego.resistMagic]);

  registerArmorInfo('silk robe', null, #body, 0, 25, [Ego.resistMagic]);
  registerArmorInfo('helmet', null, #helmet, 10, 0, const [Ego.metal]);
  registerArmorInfo('gloves', null, #gloves, 5);
  registerArmorInfo('boots', null, #boots, 5);
  registerArmorInfo('jordans', null, #boots, 5, 0, const [Ego.fast, Ego.power]);

  // Base for the resist ballistic vest.

  registerArmorInfo('vest', null, #body, 10);
  registerArmorInfo('leather jacket', null, #body, 10);

  // Base for the arcane robe.

  registerArmorInfo('robe', null, #body, 0, 25);

  // Sleipnirs combine accuracy boots and evasion boots, while also giving fast
  // movement and extra experience.

  registerArmorInfo('sleipnirs', null, #boots, 5, 25,
      const [Ego.experience, Ego.fast, Ego.accuracy]);

  registerArmorInfo('cloak', null, #cloak, 0, 25);
  registerArmorInfo('hat', null, #helmet, 5);
  registerArmorInfo('crown', null, #helmet, 5, 0, const [Ego.metal]);
  registerArmorInfo('evasion crown', null, #helmet, 5, 25, const [Ego.metal]);

  // Thorns and dream crowns are both healing crowns that resist evil, with
  // dream crowns being better for magic users.

  registerArmorInfo(
      'thorns', null, #helmet, 5, 0, const [Ego.blood, Ego.resistEvil]);

  registerArmorInfo('dream crown', null, #helmet, 5, 0,
      const [Ego.metal, Ego.arcane, Ego.regen, Ego.resistEvil]);

  registerArmorInfo('fur hat', null, #helmet, 5, 0, const [Ego.resistIce]);
  registerArmorInfo('fur coat', null, #body, 10, 0, const [Ego.resistIce]);

  // Hats crafted from fabrics.

  registerArmorInfo('silk hat', null, #helmet, 5, 0, const [Ego.resistMagic]);
  registerArmorInfo('ghostly hat', null, #helmet, 5, 0, const [Ego.spirit]);
  registerArmorInfo('distortion hat', null, #helmet, 5, 25);

  registerArmorInfo('starlight hat', null, #helmet, 5, 0,
      const [Ego.reflection, Ego.experience]);

  // Scarves are treated as cloaks.

  registerArmorInfo('fur scarf', null, #cloak, 0, 25, const [Ego.resistIce]);
  registerArmorInfo('silk cloak', null, #cloak, 0, 25, const [Ego.resistMagic]);
  registerArmorInfo('ghostly cloak', null, #cloak, 0, 50, [Ego.spirit]);
  registerArmorInfo('ghostly robe', null, #body, 0, 50, [Ego.spirit]);
  registerArmorInfo('angel wings', null, #cloak, 0, 50, const [Ego.regen]);
  registerArmorInfo('demon wings', null, #cloak, 0, 50, const [Ego.power]);

  registerArmorInfo('starlight cloak', null, #cloak, 0, 50,
      const [Ego.reflection, Ego.experience]);

  registerArmorInfo('starlight robe', null, #body, 0, 50,
      const [Ego.reflection, Ego.experience]);

  registerArmorInfo('distortion cloak', null, #cloak, 0, 75);
  registerArmorInfo('distortion robe', null, #body, 0, 75);
  registerArmorInfo('ring', null, #ring, 0, 0, [Ego.metal]);
  registerArmorInfo('turtle shell', null, #shield, 0, 0, [Ego.shield]);

  registerArmorInfo('cosmic turtle shell', null, #shield, 0, 0,
      const [Ego.reflection, Ego.regen, Ego.shield]);

  registerArmorInfo('aegis shield', null, #shield, 0, 0,
      const [Ego.resistBallistic, Ego.resistMagic, Ego.shield]);

  registerItemInfo('halo', ItemInfo(slot: #helmet, egos: [Ego.accuracy]));

  registerItemInfo('umbra', ItemInfo(slot: #helmet, egos: [Ego.stealth]));

  // Dragon items.

  registerArmorInfo(
      'fire dragon armor', null, #body, 15, 0, const [Ego.resistFire]);

  registerArmorInfo(
      'fire dragon cloak', null, #cloak, 0, 25, const [Ego.resistFire]);

  registerArmorInfo(
      'ice dragon armor', null, #body, 15, 0, const [Ego.resistIce]);

  registerArmorInfo(
      'ice dragon cloak', null, #cloak, 0, 25, const [Ego.resistIce]);

  registerArmorInfo(
      'shadow dragon armor', null, #body, 15, 0, const [Ego.stealth]);

  registerArmorInfo(
      'shadow dragon cloak', null, #cloak, 0, 25, const [Ego.stealth]);

  registerArmorInfo(
      'blessed dragon armor', null, #body, 15, 0, const [Ego.resistEvil]);

  registerArmorInfo(
      'blessed dragon cloak', null, #cloak, 0, 25, const [Ego.resistEvil]);

  registerArmorInfo(
      'void dragon armor', null, #body, 15, 0, const [Ego.resistGravity]);

  registerArmorInfo(
      'void dragon cloak', null, #cloak, 0, 25, const [Ego.resistGravity]);

  registerArmorInfo(
      'storm dragon armor', null, #body, 15, 0, const [Ego.resistElectric]);

  registerArmorInfo(
      'storm dragon cloak', null, #cloak, 0, 25, const [Ego.resistElectric]);

  registerArmorInfo(
      'poison dragon armor', null, #body, 15, 0, const [Ego.resistPoison]);

  registerArmorInfo(
      'poison dragon cloak', null, #cloak, 0, 25, const [Ego.resistPoison]);

  registerArmorInfo(
      'acid dragon armor', null, #body, 15, 0, const [Ego.resistAcid]);

  registerArmorInfo(
      'acid dragon cloak', null, #cloak, 0, 25, const [Ego.resistAcid]);

  registerArmorInfo('cosmic dragon armor', null, #body, 15, 0,
      const [Ego.reflection, Ego.regen]);

  registerArmorInfo('cosmic dragon cloak', null, #cloak, 0, 25,
      const [Ego.reflection, Ego.regen]);

  registerArmorInfo('stardust dragon armor', null, #body, 15, 0,
      const [Ego.reflection, Ego.regen, Ego.experience]);

  registerArmorInfo('stardust dragon cloak', null, #cloak, 0, 25,
      const [Ego.reflection, Ego.regen, Ego.experience]);

  // Amulets.

  registerItemInfo(
      'wooden charm', ItemInfo(slot: #amulet, egos: const [Ego.resistEvil]));

  registerItemInfo('golden charm',
      ItemInfo(slot: #amulet, egos: const [Ego.lucky, Ego.metal]));

  registerItemInfo('accuracy amulet',
      ItemInfo(slot: #amulet, egos: const [Ego.metal, Ego.accuracy]));

  registerItemInfo('evasion amulet',
      ItemInfo(slot: #amulet, evasion: 25, egos: const [Ego.metal]));

  registerItemInfo('life amulet',
      ItemInfo(slot: #amulet, egos: const [Ego.metal, Ego.life]));

  registerItemInfo('invisibility amulet',
      ItemInfo(slot: #amulet, egos: const [Ego.stealth]));

  registerItemInfo(
      'brisingamen',
      ItemInfo(slot: #amulet, egos: const [
        // Does not have resist evil, making other items more useful.

        Ego.resistIce,
        Ego.resistElectric,
        Ego.resistFire,
        Ego.resistPoison,
        Ego.resistAcid,
        Ego.resistGravity
      ]));

  registerItemInfo('power amulet',
      ItemInfo(slot: #amulet, egos: const [Ego.metal, Ego.power]));

  registerItemInfo('defense amulet',
      ItemInfo(slot: #amulet, defense: 0, egos: const [Ego.metal, Ego.shield]));

  registerItemInfo('reflection amulet',
      ItemInfo(slot: #amulet, egos: const [Ego.reflection, Ego.metal]));

  // Meteorite items.

  registerItemInfo(
      'meteorite ring',
      ItemInfo(slot: #ring, egos: const [
        Ego.resistGravity,
        Ego.resistPoison,
        Ego.resistAcid,
        Ego.metal
      ]));

  registerArmorInfo('meteorite crown', null, #helmet, 5, 0,
      const [Ego.resistGravity, Ego.resistPoison, Ego.resistAcid, Ego.metal]);

  // Boots and gloves. There are no defense gloves or defense boots because
  // armor already gives defense.

  registerItemInfo(
      'power gloves', ItemInfo(slot: #gloves, defense: 5, egos: [Ego.power]));

  registerItemInfo(
      'power boots', ItemInfo(slot: #boots, defense: 5, egos: [Ego.power]));

  registerItemInfo('accuracy gloves',
      ItemInfo(slot: #gloves, defense: 5, egos: [Ego.accuracy]));

  registerItemInfo('accuracy boots',
      ItemInfo(slot: #boots, defense: 5, egos: [Ego.accuracy]));

  registerItemInfo('invisibility boots',
      ItemInfo(slot: #boots, defense: 5, egos: [Ego.stealth]));

  registerItemInfo(
      'evasion gloves', ItemInfo(slot: #gloves, evasion: 25, defense: 5));

  registerItemInfo(
      'evasion boots', ItemInfo(slot: #boots, evasion: 25, defense: 5));

  // Super resist items.

  registerItemInfo(
      'super resist ring',
      ItemInfo(slot: #ring, egos: const [
        Ego.metal,
        Ego.resistFire,
        Ego.resistIce,
        Ego.resistElectric
      ]));

  registerArmorInfo('super resist hat', null, #helmet, 5, 0,
      const [Ego.metal, Ego.resistFire, Ego.resistIce, Ego.resistElectric]);

  // God items.

  registerArmorInfo('asprika', null, #cloak, 0, 75,
      const [Ego.regen, Ego.reflection, Ego.experience]);

  registerArmorInfo('brynhild', null, #body, 30, 0,
      const [Ego.health, Ego.resistBallistic, Ego.resistMagic]);

  // Thrown.

  registerThrown(key, ability, egos) => registerItemInfo(
      key,
      ItemInfo(
          slot: #thrown,
          egos: egos,
          use: (doll, item) =>
              doll.targetDoll != null && doll.useAbility(ability)));

  // Thrown egos are only used when examining the item. Actual effects are from
  // the related ability.

  registerThrown('fire scroll', 'fire scroll', [Ego.magic, Ego.fire]);
  registerThrown('ice scroll', 'ice scroll', [Ego.magic, Ego.ice]);

  registerThrown(
      'electric scroll', 'electric scroll', [Ego.magic, Ego.electric]);

  registerThrown('gravity scroll', 'gravity scroll', [Ego.magic, Ego.gravity]);

  registerThrown('annihilation scroll', 'super scroll',
      [Ego.magic, Ego.fire, Ego.ice, Ego.electric, Ego.gravity]);

  registerThrown('poison potion', 'poison potion', [Ego.magic, Ego.poison]);
  registerThrown('blood potion', 'blood potion', [Ego.magic, Ego.blood]);

  registerThrown(
      'sickness potion', 'sickness potion', [Ego.magic, Ego.sickness]);

  registerThrown(
      'blindness potion', 'blindness potion', [Ego.magic, Ego.blindness]);

  registerThrown(
      'confusion potion', 'confusion potion', [Ego.magic, Ego.confusion]);

  registerThrown('acid potion', 'acid potion', [Ego.magic, Ego.acid]);

  registerThrown('miasma potion', 'miasma potion',
      [Ego.magic, Ego.sickness, Ego.blindness, Ego.confusion]);

  // Reusable items.

  registerItemInfo(
      'nuclear reactor',
      ItemInfo(
          egos: const [Ego.metal],
          use: (Doll doll, Item reactor) {
            var uranium = doll.account.items.getItem('uranium'),
                amount = big(uranium?.getAmount() ?? 0);

            amount +=
                BigIntUtil.multiplyByDouble(amount, safeLog(reactor.bonus));

            if (amount > BigInt.zero)
              doll.account
                ..items.deleteItem(uranium)
                ..lootItem(Item('energy')..setAmount(amount));
            else
              doll.alert(alerts[#nothingHappens]);

            return true;
          }));

  registerItemInfo('philosopher\'s stone',
      ItemInfo(use: (Doll doll, Item stone) {
    var potions = doll.account.items.getItem('blood potion'),
        amount = big(potions?.getAmount() ?? 0);

    amount += BigIntUtil.multiplyByDouble(amount, safeLog(stone.bonus));

    if (amount > BigInt.zero)
      doll.account
        ..items.deleteItem(potions)
        ..lootItem(Item('gold')..setAmount(amount));
    else
      doll.alert(alerts[#nothingHappens]);

    return true;
  }));

  registerItemInfo(
      'puzzle box',
      ItemInfo(
          consumed: true,
          use: (Doll doll, Item puzzle) {
            var secretRareDrop = secretRare;
            secretRareDrop.bonus = puzzle.bonus;
            doll.account.lootItem(secretRareDrop);
            doll.account.secretRareDropLog[secretRareDrop.displayText] = true;
            return true;
          }));

  registerItemInfo(
      'nuclear bomb',
      ItemInfo(
          consumed: true,
          egos: const [Ego.metal],
          use: (Doll source, Item bomb) {
            source
                .search(ServerGlobals.sight, ServerGlobals.sight)
                .where(source.canAreaEffect)
                .where((doll) =>
                    !doll.dead &&
                    !doll.summoned &&
                    !doll.boss &&
                    doll.account == null &&
                    doll.info?.interaction == null)
                .forEach((target) => target
                  ..killWithNoReward()
                  ..splat('no reward', 'effect-text'));

            return true;
          }));

  // Items only monsters should have.

  registerWeaponInfo(
      'rock', 10, 'image/missile/brown_bolt.png', const [Ego.ballistic]);

  registerArmorInfo('natural armor', null, #none, 0, 0);
  registerWeaponInfo('natural weapon', 0);

  // Used to calculate scroll damage and accuracy.

  registerWeaponInfo('scroll', 0, null, [Ego.magic]);

  // Tools are two handed for balance reasons.

  registerWeaponInfo(
      'pickaxe', 0, null, const [Ego.twoHanded, Ego.mining, Ego.metal]);

  registerWeaponInfo(
      'hatchet', 0, null, const [Ego.twoHanded, Ego.gathering, Ego.metal]);

  registerWeaponInfo('fishing rod', 0, 'image/missile/white_bolt.png',
      const [Ego.ballistic, Ego.twoHanded, Ego.fishing]);

  // Leashes are treated like a charming tool.

  registerWeaponInfo('leash', 0, null, const [Ego.twoHanded, Ego.charm]);

  // Crafting tools.

  // TODO: design and implement these

  // registerItemInfo('kitchen knife', ItemInfo());
  // registerItemInfo('anvil', ItemInfo());
  // registerItemInfo('crafting table', ItemInfo());

  // Resources.

  registerItemInfo('wood', ItemInfo());
  registerItemInfo('magic wood', ItemInfo());
  registerItemInfo('seaweed', ItemInfo());
  registerItemInfo('iron', ItemInfo());
  registerItemInfo('gold', ItemInfo());
  registerItemInfo('uranium', ItemInfo());
  registerItemInfo('skull', ItemInfo());

  // Gems.

  registerItemInfo('ruby', ItemInfo());
  registerItemInfo('emerald', ItemInfo());
  registerItemInfo('sapphire', ItemInfo());
  registerItemInfo('diamond', ItemInfo());
  registerItemInfo('onyx', ItemInfo());
  registerItemInfo('rainbow diamond', ItemInfo());
  registerItemInfo('meteorite', ItemInfo());

  // Scales.

  registerItemInfo('fire dragon scales', ItemInfo());
  registerItemInfo('ice dragon scales', ItemInfo());
  registerItemInfo('storm dragon scales', ItemInfo());
  registerItemInfo('void dragon scales', ItemInfo());
  registerItemInfo('acid dragon scales', ItemInfo());
  registerItemInfo('poison dragon scales', ItemInfo());
  registerItemInfo('shadow dragon scales', ItemInfo());
  registerItemInfo('blessed dragon scales', ItemInfo());
  registerItemInfo('cosmic dragon scales', ItemInfo());
  registerItemInfo('stardust dragon scales', ItemInfo());

  // Other ingredients.

  registerItemInfo('energy', ItemInfo());
  registerItemInfo('grain', ItemInfo());
  registerItemInfo('hide', ItemInfo());
  registerItemInfo('fur', ItemInfo());
  registerItemInfo('web', ItemInfo());
  registerItemInfo('ghostly fabric', ItemInfo());
  registerItemInfo('starlight fabric', ItemInfo());
  registerItemInfo('white feathers', ItemInfo());
  registerItemInfo('black feathers', ItemInfo());
  registerItemInfo('gunpowder', ItemInfo());
  registerItemInfo('spacetime fabric', ItemInfo());
  registerItemInfo('herb', ItemInfo());
  registerItemInfo('tentacle', ItemInfo());
  registerItemInfo('particle accelerator', ItemInfo(egos: [Ego.metal]));
}
