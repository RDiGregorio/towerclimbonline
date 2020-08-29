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
                min(doll.maxHealth,
                    percent(doll.maxHealth, item.healingAmount).floor()),
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
  registerFood('rice', 10);
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
                if (buff == 'level up') {
                  if (Config.debug)
                    doll.account.sheet.stats
                        .forEach((stat) => stat.experience = big(maxFinite));

                  return true;
                }

                // 1 hour in game ticks. Each +1 adds 1% (36 seconds).

                var duration = 18000 + item.bonus * 180;

                if (buff == 'super resist') {
                  doll.buffs['resist fire'] =
                      Buff(duration: duration, egos: const [Ego.resistFire]);

                  doll.buffs['resist ice'] =
                      Buff(duration: duration, egos: const [Ego.resistIce]);

                  doll.buffs['resist electric'] = Buff(
                      duration: duration, egos: const [Ego.resistElectric]);

                  return true;
                }

                if (buff == 'resist fire') {
                  doll.buffs['resist fire'] =
                      Buff(duration: duration, egos: const [Ego.resistFire]);

                  return true;
                }

                if (buff == 'resist ice') {
                  doll.buffs['resist ice'] =
                      Buff(duration: duration, egos: const [Ego.resistIce]);

                  return true;
                }

                if (buff == 'resist electric') {
                  doll.buffs['resist electric'] = Buff(
                      duration: duration, egos: const [Ego.resistElectric]);

                  return true;
                }

                if (buff == 'resist poison') {
                  doll.buffs['resist poison'] =
                      Buff(duration: duration, egos: const [Ego.resistPoison]);

                  return true;
                }

                if (buff == 'resist gravity') {
                  doll.buffs['resist gravity'] =
                      Buff(duration: duration, egos: const [Ego.resistGravity]);

                  return true;
                }

                if (buff == 'resist acid') {
                  doll.buffs['resist acid'] =
                      Buff(duration: duration, egos: const [Ego.resistAcid]);

                  return true;
                }

                if (buff == 'regen') {
                  doll.regenerate(duration);
                  return true;
                }

                if (buff == 'elixir') {
                  doll.buffs['agi+'] = Buff(duration: duration);
                  doll.buffs['dex+'] = Buff(duration: duration);
                  doll.buffs['int+'] = Buff(duration: duration);
                  doll.buffs['str+'] = Buff(duration: duration);
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
  registerPotion('invisibility potion', 'invisibility', [Ego.stealth]);
  registerPotion('fast potion', 'spd+', [Ego.fast]);

  // Unobtainable potions.

  registerPotion('resist fire potion', 'resist fire', [Ego.resistFire]);
  registerPotion('resist ice potion', 'resist ice', [Ego.resistIce]);

  registerPotion(
      'resist electric potion', 'resist electric', [Ego.resistElectric]);

  registerPotion(
      'resist gravity potion', 'resist gravity', [Ego.resistGravity]);

  registerPotion('resist poison potion', 'resist poison', [Ego.resistPoison]);
  registerPotion('resist acid potion', 'resist acid', [Ego.resistAcid]);
  registerPotion('elixir potion', 'elixir');
  registerPotion('super resist potion', 'super resist');
  registerPotion('level up potion', 'level up');

  // Weapons.
  // [key, damage, missile, egos]

  // Daggers and bows have an accuracy bonus.

  registerItemInfo(
      'dagger',
      ItemInfo(
          damage: 10,
          accuracy: 100,
          coolDown: CoolDown.average,
          egos: const [Ego.metal],
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

  // FIXME: different books should have different bolt images

  registerWeaponInfo('book', 50, 'image/missile/white_bolt.png',
      const [Ego.twoHanded, Ego.magic]);

  registerWeaponInfo('demon whip', 10, null, [Ego.demon]);

  // A unicorn horn is just a flavored healing book.

  registerWeaponInfo(
      'unicorn horn', 50, null, const [Ego.twoHanded, Ego.magic, Ego.healing]);

  registerWeaponInfo(
      'guitar', 50, null, const [Ego.twoHanded, Ego.magic, Ego.healing]);

  registerWeaponInfo('sword', 50, null, const [Ego.parry, Ego.metal]);

  registerWeaponInfo('rainbow undecimber', 250, null, const [Ego.rainbow]);

  registerWeaponInfo('battle axe', 250, null,
      const [Ego.twoHanded, Ego.metal, Ego.maximumDamage]);

  // Wrath is a battle axe.

  registerWeaponInfo('wrath', 250, null,
      const [Ego.twoHanded, Ego.wrath, Ego.metal, Ego.maximumDamage]);

  registerWeaponInfo('kirin horn', 250, 'image/missile/yellow_bolt.png',
      const [Ego.twoHanded, Ego.magic, Ego.electric, Ego.gravity, Ego.burst]);

  registerWeaponInfo(
      'scythe', 50, null, const [Ego.twoHanded, Ego.metal, Ego.all]);

  registerWeaponInfo(
      'spear', 50, null, const [Ego.twoHanded, Ego.metal, Ego.stun]);

  registerWeaponInfo(
      'rubber chicken', 0, null, const [Ego.twoHanded, Ego.death]);

  // A spear.

  registerWeaponInfo('gungnir', 50, null, const [
    Ego.twoHanded,
    Ego.metal,
    Ego.acid,
    Ego.gravity,
    Ego.poison,
    Ego.stun
  ]);

  registerWeaponInfo(
      'katana', 50, null, const [Ego.metal, Ego.burst, Ego.parry]);

  registerWeaponInfo('rifle', 50, 'image/missile/white_bolt.png',
      const [Ego.twoHanded, Ego.burst, Ego.ballistic, Ego.metal]);

  registerWeaponInfo('smg', 50, 'image/missile/white_bolt.png',
      const [Ego.burst, Ego.ballistic, Ego.metal]);

  registerWeaponInfo('revolver', 50, 'image/missile/white_bolt.png',
      const [Ego.ballistic, Ego.metal]);

  registerWeaponInfo('shotgun', 250, 'image/missile/white_bolt.png',
      const [Ego.twoHanded, Ego.ballistic, Ego.metal, Ego.maximumDamage]);

  registerWeaponInfo('scepter', 50, null,
      const [Ego.metal, Ego.twoHanded, Ego.magic, Ego.all]);

  registerWeaponInfo('flamethrower', 250, 'image/missile/red_bolt.png',
      const [Ego.twoHanded, Ego.magic, Ego.fire, Ego.burst]);

  // Armor.

  registerArmorInfo('shield', null, #shield, 0, 0, [Ego.metal, Ego.shield]);
  registerArmorInfo('chain mail', null, #body, 15, 0, const [Ego.metal]);
  registerArmorInfo('leather armor', null, #body, 10);
  registerArmorInfo('vest', null, #body, 10);
  registerArmorInfo('robe', null, #body, 0, 25);
  registerArmorInfo('helmet', null, #helmet, 10, 0, const [Ego.metal]);
  registerArmorInfo('gloves', null, #gloves, 5);
  registerArmorInfo('boots', null, #boots, 5);
  registerArmorInfo('jordans', null, #boots, 5, 0, const [Ego.fast]);

  // Sleipnirs combine jordans and evasion boots.

  registerArmorInfo('sleipnirs', null, #boots, 5, 25, const [Ego.fast]);
  registerArmorInfo('cloak', null, #cloak, 0, 25);
  registerArmorInfo('hat', null, #helmet, 5);
  registerArmorInfo('crown', null, #helmet, 5, 0, const [Ego.metal]);

  registerArmorInfo(
      'thorns', null, #helmet, 5, 0, const [Ego.blood, Ego.resistEvil]);

  registerArmorInfo(
      'dream crown', null, #helmet, 5, 0, const [Ego.metal, Ego.resistMagic]);

  registerArmorInfo('fur hat', null, #helmet, 5, 0, const [Ego.resistIce]);
  registerArmorInfo('fur coat', null, #body, 5, 0, const [Ego.resistIce]);

  // Scarves are treated as cloaks.

  registerArmorInfo('fur scarf', null, #cloak, 0, 25, const [Ego.resistIce]);
  registerArmorInfo('ghostly cloak', null, #cloak, 0, 50);
  registerArmorInfo('ghostly robe', null, #body, 0, 50);
  registerArmorInfo('angel wings', null, #cloak, 0, 50, const [Ego.regen]);
  registerArmorInfo('demon wings', null, #cloak, 0, 50, const [Ego.power]);

  registerArmorInfo(
      'starlight cloak', null, #cloak, 0, 50, const [Ego.reflection]);

  registerArmorInfo(
      'starlight robe', null, #body, 0, 50, const [Ego.reflection]);

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

  // Amulets.

  registerItemInfo(
      'wooden charm', ItemInfo(slot: #amulet, egos: const [Ego.resistEvil]));

  registerItemInfo(
      'necklace', ItemInfo(slot: #amulet, egos: const [Ego.metal]));

  registerItemInfo('accuracy amulet',
      ItemInfo(slot: #amulet, egos: const [Ego.metal, Ego.accuracy]));

  registerItemInfo('evasion amulet',
      ItemInfo(slot: #amulet, evasion: 25, egos: const [Ego.metal]));

  registerItemInfo('life amulet',
      ItemInfo(slot: #amulet, egos: const [Ego.metal, Ego.life]));

  registerItemInfo(
      'shark tooth necklace', ItemInfo(slot: #amulet, egos: const [Ego.regen]));

  registerItemInfo('invisibility amulet',
      ItemInfo(slot: #amulet, egos: const [Ego.stealth]));

  registerItemInfo(
      'brisingamen',
      ItemInfo(slot: #amulet, egos: const [
        // Does not have resist evil, making dream crowns more useful.

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

  registerArmorInfo(
      'asprika', null, #cloak, 0, 25, const [Ego.experience, Ego.regen]);

  registerArmorInfo('brynhild', null, #body, 30, 0, const [Ego.power]);

  // Thrown.

  registerThrown(key, ability, egos) => registerItemInfo(
      key,
      ItemInfo(
          slot: #thrown,
          egos: egos,
          use: (doll, item) =>
              doll.targetDoll != null && doll.useAbility(ability)));

  // Thrown egos are only used when examining the item. Actual effects arr from
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
                amount = BigInt.from(uranium?.amount ?? 0);

            // A +100 nuclear reactor will give 2 items.
            // A +500 nuclear reactor will give 6 items.
            // A +900 nuclear reactor will give 10 items.
            // A +999 nuclear reactor is better than a +900 nuclear reactor.

            amount += amount * BigInt.from(reactor.bonus) ~/ BigInt.from(100);

            if (amount > BigInt.zero)
              doll.account
                ..items.deleteItem(uranium)
                ..lootItem(Item('energy')..setAmount(amount));
            else
              doll.alert(alerts[#nothingHappens]);

            return true;
          }));

  registerItemInfo('philosopher\'s stone',
      ItemInfo(use: (Doll doll, Item reactor) {
    var potions = doll.account.items.getItem('blood potion'),
        amount = BigInt.from(potions?.amount ?? 0);

    // A +100 stone will give 2 items.
    // A +500 stone will give 6 items.
    // A +900 stone will give 10 items.
    // A +999 stone is better than a +900 stone.

    amount += amount * BigInt.from(reactor.bonus) ~/ BigInt.from(100);

    if (amount > BigInt.zero)
      doll.account
        ..items.deleteItem(potions)
        ..lootItem(Item('gold')..setAmount(amount));
    else
      doll.alert(alerts[#nothingHappens]);

    return true;
  }));

  registerItemInfo('puzzle box', ItemInfo(use: (Doll doll, Item puzzle) {
    doll.alert(alerts[#nothingHappens]);

    // TODO: think of a new use for this item.

    return true;

    // doll.jump(stages['tutorial0']);

    /*
            var infoName = 'dithmenos';

            if (!doll
                .search(ServerGlobals.sight * 2, ServerGlobals.sight * 2)
                .any((doll) => doll.infoName == infoName && !doll.dead))
              Doll(infoName, null, true,
                      doll.account.highestFloor + puzzle.bonus ~/ 100)
                  .jump(doll.stage, doll.currentLocation);
            else
              doll.alert(alerts[#noUse]);

            return true;
             */
  }));

  registerItemInfo(
      'nuclear bomb',
      ItemInfo(
          egos: const [Ego.metal],
          use: (Doll source, Item bomb) {
            source
                .search(ServerGlobals.sight * 2, ServerGlobals.sight * 2)
                .where(source.account.canViewDoll)
                .where((doll) =>
                    !doll.dead &&
                    !doll.summoned &&
                    !doll.boss &&
                    doll.account == null &&
                    doll.info?.interaction == null)
                .forEach((target) {
              source.account.recentKills[target.id] = true;

              target
                ..killWithNoReward()
                ..splat('no reward', 'effect-text');
            });

            return true;
          }));

  // Items only monsters should have.

  registerWeaponInfo(
      'rock', 10, 'image/missile/brown_bolt.png', const [Ego.ballistic]);

  registerArmorInfo('natural armor', null, #none, 0, 0);
  registerWeaponInfo('natural weapon', 0);

  // Used to calculate scroll damage and accuracy.

  registerWeaponInfo('scroll', 0, null, [Ego.magic]);

  // Tools are two handed for balance reasons, like unicorn horns.

  registerWeaponInfo(
      'pickaxe', 0, null, const [Ego.twoHanded, Ego.mining, Ego.metal]);

  registerWeaponInfo(
      'hatchet', 0, null, const [Ego.twoHanded, Ego.gathering, Ego.metal]);

  registerWeaponInfo('fishing rod', 0, 'image/missile/white_bolt.png',
      const [Ego.ballistic, Ego.twoHanded, Ego.fishing]);

  registerWeaponInfo('leash', 0, null, const [Ego.twoHanded, Ego.charm]);

  // Resources.

  registerItemInfo('stardust', ItemInfo());
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
  registerItemInfo('cosmic dragon scales', ItemInfo());

  // Other ingredients.

  registerItemInfo('energy', ItemInfo());
  registerItemInfo('shark tooth', ItemInfo());
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
}
