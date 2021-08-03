part of content;

void registerAbilities(Map<String, Stage<Doll>> stages) {
  registerAbility(
      'trade',
      Ability(
          combat: false,

          // Trading has a long range because otherwise players would
          // accidentally attack each other while attempting to trade.

          range: ServerGlobals.sight,
          use: (source) {
            if (source.targetDoll != null && source.targetDoll.account == null)
              return false;
            else if (source.prepareAttack(
                source.targetDoll, ServerGlobals.sight)) {
              if (source.targetDoll.account.tradeTarget == source.account)
                source.account.openTrade(source.targetDoll.account);
              else {
                source.alert('You offer to trade.');

                (source.account.tradeTarget = source.targetDoll.account)
                    .sessions
                    .forEach((session) => session.internal.addEvent(
                            ObservableEvent(type: 'trade', data: {
                          'from': source.account.displayedName,
                          'doll': source.id
                        })));
              }

              source.ability = null;
              source.targetDoll = null;
            }

            return false;
          }));

  registerAbility(
      'examine',
      Ability(
          combat: false,
          range: ServerGlobals.sight,
          use: (Doll source) {
            if (source.targetDoll == null) return false;
            var result = examine(source, source.targetDoll, false);

            source
              ..ability = null
              ..targetDoll = null;

            return result;
          }));

  registerAbility(
      'respawn',
      Ability(
          combat: false,
          use: (Doll source) {
            source
              ..ability = null
              ..jump(stages['dungeon0'], Point(62, 165));

            if (source.account?.petSpawned == true) {
              source.revivePet();
              source.summon();
            }
            return true;
          }));

  registerAbility(
      'explore',
      Ability(
          combat: false,
          use: (Doll source) {
            if (source?.stage != null)
              source
                ..ability = null
                ..jump(source.stage,
                    source.stage.randomTraversableLocation(source));

            source
              ..targetDoll = null
              ..ability = null;

            return false;
          }));

  registerAbility(
      'find boss',
      Ability(
          combat: false,
          use: (Doll source) {
            // This ability is can be easily abused by exploring (to heal) then
            // immediately finding the boss again.

            void jump(bosses, safety) {
              if (bosses.isNotEmpty) {
                var traversable = List.from(
                    adjacent(randomValue(bosses).currentLocation).where(
                        (point) => source.stage
                            .traversable(source, point, Terrain.land)));

                if (traversable.isNotEmpty)
                  source.jump(
                      source.stage, randomValue(traversable), false, safety);

                source
                  ..targetDoll = null
                  ..ability = null;
              } else
                // No bosses are found.

                source
                  ..alert('There are no bosses on this floor.')
                  ..targetDoll = null
                  ..ability = null;
            }

            var visibleBosses = List.from(source
                .search(ServerGlobals.sight * 2, ServerGlobals.sight * 2)
                .where(
                    (doll) => doll.boss && !doll.summoned && !doll.temporary));

            var dolls = source?.stage?.dolls ?? const {},
                bosses = List.from(dolls.values.where(
                    (doll) => doll.boss && !doll.summoned && !doll.temporary));

            // Combat does not end for a player that jumps to a boss while a
            // boss is visible.

            jump(bosses, visibleBosses.isEmpty);
            return false;
          }));

  registerAbility(
      'summon pet',
      Ability(
          combat: false,
          use: (Doll source) {
            source
              ..ability = null
              ..summon();

            return false;
          }));

  registerAbility(
      'pet target',
      Ability(
          combat: false,
          range: ServerGlobals.sight,
          use: (Doll source) {
            if (source.targetDoll != null) {
              source.account.pet?.targetDoll = source.targetDoll;
              source.ability = null;
              source.targetDoll = null;
            }

            return false;
          }));

  registerAbility(
      'dismiss pet',
      Ability(
          combat: false,
          use: (Doll source) {
            if (source.account.pet != null)
              source
                ..account.pet.stage?.removeDoll(source.account.pet)
                ..ability = null;

            source.account.petSpawned = false;
            return false;
          }));

  registerAbility(
      'pickpocket',
      Ability(
          combat: false,
          use: (Doll source) {
            source.account.internal['pickpocket target'] =
                source.targetDoll?.infoName;

            if (!source.canPickpocket(source.targetDoll, true)) {
              if (source.targetDoll != null)
                source
                  ..alert(alerts[#no])
                  ..targetDoll = null
                  ..ability = null;

              return false;
            }

            if (source.chessDistanceTo(source.targetDoll.currentLocation) > 1)
              return false;
            else {
              var doll = source.targetDoll, account = source.account;

              if (doll != null) {
                source.pickpocket(doll);

                doll.playersInRange
                    .where((looter) =>
                        looter.id != account.id && looter.canLoot(doll))
                    .forEach((looter) => looter.doll?.pickpocket(doll));
              }

              return true;
            }
          }));

  // Non-player abilities.

  registerAbility('poison attack', Ability(use: (source) {
    if (source.targetDoll == null) return false;

    source.targetDoll.effects.add(Effect(source,
        damage: calculateDamage(source, source.primaryWeapon),
        accuracy: calculateAccuracy(source, source.primaryWeapon),
        egos: const [Ego.poison]));

    return true;
  }));

  registerAbility('blood attack', Ability(use: (source) {
    if (source.targetDoll == null) return false;

    source.targetDoll.effects.add(Effect(source,
        damage: calculateDamage(source, source.primaryWeapon),
        accuracy: calculateAccuracy(source, source.primaryWeapon),
        egos: const [Ego.blood]));

    return true;
  }));

  registerAbility('sickness attack', Ability(use: (source) {
    if (source.targetDoll == null) return false;

    source.targetDoll.effects.add(Effect(source,
        damage: calculateDamage(source, source.primaryWeapon),
        accuracy: calculateAccuracy(source, source.primaryWeapon),
        egos: const [Ego.sickness]));

    return true;
  }));

  registerAbility('blindness attack', Ability(use: (source) {
    if (source.targetDoll == null) return false;

    source.targetDoll.effects.add(Effect(source,
        damage: calculateDamage(source, source.primaryWeapon),
        accuracy: calculateAccuracy(source, source.primaryWeapon),
        egos: const [Ego.blindness]));

    return true;
  }));

  registerAbility('confusion attack', Ability(use: (source) {
    if (source.targetDoll == null) return false;

    source.targetDoll.effects.add(Effect(source,
        damage: calculateDamage(source, source.primaryWeapon),
        accuracy: calculateAccuracy(source, source.primaryWeapon),
        egos: const [Ego.confusion]));

    return true;
  }));

  registerAbility('acid attack', Ability(use: (source) {
    if (source.targetDoll == null) return false;

    source.targetDoll.effects.add(Effect(source,
        damage: calculateDamage(source, source.primaryWeapon),
        accuracy: calculateAccuracy(source, source.primaryWeapon),
        egos: const [Ego.acid]));

    return true;
  }));

  registerAbility('burst attack', Ability(use: (source) {
    if (source.targetDoll == null) return false;

    for (var i = 0; i < 3; i++)
      source.targetDoll.effects.add(Effect(source,
          damage: calculateDamage(source, source.primaryWeapon),
          accuracy: calculateAccuracy(source, source.primaryWeapon),
          egos: const [Ego.burst]));

    return true;
  }));

  registerAbility('blood burst attack', Ability(use: (source) {
    if (source.targetDoll == null) return false;

    for (var i = 0; i < 3; i++)
      source.targetDoll.effects.add(Effect(source,
          damage: calculateDamage(source, source.primaryWeapon),
          accuracy: calculateAccuracy(source, source.primaryWeapon),
          egos: const [Ego.blood, Ego.burst]));

    return true;
  }));

  registerAbility('burst energy attack', Ability(use: (source) {
    if (source.targetDoll == null) return false;

    for (var i = 0; i < 3; i++)
      source.targetDoll.effects.add(Effect(source,
          damage: calculateDamage(source, source.primaryWeapon),
          accuracy: calculateAccuracy(source, source.primaryWeapon),
          egos: const [Ego.burst, Ego.energy]));

    return true;
  }));

  registerAbility('fire burst attack', Ability(use: (source) {
    if (source.targetDoll == null) return false;

    for (var i = 0; i < 3; i++)
      source.targetDoll.effects.add(Effect(source,
          damage: calculateDamage(source, source.primaryWeapon),
          accuracy: calculateAccuracy(source, source.primaryWeapon),
          egos: const [Ego.fire, Ego.burst]));

    return true;
  }));

  registerAbility('explode', Ability(use: (Doll source) {
    if (source.targetDoll == null) return false;

    source
      ..targetDoll
          .effects
          .add(Effect(source, damage: source.health, egos: const [Ego.fire]))
      ..health = 0;

    return true;
  }));

  registerAbility('death attack', Ability(use: (source) {
    if (source.targetDoll == null) return false;

    source.targetDoll.effects.add(Effect(source,
        damage: calculateDamage(source, source.primaryWeapon),
        accuracy: calculateAccuracy(source, source.primaryWeapon),
        egos: const [Ego.death]));

    return true;
  }));

  registerAbility(
      'quake',
      Ability(
          range: 5,
          use: (Doll source) {
            if (source.targetDoll == null) return false;

            source.search(10, 10).where(source.canAreaEffect).forEach(
                (target) => target.effects.add(Effect(source,
                    delay:
                        source.fireAoe(target, 'image/missile/white_bolt.png'),
                    damage: calculateDamage(source, source.primaryWeapon),
                    accuracy: calculateAccuracy(source, source.primaryWeapon),
                    egos: const [Ego.all, Ego.magic])));

            return true;
          }));

  registerAbility(
      'meteor storm',
      Ability(
          range: 5,
          use: (Doll source) {
            if (source.targetDoll == null) return false;

            // Burst quake.

            for (int i = 0; i < 3; i++)
              source.search(10, 10).where(source.canAreaEffect).forEach(
                  (target) => target.effects.add(Effect(source,
                      delay: source.fireAoe(
                          target, 'image/missile/white_bolt.png'),
                      damage: calculateDamage(source, source.primaryWeapon),
                      accuracy: calculateAccuracy(source, source.primaryWeapon),
                      egos: const [Ego.all, Ego.burst, Ego.magic])));

            return true;
          }));

  registerAbility(
      'supernova',
      Ability(
          range: 5,
          use: (Doll source) {
            if (source.targetDoll == null) return false;

            // Energy burst quake.

            for (int i = 0; i < 3; i++)
              source.search(10, 10).where(source.canAreaEffect).forEach(
                  (target) => target.effects
                          .add(
                              Effect(source,
                                  delay: source.fireAoe(
                                      target, 'image/missile/white_bolt.png'),
                                  damage: calculateDamage(
                                      source, source.primaryWeapon),
                                  accuracy: calculateAccuracy(
                                      source, source.primaryWeapon),
                                  egos: const [
                            Ego.all,
                            Ego.burst,
                            Ego.magic,
                            Ego.energy
                          ])));

            return true;
          }));

  registerAbility(
      'curse all',
      Ability(
          range: 5,
          use: (Doll source) {
            if (source.targetDoll == null) return false;

            source.search(10, 10).where(source.canAreaEffect).forEach(
                (target) => target.effects
                        .add(
                            Effect(source,
                                delay: source.fireAoe(target,
                                    'image/missile/black_bolt.png'),
                                damage: calculateDamage(
                                    source, source.primaryWeapon),
                                accuracy: calculateAccuracy(
                                    source, source.primaryWeapon),
                                egos: const [
                          Ego.all,
                          Ego.magic,
                          Ego.sickness,
                          Ego.blindness,
                          Ego.confusion
                        ])));

            return true;
          }));

  registerBolt(key, image, egos, [int damage]) => registerAbility(
      key,
      Ability(
          range: 5,
          use: (source) {
            if (source.targetDoll == null) return false;

            source.targetDoll.effects.add(Effect(source,
                delay: source.fireMissile(image),
                damage: damage ?? calculateDamage(source, source.primaryWeapon),
                accuracy: calculateAccuracy(source, source.primaryWeapon),
                egos: egos));

            return true;
          }));

  registerBolt(
      'fire bolt', 'image/missile/red_bolt.png', const [Ego.magic, Ego.fire]);

  registerBolt(
      'ice bolt', 'image/missile/cyan_bolt.png', const [Ego.magic, Ego.ice]);

  registerBolt('electric bolt', 'image/missile/yellow_bolt.png',
      const [Ego.magic, Ego.electric]);

  registerBolt('gravity bolt', 'image/missile/black_bolt.png',
      const [Ego.magic, Ego.gravity]);

  registerBolt(
      'acid bolt', 'image/missile/brown_bolt.png', const [Ego.magic, Ego.acid]);

  registerBolt('poison bolt', 'image/missile/green_bolt.png',
      const [Ego.magic, Ego.poison]);

  registerBolt('curse', 'image/missile/black_bolt.png',
      const [Ego.magic, Ego.sickness, Ego.blindness, Ego.confusion]);

  // Used for thrown potions and scrolls.

  bool throwAbility(Doll source, String image, [List<int> egos = const []]) {
    if (source.targetDoll == null) return false;

    var count = source.nonWeaponEquipment
                .any((item) => item.egos.contains(Ego.burst))
            ? 3
            : 1,

        // level is used to boost damage, making up for not using a weapon.

        weapon = Item('scroll')..bonus = source.level;

    for (int i = 0; i < count; i++)
      source.targetDoll.effects.add(Effect(source,
          delay: source.fireMissile(image),
          damage: calculateDamage(source, weapon),
          accuracy: calculateAccuracy(source, weapon),
          egos: egos));

    return true;
  }

  // Potions.

  registerPotion(key, image, egos) => registerAbility(key,
      Ability(range: 5, use: (source) => throwAbility(source, image, egos)));

  registerPotion(
      'poison potion', 'image/missile/white_bolt.png', const [Ego.poison]);

  registerPotion('blood potion', 'image/missile/white_bolt', const [Ego.blood]);

  registerPotion('acid potion', 'image/missile/white_bolt', const [Ego.acid]);

  registerPotion('miasma potion', 'image/missile/white_bolt.png',
      const [Ego.sickness, Ego.blindness, Ego.confusion]);

  registerPotion(
      'sickness potion', 'image/missile/white_bolt.png', const [Ego.sickness]);

  registerPotion('blindness potion', 'image/missile/white_bolt.png',
      const [Ego.blindness]);

  registerPotion('confusion potion', 'image/missile/white_bolt.png',
      const [Ego.confusion]);

  // Scrolls.

  registerAbility(
      'super scroll',
      Ability(
          range: 5,
          use: (Doll source) => throwAbility(
              source,
              'image/missile/white_bolt.png',
              [Ego.magic, Ego.fire, Ego.ice, Ego.electric, Ego.gravity])));

  registerAbility(
      'fire scroll',
      Ability(
          range: 5,
          use: (source) => throwAbility(
              source, 'image/missile/red_bolt.png', [Ego.magic, Ego.fire])));

  registerAbility(
      'ice scroll',
      Ability(
          range: 5,
          use: (source) => throwAbility(
              source, 'image/missile/cyan_bolt.png', [Ego.magic, Ego.ice])));

  registerAbility(
      'electric scroll',
      Ability(
          range: 5,
          use: (source) => throwAbility(source, 'image/missile/yellow_bolt.png',
              [Ego.magic, Ego.electric])));

  registerAbility(
      'gravity scroll',
      Ability(
          range: 5,
          use: (source) => throwAbility(source, 'image/missile/black_bolt.png',
              [Ego.magic, Ego.gravity])));

  registerAbility(
      'kill',
      Ability(
          combat: false,
          range: ServerGlobals.sight,
          use: (Doll source) {
            if (!Config.debug) return false;
            var target = source.targetDoll;
            if (target == null) return false;

            target
              ..health = 0

              // Handles life amulet.

              ..health = 0;

            source
              ..targetLocation = null
              ..targetDoll = null
              ..ability = null;

            return false;
          }));
}
