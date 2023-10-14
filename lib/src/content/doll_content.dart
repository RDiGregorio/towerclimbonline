part of content;

void registerDolls(Map<String, Stage<Doll>> stages) {
  // A fallback for missing [Doll]s.

  registerDollInfo('missing',
      DollInfo(image: 'image/npc/whisper.png', boss: true, difficulty: 1));

  // [Doll]s a player can gather [Item]s from.

  registerItemSource('fish', 'image/block/fish.png', Terrain.water);
  registerItemSource('stardust fish', 'image/block/fish.png', Terrain.water);
  registerItemSource('shark', 'image/block/fish.png', Terrain.water);
  registerItemSource('shellfish', 'image/block/fish.png', Terrain.water);
  registerItemSource('tree', 'image/block/tree.png');
  registerItemSource('magic tree', 'image/block/magic_tree.png');
  registerItemSource('stardust tree', 'image/block/rainbow_tree.png');
  registerItemSource('rock', 'image/block/rock.png');
  registerItemSource('gold', 'image/block/gold_rock.png');
  registerItemSource('uranium', 'image/block/uranium_rock.png', Terrain.water);
  registerItemSource('stardust rock', 'image/block/rainbow_rock.png');
  registerItemSource('seaweed', 'image/block/seaweed.png');
  registerItemSource('tentacles', 'image/block/tentacles.png');
  registerItemSource('chest', 'image/block/chest.png');
  registerItemSource('herb', 'image/block/herb.png');
  registerItemSource('dummy', 'image/npc/dummy.png');

  // Portals.

  registerDollInfo('up stairs', portal('image/block/up_stairs.png'));
  registerDollInfo('down stairs', portal('image/block/down_stairs.png'));

  // [Doll]s that a player can fight.

  registerDollInfo(
      'wanderer',
      DollInfo(
          aggro: true,
          difficulty: 50,
          equipped: {
            '0': Item('supernova book', 1, [Ego.crystal]),
            '1': Item('cloak', 1, [Ego.arcane])
          },
          image: 'image/npc/ascended_wizard.png',
          loot: DropTable()
            ..addAlways(() => Item('cloak', 1, [Ego.arcane]))
            ..addAlways(() => Item('supernova book', 1, [Ego.crystal]))
            ..addRare(() => Item('puzzle box'))));

  registerDollInfo(
      'rat',
      DollInfo(
          aggro: true,
          difficulty: 1,
          image: 'image/npc/rat.png',
          abilities: const ['sickness attack'],
          loot: DropTable()..addAlways(() => Item('sickness potion'))));

  registerDollInfo(
      'kobold',
      DollInfo(
          aggro: true,
          difficulty: 1,
          image: 'image/npc/kobold.png',
          equipped: {'0': Item('dagger')},
          loot: DropTable()
            ..addAlways(() => Item('dagger'))
            ..addUncommon(() => Item('dagger', 1, const [Ego.electric]))
            ..addUncommon(() => Item('dagger', 1, const [Ego.fire]))
            ..addUncommon(() => Item('dagger', 1, const [Ego.gravity]))
            ..addUncommon(() => Item('dagger', 1, const [Ego.ice]))));

  registerDollInfo(
      'yak',
      DollInfo(
          aggro: true,
          difficulty: 1,
          image: 'image/npc/yak.png',
          loot: DropTable()
            ..addAlways(() => Item('meat'))
            ..addAlways(() => Item('hide'))));

  // Bat difficulty is lowered to appear on F1.

  registerDollInfo(
      'bat',
      DollInfo(
          aggro: true,
          difficulty: 1,
          image: 'image/npc/bat.png',
          abilities: const ['blood attack'],
          loot: DropTable()..addAlways(() => Item('blood potion'))));

  registerDollInfo(
      'spider',
      DollInfo(
          aggro: true,
          difficulty: 3,
          image: 'image/npc/spider.png',
          abilities: const ['poison attack'],
          loot: DropTable()..addAlways(() => Item('web'))));

  registerDollInfo(
      'yaktaur',
      DollInfo(
          aggro: true,
          difficulty: 4,
          equipped: {'0': Item('bow')},
          image: 'image/npc/yaktaur.png',
          loot: DropTable()
            ..addAlways(() => Item('bow'))
            ..addAlways(() => Item('meat'))
            ..addAlways(() => Item('hide'))));

  registerDollInfo(
      'wolf',
      DollInfo(
          aggro: true,
          difficulty: 5,
          walkingCoolDown: 200,
          abilities: const ['burst attack'],
          equipped: {'0': Item('fur coat')},
          image: 'image/npc/wolf.png',
          loot: DropTable()..addAlways(() => Item('fur'))));

  registerDollInfo(
      'skeleton',
      DollInfo(
          aggro: true,
          difficulty: 6,
          image: 'image/npc/skeleton.png',
          loot: DropTable()
            ..addUncommon(() => Item('pickaxe', 1, const [Ego.crystal]))));

  registerDollInfo(
      'earth elemental',
      DollInfo(
          aggro: true,
          difficulty: 6,
          equipped: {'0': Item('rock')},
          image: 'image/npc/earth_elemental.png',
          loot: DropTable()..addAlways(() => Item('iron'))));

  registerDollInfo(
      'whisper',
      DollInfo(
          aggro: true,
          difficulty: 6,
          equipped: {'0': Item('ghostly cloak')},
          image: 'image/npc/whisper.png',
          loot: DropTable()
            ..addUncommon(() => Item('shield', 1, const [Ego.spirit]))
            ..addAlways(() => Item('ghostly fabric'))));

  registerDollInfo(
      'creeper',
      DollInfo(
          aggro: true,
          walkingCoolDown: 600,
          difficulty: 7,
          abilities: const ['explode'],
          image: 'image/npc/creeper.png',
          loot: DropTable()..addAlways(() => Item('gunpowder'))));

  registerDollInfo(
      'unicorn',
      DollInfo(
          aggro: true,
          difficulty: 8,
          equipped: {
            '0': Item('natural armor', 1, const [Ego.regen])
          },
          image: 'image/npc/unicorn.png',
          loot: DropTable()
            ..addAlways(() => Item('unicorn horn'))
            ..addUncommon(() => Item('regen potion'))));

  registerDollInfo(
      'scorpion',
      DollInfo(
          aggro: true,
          difficulty: 9,
          abilities: const ['poison attack'],
          image: 'image/npc/scorpion.png',
          loot: DropTable()..addUncommon(() => Item('poison potion'))));

  registerDollInfo(
      'shadow',
      DollInfo(
          aggro: true,
          difficulty: 10,
          abilities: const ['poison attack', 'sickness attack'],
          image: 'image/npc/shadow.png',
          loot: DropTable()..addUncommon(() => Item('invisibility boots'))));

  registerDollInfo(
      'raven',
      DollInfo(
          aggro: true,
          difficulty: 11,
          abilities: const ['blindness attack'],
          image: 'image/npc/raven.png',
          loot: DropTable()..addUncommon(() => Item('blindness potion'))));

  registerDollInfo(
      'turtle',
      DollInfo(
          aggro: true,
          difficulty: 11,
          walkingCoolDown: 600,
          equipped: {'0': Item('turtle shell')},
          image: 'image/npc/turtle.png',
          loot: DropTable()..addAlways(() => Item('turtle shell'))));

  registerDollInfo(
      'rhino',
      DollInfo(
          aggro: true,
          difficulty: 11,
          image: 'image/npc/rhino.png',
          loot: DropTable()
            ..addAlways(() => Item('meat'))
            ..addAlways(() => Item('hide'))));

  registerDollInfo(
      'wasp',
      DollInfo(
          aggro: true,
          difficulty: 12,
          abilities: const ['poison attack'],
          image: 'image/npc/wasp.png',
          loot: DropTable()..addUncommon(() => Item('poison potion'))));

  registerDollInfo(
    'ape',
    DollInfo(
        aggro: true,
        difficulty: 13,
        equipped: {'0': Item('rock')},
        image: 'image/npc/ape.png',
        loot: DropTable()..addUncommon(() => Item('power boots'))),
  );

  registerDollInfo(
      'trapper',
      DollInfo(
          difficulty: 14,
          aggro: true,
          image: 'image/npc/trapper.png',
          equipped: {
            '0': Item('shotgun'),
            '1': Item('fur coat'),
            '2': Item('fur hat')
          },
          loot: DropTable()
            ..addAlways(() => Item('shotgun'))
            ..addAlways(() => Item('fur coat'))
            ..addAlways(() => Item('fur hat'))
            ..addUncommon(() => Item('hatchet', 1, const [Ego.crystal]))));

  registerDollInfo(
      'lion',
      DollInfo(
          aggro: true,
          difficulty: 15,
          walkingCoolDown: 200,
          abilities: const ['burst attack'],
          equipped: {'0': Item('fur coat')},
          image: 'image/npc/lion.png',
          loot: DropTable()..addAlways(() => Item('fur'))));

  registerDollInfo(
      'snow critter',
      DollInfo(
          aggro: true,
          difficulty: 16,
          image: 'image/npc/snow_critter.png',
          equipped: {
            '0': Item('fur coat'),
            '1': Item('revolver'),
            '2': Item('revolver')
          },
          loot: DropTable()
            ..addAlways(() => Item('fur'))
            ..addAlways(() => Item('revolver', 2))
            ..addUncommon(() => Item('revolver', 1, const [Ego.gravity]))
            ..addUncommon(() => Item('revolver', 1, const [Ego.electric]))
            ..addUncommon(() => Item('revolver', 1, const [Ego.ice]))
            ..addUncommon(() => Item('revolver', 1, const [Ego.fire]))));

  registerDollInfo(
      'viking',
      DollInfo(
          difficulty: 16,
          aggro: true,
          image: 'image/npc/viking.png',
          equipped: {
            '0': Item('sword'),
            '1': Item('chain mail'),
            '2': Item('helmet'),
            '3': Item('shield')
          },
          loot: DropTable()
            ..addAlways(() => Item('sword'))
            ..addAlways(() => Item('chain mail'))
            ..addAlways(() => Item('helmet'))
            ..addAlways(() => Item('shield'))
            ..addUncommon(() => Item('fishing rod', 1, const [Ego.crystal]))));

  registerDollInfo(
      'ice giant',
      DollInfo(
          difficulty: 16,
          aggro: true,
          image: 'image/npc/ice_giant.png',
          equipped: {
            '0': Item('battle axe', 1, const [Ego.ice]),
            '1': Item('battle axe', 1, const [Ego.ice]),
            '2': Item('natural armor', 1, const [Ego.resistIce])
          },
          loot: DropTable()
            ..addAlways(() => Item('battle axe', 2, const [Ego.ice]))));

  registerDollInfo(
      'jellyfish',
      DollInfo(
          moves: false,
          aggro: true,
          difficulty: 17,
          abilities: const ['electric bolt'],
          equipped: {
            '0': Item('natural armor', 1, const [Ego.resistElectric])
          },
          image: 'image/npc/jellyfish.png',
          loot: DropTable()
            ..addUncommon(() => Item('fishing rod', 1, const [Ego.crystal]))));

  registerDollInfo(
      'ice elemental',
      DollInfo(
          aggro: true,
          difficulty: 18,
          equipped: {
            '0': Item('scepter', 1, const [Ego.ice]),
            '1': Item('natural armor', 1, const [Ego.resistIce])
          },
          image: 'image/npc/ice_elemental.png',
          loot: DropTable()
            ..addUncommon(() => Item('ice cream'))
            ..addAlways(() => Item('scepter', 1, const [Ego.ice]))));

  registerDollInfo(
      'ice fiend',
      DollInfo(
          aggro: true,
          difficulty: 19,
          abilities: const ['ice bolt'],
          equipped: {
            '0': Item('natural armor', 1, const [Ego.resistIce])
          },
          image: 'image/npc/ice_fiend.png',
          loot: DropTable()..addAlways(() => Item('ice scroll'))));

  // Robots have extra defense.

  registerDollInfo(
      'robot',
      DollInfo(
          difficulty: 20,
          aggro: true,
          image: 'image/npc/robot.png',
          equipped: {'0': Item('chain mail')},
          loot: DropTable()..addAlways(() => Item('iron'))));

  registerDollInfo(
      'salamander',
      DollInfo(
          difficulty: 21,
          aggro: true,
          image: 'image/npc/salamander.png',
          equipped: {
            '0': Item('spear', 1, const [Ego.fire]),
            '1': Item('natural armor', 1, const [Ego.resistFire])
          },
          loot: DropTable()
            ..addAlways(() => Item('spear', 1, const [Ego.fire]))));

  registerDollInfo(
      'fire elephant',
      DollInfo(
          aggro: true,
          difficulty: 21,
          equipped: {
            '0': Item('natural armor', 1, const [Ego.resistFire])
          },
          abilities: const ['fire bolt'],
          image: 'image/npc/fire_elephant.png',
          loot: DropTable()
            ..addAlways(() => Item('meat'))
            ..addAlways(() => Item('hide'))));

  registerDollInfo(
      'fire turtle',
      DollInfo(
          aggro: true,
          abilities: const ['fire bolt'],
          difficulty: 21,
          walkingCoolDown: 600,
          equipped: {
            '0': Item('turtle shell', 1, const [Ego.resistFire])
          },
          image: 'image/npc/fire_turtle.png',
          loot: DropTable()
            ..addAlways(
                () => Item('turtle shell', 1, const [Ego.resistFire]))));

  registerDollInfo(
      'flamethrower',
      DollInfo(
          aggro: true,
          difficulty: 22,
          equipped: {'0': Item('flamethrower')},
          image: 'image/npc/flamethrower.png',
          loot: DropTable()..addAlways(() => Item('flamethrower'))));

  registerDollInfo(
      'fire elemental',
      DollInfo(
          aggro: true,
          difficulty: 23,
          equipped: {
            '0': Item('natural armor', 1, const [Ego.resistFire])
          },
          abilities: const ['fire bolt'],
          image: 'image/npc/fire_elemental.png',
          loot: DropTable()..addAlways(() => Item('fire scroll'))));

  registerDollInfo(
      'demon cat',
      DollInfo(
          aggro: true,
          difficulty: 24,
          walkingCoolDown: 200,
          abilities: const ['blood burst attack'],
          image: 'image/npc/demon_cat.png',
          loot: DropTable()..addAlways(() => Item('blood potion'))));

  registerDollInfo(
      'spider demon',
      DollInfo(
          aggro: true,
          difficulty: 25,
          image: 'image/npc/spider_demon.png',
          abilities: const ['poison burst attack'],
          loot: DropTable()..addAlways(() => Item('web'))));

  registerDollInfo(
      'sacred cow',
      DollInfo(
          aggro: true,
          difficulty: 26,
          image: 'image/npc/sacred_cow.png',
          equipped: {
            '0': Item('natural armor', 1, const [Ego.regen])
          },
          loot: DropTable()
            ..addAlways(() => Item('meat'))
            ..addAlways(() => Item('hide'))));

  registerDollInfo(
      'fallen angel',
      DollInfo(
          difficulty: 26,
          aggro: true,
          image: 'image/npc/fallen_angel.png',
          equipped: {
            '0': Item('sword', 1, const [Ego.fire]),
            '1': Item('sword', 1, const [Ego.fire]),
            '2': Item('halo'),
            '3': Item('angel wings')
          },
          loot: DropTable()
            ..addAlways(() => Item('sword', 2, const [Ego.fire]))
            ..addAlways(() => Item('halo'))
            ..addAlways(() => Item('white feathers'))));

  registerDollInfo(
      'golden jelly',
      DollInfo(
          aggro: true,
          difficulty: 26,
          equipped: {
            '0': Item('natural armor', 1, const [Ego.resistAcid])
          },
          walkingCoolDown: 600,
          image: 'image/npc/golden_jelly.png',
          abilities: const ['acid attack'],
          loot: DropTable()..addAlways(() => Item('acid potion'))));

  registerDollInfo(
      'fairy',
      DollInfo(
          difficulty: 27,
          aggro: true,
          image: 'image/npc/fairy.png',
          equipped: {
            '0': Item('bow', 1, const [Ego.fire])
          },
          loot: DropTable()
            ..addAlways(() => Item('bow', 1, const [Ego.fire]))));

  registerDollInfo(
      'cockatrice',
      DollInfo(
          aggro: true,
          difficulty: 28,
          image: 'image/npc/cockatrice.png',
          abilities: const ['death attack'],
          loot: DropTable()..addRare(() => Item('rubber chicken'))));

  registerDollInfo(
      'star',
      DollInfo(
          aggro: true,
          difficulty: 29,
          image: 'image/npc/star.png',
          abilities: const ['fire bolt', 'ice bolt', 'electric bolt'],
          loot: DropTable()
            ..addUncommon(() => Item('rainbow diamond'))
            ..addUncommon(() => Item('starlight fabric'))));

  registerDollInfo(
      'storm turtle',
      DollInfo(
          aggro: true,
          abilities: const ['electric bolt'],
          difficulty: 30,
          walkingCoolDown: 600,
          equipped: {
            '0': Item('turtle shell', 1, const [Ego.resistElectric])
          },
          image: 'image/npc/storm_turtle.png',
          loot: DropTable()
            ..addAlways(
                () => Item('turtle shell', 1, const [Ego.resistElectric]))));

  registerDollInfo(
      'ice turtle',
      DollInfo(
          aggro: true,
          abilities: const ['ice bolt'],
          difficulty: 30,
          walkingCoolDown: 600,
          equipped: {
            '0': Item('turtle shell', 1, const [Ego.resistIce])
          },
          image: 'image/npc/ice_turtle.png',
          loot: DropTable()
            ..addAlways(() => Item('turtle shell', 1, const [Ego.resistIce]))));

  registerDollInfo(
      'eye',
      DollInfo(
          aggro: true,
          difficulty: 31,
          abilities: const ['death attack'],
          walkingCoolDown: 600,
          image: 'image/npc/eye.png',
          loot: DropTable()..addAlways(() => Item('wooden charm'))));

  registerDollInfo(
      'entropy weaver',
      DollInfo(
          aggro: true,
          walkingCoolDown: 200,
          difficulty: 31,
          abilities: const ['burst energy attack'],
          image: 'image/npc/entropy_weaver.png',

          // Fast potions are dropped and not slow potions because there's very
          // little need for slow potions when freezing isn't even used much.

          loot: DropTable()..addAlways(() => Item('fast potion'))));

  registerDollInfo(
      'temporal vortex',
      DollInfo(
          aggro: true,
          walkingCoolDown: 200,
          difficulty: 31,
          abilities: const ['burst attack'],
          equipped: {'0': Item('distortion cloak')},
          image: 'image/npc/temporal_vortex.png',
          loot: DropTable()..addAlways(() => Item('spacetime fabric'))));

  registerDollInfo(
      'void knight',
      DollInfo(
          aggro: true,
          difficulty: 32,
          image: 'image/npc/war.png',
          equipped: {
            '0': Item('sword', 1, const [Ego.gravity]),
            '1': Item('chain mail'),
            '2': Item('helmet'),
          },
          loot: DropTable()
            ..addAlways(() => Item('sword', 1, const [Ego.gravity]))
            ..addAlways(() => Item('chain mail'))
            ..addAlways(() => Item('helmet'))));

  registerDollInfo(
      'void mage',
      DollInfo(
          aggro: true,
          difficulty: 33,
          image: 'image/npc/void_mage.png',
          equipped: {
            '0': Item('book', 1, const [Ego.gravity]),
          },
          loot: DropTable()
            ..addAlways(() => Item('book', 1, const [Ego.gravity]))));

  registerDollInfo(
      'black unicorn',
      DollInfo(
          aggro: true,
          difficulty: 34,
          equipped: {
            '0': Item('natural armor', 1, const [Ego.regen])
          },
          image: 'image/npc/black_unicorn.png',
          loot: DropTable()
            ..addAlways(() => Item('unicorn horn'))
            ..addUncommon(() => Item('regen potion'))));

  registerDollInfo(
      'ancient believer',
      DollInfo(
          aggro: true,
          difficulty: 35,
          image: 'image/npc/squid.png',
          equipped: {'0': Item('book')},
          abilities: const [
            'fire bolt',
            'ice bolt',
            'electric bolt',
            'gravity bolt'
          ],
          loot: DropTable()
            ..addRandom(() => Item('book', 1, const [Ego.fire]))
            ..addRandom(() => Item('book', 1, const [Ego.ice]))
            ..addRandom(() => Item('book', 1, const [Ego.electric]))
            ..addRandom(() => Item('book', 1, const [Ego.gravity]))));

  registerDollInfo(
      'snake',
      DollInfo(
          aggro: true,
          difficulty: 36,
          abilities: const ['poison attack'],
          equipped: {
            '0': Item('natural armor', 1, const [Ego.resistPoison])
          },
          image: 'image/npc/snake.png',
          loot: DropTable()..addAlways(() => Item('poison potion'))));

  registerDollInfo(
      'naga',
      DollInfo(
          aggro: true,
          difficulty: 36,
          abilities: const ['poison bolt'],
          equipped: {
            '0': Item('natural armor', 1, const [Ego.resistPoison])
          },
          image: 'image/npc/naga.png',
          loot: DropTable()..addAlways(() => Item('poison potion'))));

  registerDollInfo(
      'leech',
      DollInfo(
          aggro: true,
          difficulty: 36,
          abilities: const ['poison attack'],
          image: 'image/npc/leech.png',
          loot: DropTable()..addAlways(() => Item('blood potion'))));

  registerDollInfo(
      'ice naga',
      DollInfo(
          aggro: true,
          difficulty: 37,
          equipped: {
            '0': Item('bow', 1, const [Ego.ice]),
            '1': Item('natural armor', 1, const [Ego.resistIce])
          },
          image: 'image/npc/ice_naga.png',
          loot: DropTable()..addAlways(() => Item('bow', 1, const [Ego.ice]))));

  registerDollInfo(
      'fire naga',
      DollInfo(
          aggro: true,
          difficulty: 38,
          equipped: {
            '0': Item('bow', 1, const [Ego.fire]),
            '1': Item('natural armor', 1, const [Ego.resistFire])
          },
          image: 'image/npc/fire_naga.png',
          loot: DropTable()
            ..addAlways(() => Item('bow', 1, const [Ego.fire]))));

  registerDollInfo(
      'acid wasp',
      DollInfo(
          aggro: true,
          difficulty: 39,
          equipped: {
            '0': Item('natural armor', 1, const [Ego.resistAcid])
          },
          abilities: const ['acid attack'],
          image: 'image/npc/wasp.png',
          loot: DropTable()..addAlways(() => Item('acid potion'))));

  registerDollInfo(
      'ghost moth',
      DollInfo(
          aggro: true,
          difficulty: 40,
          equipped: {'0': Item('ghostly cloak')},
          image: 'image/npc/ghost_moth.png',
          loot: DropTable()..addAlways(() => Item('ghostly fabric'))));

  registerDollInfo(
      'crab',
      DollInfo(
          aggro: true,
          difficulty: 41,
          image: 'image/npc/crab.png',
          equipped: {
            '0': Item('smg', 1, const [Ego.fire, Ego.electric]),
            '1': Item('smg', 1, const [Ego.fire, Ego.electric])
          },
          loot: DropTable()
            ..addAlways(() => Item('meat'))
            ..addAlways(() => Item('smg', 2, const [Ego.fire, Ego.electric]))));

  registerDollInfo(
      'mermaid',
      DollInfo(
          aggro: true,
          difficulty: 41,
          image: 'image/npc/mermaid.png',
          equipped: {
            '0': Item('spear', 1, const [Ego.ice])
          },
          loot: DropTable()
            ..addAlways(() => Item('spear', 1, const [Ego.ice]))));

  registerDollInfo(
      'whirlpool',
      DollInfo(
          aggro: true,
          walkingCoolDown: 200,
          difficulty: 41,
          abilities: const ['burst attack'],
          image: 'image/npc/whirlpool.png',
          loot: DropTable()..addUncommon(() => Item('seaweed'))));

  // Sea cows are not meant to appear on the sand island floor and are replaced
  // with mermaids there.

  registerDollInfo(
      'sea cow',
      DollInfo(
          aggro: true,
          difficulty: 42,
          image: 'image/npc/sea_cow.png',
          loot: DropTable()
            ..addAlways(() => Item('meat'))
            ..addAlways(() => Item('hide'))));

  registerDollInfo(
      'cyclops',
      DollInfo(
          aggro: true,
          difficulty: 43,
          image: 'image/npc/cyclops.png',
          equipped: {'0': Item('rock')},
          loot: DropTable()..addAlways(() => Item('meteorite'))));

  registerDollInfo(
      'spriggan',
      DollInfo(
          aggro: true,
          walkingCoolDown: 200,
          difficulty: 44,
          image: 'image/npc/spriggan.png',
          equipped: {
            '0': Item('dagger', 1, const [Ego.poison]),
            '1': Item('dagger', 1, const [Ego.poison])
          },
          loot: DropTable()
            ..addRare(() => Item('dagger', 1, const [Ego.lucky]))
            ..addUncommon(
                () => Item('gloves', 1, const [Ego.thieving, Ego.crystal]))
            ..addAlways(() => Item('dagger', 2, const [Ego.poison]))));

  registerDollInfo(
      'meat',
      DollInfo(
          aggro: true,
          difficulty: 46,
          image: 'image/npc/meat.png',
          abilities: const ['blood burst attack'],
          loot: DropTable()
            ..addAlways(() => Item('meat'))
            ..addAlways(() => Item('blood potion'))));

  // A fast robot with a burst attack.

  registerDollInfo(
      'juggernaut',
      DollInfo(
          aggro: true,
          difficulty: 46,
          walkingCoolDown: 200,
          image: 'image/npc/big_robot.png',
          abilities: const ['burst attack'],
          equipped: {'0': Item('chain mail')},
          loot: DropTable()..addAlways(() => Item('iron'))));

  registerDollInfo(
      'demon eye',
      DollInfo(
          aggro: true,
          difficulty: 47,
          abilities: const ['death attack'],
          walkingCoolDown: 200,
          image: 'image/npc/demon_eye.png',
          loot: DropTable()..addAlways(() => Item('wooden charm'))));

  registerDollInfo(
      'skeleton warrior',
      DollInfo(
          aggro: true,
          difficulty: 48,
          image: 'image/npc/skeleton.png',
          equipped: {'0': Item('shield'), '1': Item('sword')},
          loot: DropTable()
            ..addAlways(() => Item('shield'))
            ..addAlways(() => Item('sword'))));

  registerDollInfo(
      'kirin',
      DollInfo(
          aggro: true,
          difficulty: 49,
          equipped: {
            '0': Item('natural armor', 1, const [Ego.regen]),
            '1': Item('kirin horn')
          },
          image: 'image/npc/kirin.png',
          loot: DropTable()..addAlways(() => Item('kirin horn'))));

  registerDollInfo(
      'mind flayer',
      DollInfo(
          aggro: true,
          difficulty: 49,
          abilities: const ['confusion attack'],
          image: 'image/npc/mind_flayer.png',
          loot: DropTable()..addAlways(() => Item('confusion potion'))));

  // Bosses.

  registerDollInfo(
      'leucrocotta',
      DollInfo(
          image: 'image/npc/leucrocotta.png',
          abilities: const ['burst attack'],
          boss: true,
          difficulty: 1,
          walkingCoolDown: 200,
          loot: DropTable()..addAlways(() => Item('regen potion'))));

  registerDollInfo(
      'phoenix',
      DollInfo(
          boss: true,
          difficulty: 2,
          image: 'image/npc/phoenix.png',
          equipped: {
            '0': Item('life amulet'),
            '1': Item('natural armor', 1, const [Ego.resistFire])
          },
          abilities: const ['fire burst attack'],
          loot: DropTable()..addAlways(() => Item('life amulet'))));

  registerDollInfo(
      'apis',
      DollInfo(
          aggro: true,
          boss: true,
          difficulty: 3,
          image: 'image/npc/apis.png',
          equipped: {
            '0': Item('natural armor', 1, const [Ego.regen])
          },
          loot: DropTable()..addAlways(() => Item('gold'))));

  registerDollInfo(
      'djinn',
      DollInfo(
          boss: true,
          difficulty: 4,
          equipped: {
            '0': Item('fire book'),
            '1': Item('natural armor', 1, const [Ego.resistFire])
          },
          image: 'image/npc/djinn.png',
          loot: DropTable()
            ..addAlways(() => Item('book', 1, const [Ego.fire]))));

  registerDollInfo(
      'gunslinger',
      DollInfo(
          boss: true,
          difficulty: 5,
          image: 'image/npc/gunslinger.png',
          equipped: {
            '0': Item('revolver'),
            '1': Item('revolver'),
            '2': Item('hat'),
            '3': Item('vest', 1, const [Ego.resistBallistic])
          },
          loot: DropTable()
            ..addUncommon(() => Item('revolver', 1, const [Ego.gravity]))
            ..addUncommon(() => Item('revolver', 1, const [Ego.electric]))
            ..addUncommon(() => Item('revolver', 1, const [Ego.ice]))
            ..addUncommon(() => Item('revolver', 1, const [Ego.fire]))
            ..addUncommon(
                () => Item('gloves', 1, const [Ego.thieving, Ego.crystal]))
            ..addAlways(() => Item('revolver', 2))
            ..addAlways(() => Item('hat'))
            ..addAlways(() => Item('vest', 1, const [Ego.resistBallistic]))));

  registerDollInfo(
      'shadow dragon',
      DollInfo(
          boss: true,
          difficulty: 6,
          image: 'image/npc/shadow_dragon.png',
          equipped: {'0': Item('shadow dragon armor')},
          abilities: const ['burst attack'],
          loot: DropTable()..addAlways(() => Item('shadow dragon scales'))));

  registerDollInfo(
      'wiglaf',
      DollInfo(
          boss: true,
          difficulty: 7,
          image: 'image/npc/trapper.png',
          equipped: {
            '0': Item('shotgun'),
            '1': Item('vest', 1, const [Ego.resistBallistic])
          },
          loot: DropTable()
            ..addAlways(() => Item('shotgun'))
            ..addAlways(() => Item('vest', 1, const [Ego.resistBallistic]))
            ..addUncommon((() => Item('power gloves')))
            ..addUncommon(() => Item('pickaxe', 1, const [Ego.crystal]))));

  registerDollInfo(
      'acid dragon',
      DollInfo(
          boss: true,
          difficulty: 8,
          image: 'image/npc/acid_dragon.png',
          equipped: {'0': Item('acid dragon armor')},
          abilities: const ['acid blast'],
          loot: DropTable()..addAlways(() => Item('acid dragon scales'))));

  registerDollInfo(
      'poison dragon',
      DollInfo(
          boss: true,
          difficulty: 8,
          image: 'image/npc/poison_dragon.png',
          equipped: {'0': Item('poison dragon armor')},
          abilities: const ['poison blast'],
          loot: DropTable()..addAlways(() => Item('poison dragon scales'))));

  registerDollInfo(
      'royal mummy',
      DollInfo(
          boss: true,
          difficulty: 9,
          abilities: const ['curse'],
          image: 'image/npc/mummy.png',
          loot: DropTable()
            ..addUncommon(() => Item('accuracy gloves'))
            ..addAlways(() => Item('miasma potion'))));

  registerDollInfo(
      'lich king',
      DollInfo(
          boss: true,
          difficulty: 10,
          image: 'image/npc/lich_king.png',
          equipped: {
            '0': Item('book', 1, const [Ego.ice]),
            '1': Item('crown'),
            '2': Item('silk robe')
          },
          loot: DropTable()
            ..addAlways(() => Item('book', 1, const [Ego.ice]))
            ..addAlways(() => Item('silk robe'))
            ..addAlways(() => Item('crown'))
            ..addUncommon(() => Item('invisibility boots'))));

  registerDollInfo(
      'fire dragon',
      DollInfo(
          boss: true,
          difficulty: 11,
          image: 'image/npc/fire_dragon.png',
          equipped: {'0': Item('fire dragon armor')},
          abilities: const ['fire blast'],
          loot: DropTable()..addAlways(() => Item('fire dragon scales'))));

  registerDollInfo(
      'juiblex',
      DollInfo(
          difficulty: 12,
          boss: true,
          walkingCoolDown: 600,
          equipped: {
            '0': Item('natural armor', 1, const [Ego.resistAcid])
          },
          abilities: const ['acid burst attack'],
          image: 'image/npc/juiblex.png',
          loot: DropTable()..addAlways(() => Item('acid potion'))));

  registerDollInfo(
      'doom shroom',
      DollInfo(
          boss: true,
          difficulty: 13,
          abilities: const ['confusion attack'],
          image: 'image/npc/doom_shroom.png',
          loot: DropTable()..addAlways(() => Item('miasma potion'))));

  registerDollInfo(
      'ice dragon',
      DollInfo(
          boss: true,
          difficulty: 14,
          image: 'image/npc/ice_dragon.png',
          equipped: {'0': Item('ice dragon armor')},
          abilities: const ['ice blast'],
          loot: DropTable()..addAlways(() => Item('ice dragon scales'))));

  registerDollInfo(
      'lucifer',
      DollInfo(
          boss: true,
          difficulty: 15,
          abilities: const ['curse'],
          image: 'image/npc/lucifer.png',
          loot: DropTable()..addAlways(() => Item('blood potion'))));

  registerDollInfo(
      'white whale',
      DollInfo(
          boss: true,
          moves: false,
          difficulty: 16,
          abilities: const ['ice blast'],
          image: 'image/npc/white_whale.png',
          loot: DropTable()
            ..addAlways(() => Item('fish'))
            ..addUncommon(() => Item('fishing rod', 1, const [Ego.crystal]))));

  registerDollInfo(
      'ancient one',
      DollInfo(
          boss: true,
          difficulty: 17,
          image: 'image/npc/squid.png',

          // It has a book equipped.

          equipped: {
            '0': Item('book'),
            '1': Item('hat', 1, [Ego.arcane])
          },
          abilities: const [
            'fire bolt',
            'ice bolt',
            'electric bolt',
            'gravity bolt'
          ],
          loot: DropTable()
            ..addRandom(() => Item('book', 1, const [Ego.fire]))
            ..addRandom(() => Item('book', 1, const [Ego.ice]))
            ..addRandom(() => Item('book', 1, const [Ego.electric]))
            ..addRandom(() => Item('book', 1, const [Ego.gravity]))
            ..addAlways(() => Item('hat', 1, [Ego.arcane]))
            ..addUncommon(() => Item('accuracy boots'))));

  registerDollInfo(
      'storm dragon',
      DollInfo(
          boss: true,
          difficulty: 18,
          image: 'image/npc/storm_dragon.png',
          equipped: {'0': Item('storm dragon armor')},
          abilities: const ['electric blast'],
          loot: DropTable()..addAlways(() => Item('storm dragon scales'))));

  registerDollInfo(
      'kraken',
      DollInfo(
          boss: true,
          moves: false,
          difficulty: 19,
          equipped: {'0': Item('rock')},
          image: 'image/npc/kraken.png',
          loot: DropTable()
            ..addAlways(() => Item('tentacle'))
            ..addAlways(() => Item('blindness potion'))
            ..addUncommon(() => Item('shield', 1, const [Ego.resistMagic]))
            ..addUncommon(
                () => Item('shield', 1, const [Ego.resistBallistic]))));

  // A robot with a nuclear reactor and a burst energy attack.

  registerDollInfo(
      'giant death robot',
      DollInfo(
          difficulty: 20,
          boss: true,
          image: 'image/npc/big_robot.png',
          equipped: {'0': Item('chain mail')},
          abilities: const ['burst energy attack'],
          loot: DropTable()
            ..addAlways(() => Item('iron'))
            ..addAlways(() => Item('nuclear reactor'))));

  registerDollInfo(
      'medusa',
      DollInfo(
          difficulty: 21,
          boss: true,
          image: 'image/npc/medusa.png',
          abilities: const ['death attack'],
          loot: DropTable()
            ..addAlways(() => Item('blood potion'))
            ..addUncommon(() => Item('shield', 1, const [Ego.reflection]))));

  registerDollInfo(
      'beelzebub',
      DollInfo(
          difficulty: 22,
          boss: true,
          abilities: const ['curse'],
          image: 'image/npc/beelzebub.png',
          loot: DropTable()..addAlways(() => Item('onyx'))));

  registerDollInfo(
      'demogorgon',
      DollInfo(
          difficulty: 23,
          boss: true,
          image: 'image/npc/demogorgon.png',

          // A fire giant.

          equipped: {
            '0': Item('battle axe', 1, const [Ego.fire]),
            '1': Item('battle axe', 1, const [Ego.fire]),
            '2': Item('natural armor', 1, const [Ego.resistFire])
          },
          loot: DropTable()
            ..addAlways(() => Item('battle axe', 2, const [Ego.fire]))));

  registerDollInfo(
      'yeenoghu',
      DollInfo(
          difficulty: 24,
          boss: true,
          abilities: const ['fire blast', 'ice blast', 'electric blast'],
          image: 'image/npc/yeenoghu.png',
          loot: DropTable()
            ..addRandom(() => Item('ruby'))
            ..addRandom(() => Item('sapphire'))
            ..addRandom(() => Item('diamond'))
            ..addRandom(() => Item('emerald'))
            ..addUncommon(() => Item('super resist ring'))));

  registerDollInfo(
      'gatekeeper',
      DollInfo(
          boss: true,
          difficulty: 25,
          equipped: {
            '0': Item('sword', 1, const [Ego.fire]),
            '1': Item('sword', 1, const [Ego.fire]),
            '2': Item('demon wings'),
            '3': Item('umbra')
          },
          loot: DropTable()
            ..addAlways(() => Item('sword', 2, const [Ego.fire]))
            ..addAlways(() => Item('black feathers'))
            ..addAlways(() => Item('umbra')),
          image: 'image/npc/dark_fallen_angel.png'));

  registerDollInfo(
      'blessed dragon',
      DollInfo(
          boss: true,
          difficulty: 26,
          image: 'image/npc/white_dragon.png',
          equipped: {'0': Item('blessed dragon armor')},
          abilities: const ['burst attack'],
          loot: DropTable()..addAlways(() => Item('blessed dragon scales'))));

  registerDollInfo(
      'chad',
      DollInfo(
          difficulty: 27,
          boss: true,
          equipped: {'0': Item('flamethrower'), '1': Item('super resist hat')},
          image: 'image/npc/chad.png',
          loot: DropTable()
            ..addAlways(() => Item('super resist hat'))
            ..addAlways(() => Item('flamethrower'))
            ..addRare(() => Item('jordans'))));

  registerDollInfo(
      'odin',
      DollInfo(
          boss: true,
          difficulty: 28,
          image: 'image/npc/war.png',
          equipped: {
            '0': Item('gungnir'),
            '1': Item('chain mail'),
            '2': Item('helmet')
          },
          loot: DropTable()
            ..addAlways(() => Item('gungnir'))
            ..addAlways(() => Item('chain mail'))
            ..addAlways(() => Item('helmet'))));

  registerDollInfo(
      'dark star',
      DollInfo(
          boss: true,
          difficulty: 29,
          abilities: const ['gravity bolt'],
          image: 'image/npc/dark_star.png',
          loot: DropTable()
            ..addAlways(() => Item('rainbow diamond'))
            ..addAlways(() => Item('starlight fabric'))));

  registerDollInfo(
      'cosmic turtle',
      DollInfo(
          boss: true,
          walkingCoolDown: 600,
          abilities: const ['meteor storm'],
          equipped: {'0': Item('cosmic turtle shell')},
          difficulty: 30,
          image: 'image/npc/cosmic_turtle.png',
          loot: DropTable()
            ..addAlways(() => Item('cosmic turtle shell'))
            ..addRandom(() => Item('katana', 1, const [Ego.acid]))
            ..addRandom(() => Item('katana', 1, const [Ego.poison]))
            ..addRandom(() => Item('katana', 1, const [Ego.gravity]))
            ..addRandom(() => Item('katana', 1, const [Ego.electric]))
            ..addRandom(() => Item('katana', 1, const [Ego.fire]))
            ..addRandom(() => Item('katana', 1, const [Ego.ice]))));

  registerDollInfo(
      'envoy of the beginning',
      DollInfo(
          boss: true,
          equipped: {
            '0': Item('super resist hat'),
            '1': Item('angel wings'),

            // The katanas are only used for parrying.

            '2': Item('katana', 1, const [Ego.blood]),
            '3': Item('katana', 1, const [Ego.blood]),
            '4': Item('reflection amulet')
          },
          abilities: const ['meteor storm'],
          difficulty: 31,
          image: 'image/npc/fallen_angel.png',
          loot: DropTable()
            ..addAlways(() => Item('reflection amulet'))
            ..addAlways(() => Item('super resist hat'))
            ..addAlways(() => Item('white feathers'))
            ..addAlways(() => Item('katana', 2, const [Ego.blood]))));

  registerDollInfo(
      'void dragon',
      DollInfo(
          boss: true,
          difficulty: 32,
          image: 'image/npc/void_dragon.png',
          equipped: {'0': Item('void dragon armor')},
          abilities: const ['gravity blast'],
          loot: DropTable()..addAlways(() => Item('void dragon scales'))));

  registerDollInfo(
      'famine',
      DollInfo(
          difficulty: 33,
          boss: true,
          image: 'image/npc/famine.png',
          abilities: const ['curse all'],
          loot: DropTable()..addAlways(() => Item('miasma potion'))));

  registerDollInfo(
      'spirit griffin',
      DollInfo(
          boss: true,
          difficulty: 34,
          abilities: const ['burst attack'],
          equipped: {'0': Item('ghostly cloak')},
          image: 'image/npc/spirit_griffin.png',
          loot: DropTable()
            ..addUncommon(() => Item('shield', 1, const [Ego.spirit]))
            ..addAlways(() => Item('ghostly fabric'))
            ..addAlways(
                () => Item('gloves', 1, const [Ego.thieving, Ego.crystal]))));

  registerDollInfo(
      'cosmic horror',
      DollInfo(
          boss: true,
          moves: false,
          difficulty: 35,
          abilities: const ['meteor storm'],
          image: 'image/npc/kraken.png',
          loot: DropTable()
            ..addAlways(() => Item('tentacle'))
            ..addAlways(() => Item('meteorite'))
            ..addUncommon(() => Item('evasion gloves'))));

  registerDollInfo(
      'mothra',
      DollInfo(
          aggro: true,
          boss: true,
          difficulty: 36,
          equipped: {'0': Item('dream crown')},
          abilities: const ['curse'],
          image: 'image/npc/moth.png',
          loot: DropTable()
            ..addAlways(() => Item('dream crown'))
            ..addUncommon(() => Item('evasion boots'))));

  registerDollInfo(
      'death',
      DollInfo(
          difficulty: 37,
          boss: true,
          image: 'image/npc/death.png',
          equipped: {
            '0': Item('scythe', 1, [Ego.death]),
            '1': Item('ghostly robe'),
            '2': Item('ghostly cloak'),
            '3': Item('ghostly hat')
          },
          loot: DropTable()
            ..addAlways(() => Item('scythe', 1, [Ego.death]))
            ..addAlways(() => Item('ghostly fabric', 3))));

  registerDollInfo(
      'pestilence',
      DollInfo(
          boss: true,
          difficulty: 38,
          image: 'image/npc/pestilence.png',
          abilities: const ['curse all'],
          loot: DropTable()..addAlways(() => Item('miasma potion'))));

  registerDollInfo(
      'lord baal',
      DollInfo(
          boss: true,
          difficulty: 39,
          abilities: const ['death attack'],
          image: 'image/npc/frog.png',
          loot: DropTable()..addAlways(() => Item('philosopher\'s stone'))));

  registerDollInfo(
      'golden scarab',
      DollInfo(
          boss: true,
          difficulty: 40,
          image: 'image/npc/golden_scarab.png',
          abilities: const ['curse'],
          loot: DropTable()
            ..addAlways(() => Item('gold'))
            ..addUncommon(
                () => Item('scepter', 1, const [Ego.blood, Ego.crystal]))));

  registerDollInfo(
      'jaws',
      DollInfo(
          aggro: true,
          boss: true,
          abilities: const ['burst attack'],
          difficulty: 41,
          image: 'image/npc/shark.png',
          loot: DropTable()
            ..addAlways(() => Item('shark'))
            ..addRandom(() => Item('katana', 1, const [Ego.electric]))
            ..addRandom(() => Item('katana', 1, const [Ego.fire]))
            ..addRandom(() => Item('katana', 1, const [Ego.ice]))
            ..addRandom(() => Item('katana', 1, const [Ego.acid]))
            ..addRandom(() => Item('katana', 1, const [Ego.poison]))
            ..addRandom(() => Item('katana', 1, const [Ego.gravity]))));

  registerDollInfo(
      'king crab',
      DollInfo(
          boss: true,
          difficulty: 42,
          image: 'image/npc/king_crab.png',
          equipped: {
            '0': Item('smg', 1, const [Ego.ice, Ego.gravity]),
            '1': Item('smg', 1, const [Ego.ice, Ego.gravity]),
            '2': Item('crown')
          },
          loot: DropTable()
            ..addAlways(() => Item('meat'))
            ..addAlways(() => Item('crown'))
            ..addAlways(() => Item('smg', 2, const [Ego.ice, Ego.gravity]))));

  registerDollInfo(
      'monolith',
      DollInfo(
          boss: true,
          moves: false,
          difficulty: 43,
          image: 'image/npc/arcane_monolith.png',
          equipped: {
            // It can dual wield weapons that players can't.

            '0': Item('scepter', 1, const [Ego.fire]),
            '1': Item('scepter', 1, const [Ego.ice]),

            // It is like a robot made of meteorite.

            '2': Item('chain mail', 1,
                const [Ego.resistGravity, Ego.resistAcid, Ego.resistPoison])
          },
          loot: DropTable()
            ..addAlways(() => Item('scepter', 1, const [Ego.fire]))
            ..addAlways(() => Item('scepter', 1, const [Ego.ice]))
            ..addAlways(() => Item('meteorite'))));

  registerDollInfo(
      'gabriel',
      DollInfo(
          difficulty: 44,
          boss: true,
          aggro: true,
          image: 'image/npc/fallen_angel.png',
          equipped: {
            '0': Item('rainbow undecimber'),
            '1': Item('rainbow undecimber'),
            '2': Item('halo'),
            '3': Item('angel wings')
          },
          loot: DropTable()
            ..addAlways(() => Item('rainbow undecimber', 2))
            ..addAlways(() => Item('halo'))
            ..addAlways(() => Item('white feathers'))));

  registerDollInfo(
      'stacy',
      DollInfo(
          boss: true,
          difficulty: 45,
          image: 'image/npc/stacy.png',
          equipped: {
            '0': Item('supernova book'),
            '1': Item('starlight robe'),
            '2': Item('meteorite ring', 1, const [Ego.burst])
          },
          loot: DropTable()
            ..addAlways(() => Item('supernova book'))
            ..addAlways(() => Item('starlight robe'))
            ..addAlways(() => Item('meteorite ring', 1, const [Ego.burst]))
            ..addRare(() => Item('sleipnirs'))));

  registerDollInfo(
      'giga chad',
      DollInfo(
          difficulty: 45,
          boss: true,
          equipped: {
            '0': Item('smg', 1, const [Ego.fire, Ego.electric]),
            '1': Item('smg', 1, const [Ego.fire, Ego.electric]),
            '2': Item('super resist hat')
          },
          image: 'image/npc/chad.png',
          loot: DropTable()
            ..addAlways(() => Item('super resist hat'))
            ..addAlways(() => Item('smg', 2, const [Ego.fire, Ego.electric]))
            ..addRare(() => Item('jordans'))));

  registerDollInfo(
      'envoy of the end',
      DollInfo(
          boss: true,
          equipped: {
            '0': Item('meteorite crown'),
            '1': Item('smg', 1, const [Ego.fire, Ego.gravity]),
            '2': Item('smg', 1, const [Ego.fire, Ego.gravity]),
            '3': Item('demon wings'),
            '4': Item('reflection amulet')
          },
          difficulty: 46,
          image: 'image/npc/dark_fallen_angel.png',
          loot: DropTable()
            ..addAlways(() => Item('reflection amulet'))
            ..addAlways(() => Item('meteorite crown'))
            ..addAlways(() => Item('smg', 2, const [Ego.fire, Ego.gravity]))
            ..addAlways(() => Item('black feathers'))));

  registerDollInfo(
      'ereshkigal',
      DollInfo(
          aggro: true,
          boss: true,
          equipped: {
            '0': Item('dream crown'),
            '1': Item('katana', 1, const [Ego.gravity]),
            '2': Item('katana', 1, const [Ego.gravity]),
            '3': Item('starlight robe'),
          },
          difficulty: 47,
          image: 'image/npc/shadow.png',
          loot: DropTable()
            ..addAlways(() => Item('starlight robe'))
            ..addAlways(() => Item('dream crown'))
            ..addAlways(() => Item('katana', 2, const [Ego.gravity]))));

  registerDollInfo(
      'war',
      DollInfo(
          boss: true,
          difficulty: 48,
          image: 'image/npc/war.png',
          equipped: {
            '0': Item('wrath'),
            '1': Item('chain mail'),
            '2': Item('crown', 1, const [Ego.experience])
          },
          loot: DropTable()
            ..addAlways(() => Item('wrath'))
            ..addAlways(() => Item('chain mail'))
            ..addAlways(() => Item('crown', 1, const [Ego.experience]))));

  // Extra themes.

  registerDollInfo(
      'ascended crab',
      DollInfo(
          boss: true,
          aggro: true,
          difficulty: 50,
          image: 'image/npc/ascended_crab.png',
          equipped: {
            '0': Item('smg', 1, const [Ego.berserk, Ego.energy]),
            '1': Item('smg', 1, const [Ego.berserk, Ego.energy]),
            '2': Item('reflection amulet'),
            '3': Item('dream crown', 1, const [Ego.experience])
          },
          loot: DropTable()
            ..addAlways(() => Item('meat'))
            ..addAlways(() => Item('reflection amulet'))
            ..addAlways(() => Item('dream crown', 1, const [Ego.experience]))
            ..addAlways(
                () => Item('smg', 2, const [Ego.berserk, Ego.energy]))));

  registerDollInfo(
      'blue crab',
      DollInfo(
          aggro: true,
          difficulty: 50,
          image: 'image/npc/blue_crab.png',
          equipped: {
            '0': Item('smg', 1, const [Ego.gravity, Ego.electric]),
            '1': Item('smg', 1, const [Ego.gravity, Ego.electric]),
            '2': Item('life amulet')
          },
          loot: DropTable()
            ..addAlways(() => Item('meat'))
            ..addAlways(() => Item('life amulet'))
            ..addAlways(
                () => Item('smg', 2, const [Ego.gravity, Ego.electric]))));

  registerDollInfo(
      'arcane monolith',
      DollInfo(
          moves: false,
          difficulty: 50,
          image: 'image/npc/arcane_monolith.png',
          equipped: {
            // It can dual wield weapons that players can't.

            '0': Item('scepter', 1, const [Ego.crystal, Ego.energy]),
            '1': Item('scepter', 1, const [Ego.crystal, Ego.energy]),

            // It is like a robot made of meteorite.

            '2': Item('chain mail', 1,
                const [Ego.resistGravity, Ego.resistAcid, Ego.resistPoison])
          },
          loot: DropTable()
            ..addAlways(
                () => Item('scepter', 2, const [Ego.crystal, Ego.energy]))
            ..addAlways(() => Item('meteorite'))));

  registerDollInfo(
      'griffin',
      DollInfo(
          difficulty: 50,
          abilities: const ['burst attack'],
          image: 'image/npc/griffin.png',
          loot: DropTable()
            ..addAlways(() => Item('regen potion'))
            ..addUncommon(() => Item('hatchet', 1, const [Ego.crystal]))));

  registerDollInfo(
      'ghost warrior',
      DollInfo(
          aggro: true,
          difficulty: 50,
          equipped: {
            '0': Item('ghostly cloak'),
            '1': Item('shield', 1, const [Ego.crystal, Ego.spirit]),
            '2': Item('katana', 1, const [Ego.berserk, Ego.energy])
          },
          image: 'image/npc/whisper.png',
          loot: DropTable()
            ..addAlways(
                () => Item('shield', 1, const [Ego.crystal, Ego.spirit]))
            ..addAlways(
                () => Item('katana', 1, const [Ego.berserk, Ego.energy]))
            ..addAlways(() => Item('ghostly fabric'))));

  registerDollInfo(
      'rainbow elephant',
      DollInfo(
          difficulty: 50,
          abilities: const ['annihilation bolt'],
          image: 'image/npc/yeenoghu.png',
          loot: DropTable()
            ..addRare(() => Item('annihilation book', 1, [Ego.crystal]))));

  registerDollInfo(
      'oil',
      DollInfo(
          difficulty: 12,
          walkingCoolDown: 600,
          abilities: const ['blindness attack'],
          image: 'image/npc/oil.png',
          loot: DropTable()
            ..addAlways(() => Item('blindness potion'))
            ..addUncommon(() => Item('invisibility boots'))));

  registerDollInfo(
      'mummy',
      DollInfo(
          difficulty: 50,
          image: 'image/npc/mummy.png',
          loot: DropTable()..addUncommon(() => Item('miasma potion'))));

  registerDollInfo(
      'mummy priest',
      DollInfo(
          difficulty: 50,
          abilities: const ['curse'],
          image: 'image/npc/mummy_priest.png',
          loot: DropTable()..addUncommon(() => Item('miasma potion'))));

  registerDollInfo(
      'scarab',
      DollInfo(
          difficulty: 50,
          image: 'image/npc/scarab.png',
          loot: DropTable()
            ..addRandom(() => Item('ruby'))
            ..addRandom(() => Item('sapphire'))
            ..addRandom(() => Item('diamond'))
            ..addRandom(() => Item('emerald'))));

  registerDollInfo(
      'frog',
      DollInfo(
          difficulty: 50,
          abilities: const ['death attack'],
          image: 'image/npc/small_frog.png',
          loot: DropTable()..addRare(() => Item('crown'))));

  // An aggressive kitten for the pyramid theme.

  registerDollInfo(
      'egyptian kitten',
      DollInfo(
          image: 'image/npc/kitten.png',
          difficulty: 50,
          abilities: const ['burst attack']));

  // Bonus enemies.

  registerDollInfo(
      'infinity star',
      DollInfo(
          aggro: true,
          difficulty: 50,
          abilities: const ['gravity bolt'],
          image: 'image/npc/dark_star.png',
          loot: DropTable()
            ..addAlways(() => Item('rainbow diamond'))
            ..addAlways(() => Item('starlight fabric'))));

  registerDollInfo(
      'cosmic dragon',
      DollInfo(
          aggro: true,
          difficulty: 50,
          image: 'image/npc/cosmic_dragon.png',
          equipped: {'0': Item('cosmic dragon armor')},
          abilities: const ['meteor storm'],
          loot: DropTable()
            ..addAlways(() => Item('spear', 1, const [Ego.crystal]))
            ..addAlways(() => Item('cosmic dragon scales'))));

  registerDollInfo(
      'mecha dragon',
      DollInfo(
          aggro: true,
          difficulty: 50,
          image: 'image/npc/mecha_dragon.png',
          abilities: const ['burst attack'],
          equipped: {'0': Item('chain mail')},
          loot: DropTable()..addAlways(() => Item('iron'))));

  registerDollInfo(
      'stardust dragon',
      DollInfo(
          boss: true,
          aggro: true,
          difficulty: 50,
          image: 'image/npc/ascended_dragon.png',
          equipped: {'0': Item('stardust dragon armor')},
          abilities: const ['burst energy attack'],
          loot: DropTable()..addAlways(() => Item('stardust dragon scales'))));

  registerDollInfo(
      'lugonu',
      DollInfo(
          boss: true,
          moves: false,
          difficulty: 50,
          image: 'image/npc/monolith.png',
          equipped: {
            // It can dual wield weapons that players can't.

            '0': Item('scepter', 1, const [Ego.crystal, Ego.energy]),
            '1': Item('scepter', 1, const [Ego.crystal, Ego.energy]),

            // It is like a robot made of meteorite.

            '2': Item('chain mail', 1,
                const [Ego.resistGravity, Ego.resistAcid, Ego.resistPoison])
          },
          loot: DropTable()
            ..addAlways(
                () => Item('scepter', 2, const [Ego.crystal, Ego.energy]))
            ..addAlways(() => Item('meteorite'))));

  registerDollInfo(
      'trog',
      DollInfo(
          boss: true,
          difficulty: 50,
          image: 'image/npc/war.png',
          equipped: {
            '0': Item('wrath'),
            '1': Item('wrath'),
            '2': Item('brynhild'),
            '3': Item('dream crown'),
            '4': Item('distortion cloak'),
            '5': Item('brisingamen')
          },
          loot: DropTable()
            ..addAlways(() => Item('wrath', 2))
            ..addAlways(() => Item('brisingamen'))
            ..addAlways(() => Item('brynhild'))
            ..addAlways(() => Item('dream crown'))
            ..addAlways(() => Item('distortion cloak'))));

  registerDollInfo(
      'elyvilon',
      DollInfo(
          boss: true,
          difficulty: 50,
          image: 'image/npc/stacy.png',
          equipped: {
            '0': Item('aegis shield'),
            '1': Item('katana', 1, const [Ego.crystal, Ego.energy]),
            '2': Item('meteorite crown', 1, const [Ego.experience]),
            '3': Item('asprika')
          },
          loot: DropTable()
            ..addAlways(() => Item('aegis shield'))
            ..addAlways(() => Item('asprika'))
            ..addAlways(
                () => Item('katana', 1, const [Ego.crystal, Ego.energy]))
            ..addAlways(
                () => Item('meteorite crown', 1, const [Ego.experience]))));

  registerDollInfo(
      'makhleb',
      DollInfo(
          boss: true,
          difficulty: 50,
          image: 'image/npc/makhleb.png',
          equipped: {
            '0': Item('scepter', 1, const [Ego.blood, Ego.crystal]),
            '1': Item('super resist ring', 1, const [Ego.experience])
          },
          loot: DropTable()
            ..addRare(() => Item('thorns'))
            ..addAlways(
                () => Item('scepter', 1, const [Ego.blood, Ego.crystal]))
            ..addAlways(
                () => Item('super resist ring', 1, const [Ego.experience]))));

  // Replaces the 49 difficulty boss.

  registerDollInfo(
      'dithmenos',
      DollInfo(
          boss: true,
          difficulty: 49,
          image: 'image/npc/black_cat.png',
          abilities: const ['curse', 'burst attack'],
          equipped: {'0': Item('umbra'), '1': Item('brisingamen')},
          loot: DropTable()
            ..addAlways(() => Item('umbra'))
            ..addAlways(() => Item('brisingamen'))));

  registerDollInfo(
      'ascended harambe',
      DollInfo(
          difficulty: 50,
          boss: true,
          equipped: {
            '0': Item('smg', 1, const [Ego.crystal, Ego.energy]),
            '1': Item('smg', 1, const [Ego.crystal, Ego.energy]),
            '2': Item('aegis armor'),
            '3': Item('angel wings'),
            '4': Item('halo'),
            '5': Item('life amulet'),
            '6': Item('power boots'),
            '7': Item('power gloves')
          },
          image: 'image/npc/ascended_harambe.png',
          loot: DropTable()
            ..addAlways(() => Item('smg', 2, const [Ego.crystal, Ego.energy]))
            ..addAlways(() => Item('aegis armor'))
            ..addAlways(() => Item('white feathers'))
            ..addAlways(() => Item('halo'))
            ..addAlways(() => Item('life amulet'))
            ..addAlways(() => Item('power boots'))
            ..addAlways(() => Item('power gloves'))
            ..addRare(() => Item('ring', 1, const [Ego.berserk]))));

  registerDollInfo(
      'ascended hero',
      DollInfo(
          difficulty: 50,
          boss: true,
          equipped: {
            '0': Item('rainbow undecimber'),
            '1': Item('rainbow undecimber'),
            '2': Item('cosmic dragon armor'),
            '3': Item('distortion cloak'),
            '4': Item('meteorite crown', 1, const [Ego.experience]),
            '5': Item('power amulet'),
            '6': Item('power boots'),
            '7': Item('power gloves'),
            '8': Item('ring', 1, const [Ego.burst, Ego.experience])
          },
          image: 'image/npc/hero.png',
          loot: DropTable()
            ..addAlways(() => Item('rainbow undecimber', 2))
            ..addAlways(() => Item('cosmic dragon armor'))
            ..addAlways(() => Item('distortion cloak'))
            ..addAlways(
                () => Item('meteorite crown', 1, const [Ego.experience]))
            ..addAlways(() => Item('power amulet'))
            ..addAlways(() => Item('power boots'))
            ..addAlways(() => Item('power gloves'))
            ..addAlways(
                () => Item('ring', 1, const [Ego.burst, Ego.experience]))));

  registerDollInfo(
      'ascended gunslinger',
      DollInfo(
          difficulty: 50,
          boss: true,
          equipped: {
            '0': Item('smg', 1, const [Ego.electric, Ego.gravity]),
            '1': Item('smg', 1, const [Ego.electric, Ego.gravity]),
            '2': Item('vest', 1, const [Ego.resistBallistic]),
            '3': Item('starlight cloak'),
            '4': Item('super resist hat', 1, const [Ego.experience]),
            '5': Item('accuracy amulet'),
            '6': Item('accuracy boots'),
            '7': Item('accuracy gloves'),
            '8': Item('meteorite ring', 1, const [Ego.experience])
          },
          image: 'image/npc/ascended_gunslinger.png',
          loot: DropTable()
            ..addAlways(() => Item('smg', 2, const [Ego.electric, Ego.gravity]))
            ..addAlways(() => Item('vest', 1, const [Ego.resistBallistic]))
            ..addAlways(() => Item('starlight cloak'))
            ..addAlways(
                () => Item('super resist hat', 1, const [Ego.experience]))
            ..addAlways(() => Item('accuracy amulet'))
            ..addAlways(() => Item('accuracy boots'))
            ..addAlways(() => Item('accuracy gloves'))
            ..addAlways(
                () => Item('meteorite ring', 1, const [Ego.experience]))));

  registerDollInfo(
      'ascended wizard',
      DollInfo(
          difficulty: 50,
          boss: true,
          equipped: {
            '0': Item('annihilation book'),
            '1': Item('robe', 1, [Ego.arcane]),
            '2': Item('starlight cloak'),
            '3': Item('dream crown', 1, const [Ego.experience]),
            '4': Item('evasion amulet'),
            '5': Item('evasion boots'),
            '6': Item('evasion gloves'),
            '7': Item('ring', 1, const [Ego.burst, Ego.experience])
          },
          image: 'image/npc/ascended_wizard.png',
          loot: DropTable()
            ..addAlways(() => Item('annihilation book'))
            ..addAlways(() => Item('robe', 1, [Ego.arcane]))
            ..addAlways(() => Item('starlight cloak'))
            ..addAlways(() => Item('dream crown', 1, const [Ego.experience]))
            ..addAlways(() => Item('evasion amulet'))
            ..addAlways(() => Item('evasion boots'))
            ..addAlways(() => Item('evasion gloves'))
            ..addAlways(
                () => Item('ring', 1, const [Ego.burst, Ego.experience]))));

  // The hardest boss.

  registerDollInfo(
      'enryu',
      DollInfo(
          difficulty: Session.maxFloor,
          walkingCoolDown: 200,
          boss: true,
          equipped: {
            '0': Item('rainbow undecimber'),
            '1': Item('aegis shield'),
            '2': Item('stardust dragon armor'),
            '3': Item('stardust dragon cloak'),
            '4': Item('dream crown', 1, const [Ego.experience]),
            '5': Item('brisingamen'),
            '6': Item('sleipnirs'),
            '7': Item('power gloves'),
            '8': Item('ring', 1, const [Ego.berserk, Ego.burst])
          },
          image: 'image/npc/enryu.png',
          loot: DropTable()
            ..addAlways(() => Item('rainbow undecimber'))
            ..addAlways(() => Item('aegis shield'))
            ..addAlways(() => Item('stardust dragon armor'))
            ..addAlways(() => Item('stardust dragon cloak'))
            ..addAlways(() => Item('dream crown', 1, const [Ego.experience]))
            ..addAlways(() => Item('brisingamen'))
            ..addAlways(() => Item('sleipnirs'))
            ..addAlways(() => Item('power gloves'))
            ..addAlways(
                () => Item('ring', 1, const [Ego.berserk, Ego.burst]))));

  // Dolls on the world stage.

  registerDollInfo(
      'human',
      DollInfo(
          aggro: false,
          difficulty: 1,
          image: 'image/npc/human.png',
          loot: DropTable()..addUncommon(() => Item('revolver'))));

  registerDollInfo(
      'soldier',
      DollInfo(
          aggro: false,
          difficulty: 5,
          equipped: {
            '0': Item('vest', 1, const [Ego.resistBallistic]),
            '1': Item('rifle')
          },
          image: 'image/npc/soldier.png',
          loot: DropTable()
            ..addUncommon(() => Item('shield', 1, const [Ego.resistBallistic]))
            ..addAlways(() => Item('vest', 1, const [Ego.resistBallistic]))
            ..addAlways(() => Item('rifle'))));

  registerDollInfo(
      'dark fallen angel',
      DollInfo(
          difficulty: 26,
          aggro: false,
          image: 'image/npc/dark_fallen_angel.png',
          equipped: {
            '0': Item('sword', 1, const [Ego.fire]),
            '1': Item('sword', 1, const [Ego.fire]),
            '2': Item('umbra'),
            '3': Item('demon wings')
          },
          loot: DropTable()
            ..addAlways(() => Item('sword', 2, const [Ego.fire]))
            ..addAlways(() => Item('umbra'))
            ..addAlways(() => Item('black feathers'))));

  // Altars.

  registerDollInfo(
      'fedhas altar',
      DollInfo(
          image: 'image/block/fedhas_altar.png',
          canPassThis: Terrain.obstacles,
          interaction: (account, doll) => _altar(account, doll, 'fedhas',
              '2 × your fishing, mining, and gathering level')));

  registerDollInfo(
      'makhleb altar',
      DollInfo(
          image: 'image/block/makhleb_altar.png',
          canPassThis: Terrain.obstacles,
          interaction: (account, doll) {
            _altar(account, doll, 'makhleb',
                'heals you by 25% of the damage you deal');
          }));

  registerDollInfo(
      'elyvilon altar',
      DollInfo(
          image: 'image/block/elyvilon_altar.png',
          canPassThis: Terrain.obstacles,
          interaction: (account, doll) =>
              _altar(account, doll, 'elyvilon', 'you take 0.5 × damage')));

  registerDollInfo(
      'dithmenos altar',
      DollInfo(
          image: 'image/block/dithmenos_altar.png',
          canPassThis: Terrain.obstacles,
          interaction: (account, doll) =>
              _altar(account, doll, 'dithmenos', '2 × your stealth level')));

  registerDollInfo(
      'trog altar',
      DollInfo(
          image: 'image/block/trog_altar.png',
          canPassThis: Terrain.obstacles,
          interaction: (account, doll) =>
              _altar(account, doll, 'trog', 'you deal 2 × damage')));

  registerDollInfo(
      'lugonu altar',
      DollInfo(
          image: 'image/block/lugonu_altar.png',
          canPassThis: Terrain.obstacles,
          interaction: (account, doll) => _altar(
              account, doll, 'lugonu', 'increases your highest floor by 5')));

  registerDollInfo(
      'gozag altar',
      DollInfo(
          image: 'image/block/gozag_altar.png',
          canPassThis: Terrain.obstacles,
          interaction: (account, doll) =>
              _altar(account, doll, 'gozag', '1.25 × your luck level')));

  registerDollInfo(
      'ashenzari altar',
      DollInfo(
          image: 'image/block/ashenzari_altar.png',
          canPassThis: Terrain.obstacles,
          interaction: (account, doll) => _altar(account, doll, 'ashenzari',
              '2 × combat, luck, and taming experience')));

  registerDollInfo(
      'qazlal altar',
      DollInfo(
          image: 'image/block/qazlal_altar.png',
          canPassThis: Terrain.obstacles,
          interaction: (account, doll) => _altar(account, doll, 'qazlal',
              'adds fire, ice, and electric effects to your attacks')));

  registerDollInfo(
      'okawaru altar',
      DollInfo(
          image: 'image/block/okawaru_altar.png',
          canPassThis: Terrain.obstacles,
          interaction: (account, doll) => _altar(account, doll, 'okawaru',
              '2 × your chance of parrying with swords and katanas')));

  registerDollInfo(
      'xom altar',
      DollInfo(
          image: 'image/block/xom_altar.png',
          canPassThis: Terrain.obstacles,
          interaction: (account, doll) =>
              _altar(account, doll, 'xom', 'does absolutely nothing')));

  registerDollInfo(
      'gravestone',
      DollInfo(
          image: 'image/block/gravestone.png',
          canPassThis: Terrain.obstacles,
          interaction: (account, doll) {
            // Displays information about the player's most recent death.

            var floorNote = account.internal['floor note'] ?? 'none',
                sourceNote = account.internal['source note'] ?? 'none',
                damageNote = account.internal['damage note'] ?? 'none',
                message = '';

            if (damageNote != 'none')
              damageNote = formatCurrency(damageNote, false);

            message += 'floor: $floorNote<br>';
            message += 'source: $sourceNote<br>';
            message += 'damage: $damageNote';
            account.informationPrompt(message);
          }));

  // Tutorial.

  registerDollInfo(
      'tutorial',
      DollInfo(
          overheadText: 'guide',
          image: 'image/npc/dark_fallen_angel.png',
          interaction: (account, doll) {
            account.conversation([], [
              'Idle combat.',
              'Bosses and floors.',
              'Gathering and crafting.',
              'Elements and resistances.',
              'Taming and pets.'
            ], (choice) {
              if (choice.contains('combat')) {
                var message = '';
                message += '<b>idle combat:</b>' + '<br>';

                message += '🞄 combat can be trained by waiting next to a boss ' +
                    '(bosses are always aggressive and you heal after combat)' +
                    '<br>';

                message +=
                    '🞄 other enemies can be made aggressive in the "options" window' +
                        '<br>';

                message +=
                    '🞄 automatic food can be enabled in the "items" window' +
                        '<br>';

                account.informationPrompt(message);
                return;
              }

              if (choice.contains('resistances')) {
                var message = '';
                message += '<b>elements:</b>' + '<br>';
                message += '🞄 ' + Ego.longDescriptions[Ego.fire] + '<br>';
                message += '🞄 ' + Ego.longDescriptions[Ego.ice] + '<br>';
                message += '🞄 ' + Ego.longDescriptions[Ego.electric] + '<br>';
                message += '🞄 ' + Ego.longDescriptions[Ego.acid] + '<br>';
                message += '🞄 ' + Ego.longDescriptions[Ego.poison] + '<br>';
                message += '🞄 ' + Ego.longDescriptions[Ego.gravity] + '<br>';

                message +=
                    '🞄  blood ' + Ego.longDescriptions[Ego.blood] + '<br>';

                message += '<b>resistances:</b>' + '<br>';
                message += '🞄 resistances completely prevent these effects';
                account.informationPrompt(message);
                return;
              }

              if (choice.contains('floors')) {
                var message = '';
                message += '<b>bosses:</b>' + '<br>';

                message +=
                    '🞄 bosses are shown as red dots on the map' + '<br>';

                message +=
                    '🞄 defeating a boss on a floor unlocks the next floor' +
                        '<br>';

                message += '<b>floors:</b>' + '<br>';

                message +=
                    '🞄 you can travel between floors with the "teleport" ability';

                account.informationPrompt(message);
                return;
              }

              if (choice.contains('crafting')) {
                var message = '';
                message += '<b>gathering:</b>' + '<br>';

                message += '🞄 resource nodes (rocks, trees, and so on) ' +
                    'on higher floors give more items' +
                    '<br>';

                message += '🞄 white resource nodes give 2 × items' + '<br>';
                message += '🞄 yellow resource nodes give 4 × items' + '<br>';
                message += '🞄 cyan resource nodes give 8 × items' + '<br>';
                message += '<b>crafting:</b>' + '<br>';

                message += '🞄 recepies are in the "items" window ' +
                    '(click on "info" then an ingredient)' +
                    '<br>';

                message +=
                    '🞄 "max upgrade" repeatedly upgrades a stack of items ' +
                        'until only the entered amount is left';

                account.informationPrompt(message);
                return;
              }

              if (choice.contains('pets')) {
                var message = '';
                message += '<b>taming and pets:</b>' + '<br>';

                message += '🞄 all players start with a leash' + '<br>';

                message +=
                    '🞄 leashes can also be crafted from hides, which are dropped by yaks ' +
                        '<br>';

                message += '🞄 attacking an enemy with a leash tames it; ' +
                    'that enemy becomes your pet once it is 100% tamed' +
                    '<br>';

                message += '🞄 the taming skill increases damage from leashes' +
                    '<br>';

                message +=
                    '🞄 you can tame both regular enemies and bosses' + '<br>';

                account.informationPrompt(message);
                return;
              }
            });
          }));

  // Shops.

  registerDollInfo(
      'random shop',
      DollInfo(
          canPassThis: Terrain.obstacles,
          overheadText: 'item shop',
          image: 'image/npc/shop.png',
          interaction: (account, doll) =>
              account.shop(RandomShop.generate(account, doll))));

  registerDollInfo(
      'newbie shop',
      DollInfo(
          canPassThis: Terrain.obstacles,
          overheadText: 'item shop',
          image: 'image/npc/shop.png',
          interaction: (account, doll) => account.shop([
                Item('wood'),
                Item('iron'),
                Item('hide'),
                Item('fast potion'),
                Item('regen potion')
              ])));

  registerDollInfo(
      'trapper shop',
      DollInfo(
          canPassThis: Terrain.obstacles,
          overheadText: 'item shop',
          image: 'image/npc/trapper.png',
          interaction: (account, doll) => account.shop([
                Item('gunpowder'),
                Item('web'),
                Item('fur'),
                Item('gold'),
                Item('unicorn horn')
              ])));

  registerDollInfo(
      'dragon shop',
      DollInfo(
          canPassThis: Terrain.obstacles,
          overheadText: 'item shop',
          image: 'image/npc/gunslinger.png',
          interaction: (account, doll) => account.shop([
                // Only scales that give resistances, except for blessed dragon
                // scales, are included.

                Item('fire dragon scales'),
                Item('ice dragon scales'),
                Item('storm dragon scales'),
                Item('void dragon scales'),
                Item('acid dragon scales'),
                Item('poison dragon scales')
              ])));

  registerDollInfo(
      'wizard shop',
      DollInfo(
          canPassThis: Terrain.obstacles,
          overheadText: 'item shop',
          image: 'image/npc/void_mage.png',
          interaction: (account, doll) => account.shop([
                Item('spacetime fabric'),
                Item('starlight fabric'),
                Item('ghostly fabric')
              ])));

  // Pets.

  registerDollInfo(
      'kitten',
      DollInfo(
          image: 'image/npc/kitten.png',
          difficulty: 1,
          abilities: const ['burst attack'],
          aggro: false));

  registerDollInfo(
      'puppy',
      DollInfo(
          image: 'image/npc/puppy.png',
          difficulty: 1,
          abilities: const ['burst attack'],
          aggro: false));
}

void _altar(Account account, Doll doll, String god, String description) {
  var name = godName(god), joinMessage = 'Join $name ($description).';

  account.conversation(
      [],
      account.god == god
          ? ['Leave $name.', 'Cancel.']
          : [joinMessage, 'Cancel.'], (choice) {
    if (choice == 'Leave $name.') {
      account.god = null;
      account.alert('You leave $name.');
    }

    if (choice == joinMessage) {
      account.god = god;
      account.alert('You join $name.');
    }
  });
}
