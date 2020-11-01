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

  // Portals up.

  registerDollInfo('tutorial up',
      portal(stages['dungeon0'], 14, 19, 'image/block/up_stairs.png'));

  registerDollInfo(
      'portal0000',
      portal(stages['dungeon1'], 45, 5, 'image/block/up_stairs.png',
          const ['d0 boss']));

  registerDollInfo(
      'portal0002',
      portal(stages['dungeon2'], 6, 91, 'image/block/up_stairs.png',
          const ['d1 boss']));

  registerDollInfo(
      'portal0004',
      portal(stages['dungeon3'], 11, 25, 'image/block/up_stairs.png',
          const ['d2 boss']));

  registerDollInfo(
      'portal0006',
      portal(stages['dungeon4'], 16, 7, 'image/block/up_stairs.png',
          const ['d3 boss']));

  registerDollInfo(
      'portal0008',
      portal(stages['dungeon5'], 23, 82, 'image/block/up_stairs.png',
          const ['d4 boss']));

  registerDollInfo(
      'portal0010',
      portal(stages['dungeon6'], 29, 72, 'image/block/up_stairs.png',
          const ['d5 boss']));

  registerDollInfo(
      'portal0012',
      portal(stages['dungeon7'], 93, 7, 'image/block/up_stairs.png',
          const ['d6 boss']));

  registerDollInfo(
      'portal0014',
      portal(stages['dungeon8'], 9, 11, 'image/block/up_stairs.png',
          const ['d7 boss']));

  registerDollInfo(
      'portal0016',
      portal(stages['dungeon9'], 2, 3, 'image/block/up_stairs.png',
          const ['d8 boss']));

  registerDollInfo(
      'portal0018',
      portal(stages['dungeon10'], 38, 29, 'image/block/up_stairs.png',
          const ['d9 boss']));

  registerDollInfo(
      'portal0020',
      portal(stages['dungeon11'], 95, 87, 'image/block/up_stairs.png',
          const ['d10 boss']));

  registerDollInfo(
      'portal0022',
      portal(stages['dungeon12'], 26, 7, 'image/block/up_stairs.png',
          const ['d11 boss']));

  registerDollInfo(
      'portal0024',
      portal(stages['dungeon13'], 2, 81, 'image/block/up_stairs.png',
          const ['d12 boss']));

  registerDollInfo(
      'portal0026',
      portal(stages['dungeon14'], 54, 18, 'image/block/up_stairs.png',
          const ['d13 boss']));

  registerDollInfo(
      'portal0028',
      portal(stages['dungeon15'], 25, 95, 'image/block/up_stairs.png',
          const ['d14 boss']));

  registerDollInfo(
      'portal0030',
      portal(stages['dungeon16'], 80, 80, 'image/block/up_stairs.png',
          const ['d15 boss']));

  registerDollInfo(
      'portal0032',
      portal(stages['dungeon17'], 19, 12, 'image/block/up_stairs.png',
          const ['d16 boss']));

  registerDollInfo(
      'portal0034',
      portal(stages['dungeon18'], 79, 19, 'image/block/up_stairs.png',
          const ['d17 boss']));

  registerDollInfo(
      'portal0036',
      portal(stages['dungeon19'], 35, 87, 'image/block/up_stairs.png',
          const ['d18 boss']));

  registerDollInfo(
      'portal0038',
      portal(stages['dungeon20'], 54, 9, 'image/block/up_stairs.png',
          const ['d19 boss']));

  registerDollInfo(
      'portal0040',
      portal(stages['dungeon21'], 39, 90, 'image/block/up_stairs.png',
          const ['d20 boss']));

  registerDollInfo(
      'portal0042',
      portal(stages['dungeon22'], 62, 15, 'image/block/up_stairs.png',
          const ['d21 boss']));

  registerDollInfo(
      'portal0044',
      portal(stages['dungeon23'], 59, 73, 'image/block/up_stairs.png',
          const ['d22 boss']));

  registerDollInfo(
      'portal0046',
      portal(stages['dungeon24'], 20, 24, 'image/block/up_stairs.png',
          const ['d23 boss']));

  registerDollInfo(
      'portal0048',
      portal(stages['dungeon25'], 45, 27, 'image/block/up_stairs.png',
          const ['d24 boss']));

  registerDollInfo(
      'portal0050',
      portal(stages['dungeon26'], 81, 48, 'image/block/up_stairs.png',
          const ['d25 boss']));

  registerDollInfo(
      'portal0052',
      portal(stages['dungeon27'], 27, 19, 'image/block/up_stairs.png',
          const ['d26 boss']));

  registerDollInfo(
      'portal0054',
      portal(stages['dungeon28'], 65, 33, 'image/block/up_stairs.png',
          const ['d27 boss']));

  registerDollInfo(
      'portal0056',
      portal(stages['dungeon29'], 42, 95, 'image/block/up_stairs.png',
          const ['d28 boss']));

  registerDollInfo(
      'portal0058',
      portal(stages['dungeon30'], 77, 51, 'image/block/up_stairs.png',
          const ['d29 boss']));

  registerDollInfo(
      'portal0060',
      portal(stages['dungeon31'], 40, 31, 'image/block/up_stairs.png',
          const ['d30 boss']));

  registerDollInfo(
      'portal0062',
      portal(stages['dungeon32'], 9, 97, 'image/block/up_stairs.png',
          const ['d31 boss']));

  registerDollInfo(
      'portal0064',
      portal(stages['dungeon33'], 53, 3, 'image/block/up_stairs.png',
          const ['d32 boss']));

  registerDollInfo(
      'portal0066',
      portal(stages['dungeon34'], 91, 13, 'image/block/up_stairs.png',
          const ['d33 boss']));

  registerDollInfo(
      'portal0068',
      portal(stages['dungeon35'], 41, 46, 'image/block/up_stairs.png',
          const ['d34 boss']));

  registerDollInfo(
      'portal0070',
      portal(stages['dungeon36'], 66, 72, 'image/block/up_stairs.png',
          const ['d35 boss']));

  registerDollInfo(
      'portal0072',
      portal(stages['dungeon37'], 74, 73, 'image/block/up_stairs.png',
          const ['d36 boss']));

  registerDollInfo(
      'portal0074',
      portal(stages['dungeon38'], 2, 31, 'image/block/up_stairs.png',
          const ['d37 boss']));

  registerDollInfo(
      'portal0076',
      portal(stages['dungeon39'], 30, 6, 'image/block/up_stairs.png',
          const ['d38 boss']));

  registerDollInfo(
      'portal0078',
      portal(stages['dungeon40'], 25, 89, 'image/block/up_stairs.png',
          const ['d39 boss']));

  registerDollInfo(
      'portal0080',
      portal(stages['dungeon41'], 2, 98, 'image/block/up_stairs.png',
          const ['d40 boss']));

  registerDollInfo(
      'portal0082',
      portal(stages['dungeon42'], 56, 32, 'image/block/up_stairs.png',
          const ['d41 boss']));

  registerDollInfo(
      'portal0084',
      portal(stages['dungeon43'], 37, 38, 'image/block/up_stairs.png',
          const ['d42 boss']));

  registerDollInfo(
      'portal0086',
      portal(stages['dungeon44'], 11, 11, 'image/block/up_stairs.png',
          const ['d43 boss']));

  // Portals down.

  registerDollInfo('tutorial down',
      portal(stages['tutorial0'], 7, 3, 'image/block/down_stairs.png'));

  registerDollInfo('portal0001',
      portal(stages['dungeon0'], 73, 87, 'image/block/down_stairs.png'));

  registerDollInfo('portal0003',
      portal(stages['dungeon1'], 23, 37, 'image/block/down_stairs.png'));

  registerDollInfo('portal0005',
      portal(stages['dungeon2'], 30, 12, 'image/block/down_stairs.png'));

  registerDollInfo('portal0007',
      portal(stages['dungeon3'], 84, 92, 'image/block/down_stairs.png'));

  registerDollInfo('portal0009',
      portal(stages['dungeon4'], 29, 76, 'image/block/down_stairs.png'));

  registerDollInfo('portal0011',
      portal(stages['dungeon5'], 11, 16, 'image/block/down_stairs.png'));

  registerDollInfo('portal0013',
      portal(stages['dungeon6'], 40, 7, 'image/block/down_stairs.png'));

  registerDollInfo('portal0015',
      portal(stages['dungeon7'], 32, 64, 'image/block/down_stairs.png'));

  registerDollInfo('portal0017',
      portal(stages['dungeon8'], 67, 54, 'image/block/down_stairs.png'));

  registerDollInfo('portal0019',
      portal(stages['dungeon9'], 37, 39, 'image/block/down_stairs.png'));

  registerDollInfo('portal0021',
      portal(stages['dungeon10'], 41, 64, 'image/block/down_stairs.png'));

  registerDollInfo('portal0023',
      portal(stages['dungeon11'], 26, 98, 'image/block/down_stairs.png'));

  registerDollInfo('portal0025',
      portal(stages['dungeon12'], 86, 16, 'image/block/down_stairs.png'));

  registerDollInfo('portal0027',
      portal(stages['dungeon13'], 87, 62, 'image/block/down_stairs.png'));

  registerDollInfo('portal0029',
      portal(stages['dungeon14'], 36, 80, 'image/block/down_stairs.png'));

  registerDollInfo('portal0031',
      portal(stages['dungeon15'], 76, 12, 'image/block/down_stairs.png'));

  registerDollInfo('portal0033',
      portal(stages['dungeon16'], 49, 68, 'image/block/down_stairs.png'));

  registerDollInfo('portal0035',
      portal(stages['dungeon17'], 3, 91, 'image/block/down_stairs.png'));

  registerDollInfo('portal0037',
      portal(stages['dungeon18'], 10, 74, 'image/block/down_stairs.png'));

  registerDollInfo('portal0039',
      portal(stages['dungeon19'], 72, 84, 'image/block/down_stairs.png'));

  registerDollInfo('portal0041',
      portal(stages['dungeon20'], 98, 64, 'image/block/down_stairs.png'));

  registerDollInfo('portal0043',
      portal(stages['dungeon21'], 22, 25, 'image/block/down_stairs.png'));

  registerDollInfo('portal0045',
      portal(stages['dungeon22'], 14, 58, 'image/block/down_stairs.png'));

  registerDollInfo('portal0047',
      portal(stages['dungeon23'], 86, 26, 'image/block/down_stairs.png'));

  registerDollInfo('portal0049',
      portal(stages['dungeon24'], 67, 83, 'image/block/down_stairs.png'));

  registerDollInfo('portal0051',
      portal(stages['dungeon25'], 48, 93, 'image/block/down_stairs.png'));

  registerDollInfo('portal0053',
      portal(stages['dungeon26'], 9, 70, 'image/block/down_stairs.png'));

  registerDollInfo('portal0055',
      portal(stages['dungeon27'], 38, 55, 'image/block/down_stairs.png'));

  registerDollInfo('portal0057',
      portal(stages['dungeon28'], 25, 52, 'image/block/down_stairs.png'));

  registerDollInfo('portal0059',
      portal(stages['dungeon29'], 40, 12, 'image/block/down_stairs.png'));

  registerDollInfo('portal0061',
      portal(stages['dungeon30'], 24, 27, 'image/block/down_stairs.png'));

  registerDollInfo('portal0063',
      portal(stages['dungeon31'], 44, 31, 'image/block/down_stairs.png'));

  registerDollInfo('portal0065',
      portal(stages['dungeon32'], 92, 32, 'image/block/down_stairs.png'));

  registerDollInfo('portal0067',
      portal(stages['dungeon33'], 8, 29, 'image/block/down_stairs.png'));

  registerDollInfo('portal0069',
      portal(stages['dungeon34'], 95, 13, 'image/block/down_stairs.png'));

  registerDollInfo('portal0071',
      portal(stages['dungeon35'], 26, 79, 'image/block/down_stairs.png'));

  registerDollInfo('portal0073',
      portal(stages['dungeon36'], 58, 56, 'image/block/down_stairs.png'));

  registerDollInfo('portal0075',
      portal(stages['dungeon37'], 37, 57, 'image/block/down_stairs.png'));

  registerDollInfo('portal0077',
      portal(stages['dungeon38'], 93, 85, 'image/block/down_stairs.png'));

  registerDollInfo('portal0079',
      portal(stages['dungeon39'], 48, 14, 'image/block/down_stairs.png'));

  registerDollInfo('portal0081',
      portal(stages['dungeon40'], 26, 21, 'image/block/down_stairs.png'));

  registerDollInfo('portal0083',
      portal(stages['dungeon41'], 97, 3, 'image/block/down_stairs.png'));

  registerDollInfo('portal0085',
      portal(stages['dungeon42'], 76, 39, 'image/block/down_stairs.png'));

  registerDollInfo('portal0087',
      portal(stages['dungeon43'], 70, 26, 'image/block/down_stairs.png'));

  // [Doll]s that a player can fight.

  registerDollInfo(
      'wanderer',
      DollInfo(
          aggro: true,
          difficulty: 1,
          abilities: const ['supernova'],
          image: 'image/npc/ascended_wizard.png',
          loot: DropTable()..addRare(() => Item('puzzle box'))));

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
          loot: DropTable()..addAlways(() => Item('ghostly fabric'))));

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
          loot: DropTable()..addUncommon(() => Item('invisibility potion'))));

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

          // Giants can dual wield weapons that players can't.

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
          loot: DropTable()..addAlways(() => Item('ice cream'))));

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
          image: 'image/npc/fire_elemental.png'));

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
          abilities: const ['poison attack'],
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
          abilities: const ['burst attack', 'gravity bolt'],
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
          image: 'image/npc/whirlpool.png'));

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
            '1': Item('dagger', 1, const [Ego.poison]),
            '2': Item('gloves', 1, const [Ego.thieving])
          },
          loot: DropTable()
            ..addAlways(() => Item('gloves', 1, const [Ego.thieving]))
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
          abilities: const ['blood attack'],
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
          equipped: {'0': Item('life amulet')},
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
          equipped: {'0': Item('fire book')},
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
            '3': Item('vest', 1, const [Ego.resistBallistic]),
            '4': Item('gloves', 1, const [Ego.thieving])
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
            ..addAlways(() => Item('gloves', 1, const [Ego.thieving]))
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
      'death',
      DollInfo(
          difficulty: 8,
          boss: true,
          image: 'image/npc/death.png',
          abilities: ['death attack'],
          equipped: {
            '0': Item('scythe', 1, [Ego.death])
          },
          loot: DropTable()..addAlways(() => Item('scythe', 1, [Ego.death]))));

  registerDollInfo(
      'royal mummy',
      DollInfo(
          boss: true,
          difficulty: 9,
          abilities: const ['curse'],
          image: 'image/npc/mummy.png',
          loot: DropTable()
            ..addUncommon(() => Item('accuracy gloves'))
            ..addAlways(() => Item('poison potion'))));

  registerDollInfo(
      'lich king',
      DollInfo(
          boss: true,
          difficulty: 10,
          image: 'image/npc/lich_king.png',
          equipped: {
            '0': Item('book', 1, const [Ego.ice]),
            '1': Item('crown')
          },
          loot: DropTable()
            ..addAlways(() => Item('book', 1, const [Ego.ice]))
            ..addAlways(() => Item('crown'))
            ..addAlways(() => Item('invisibility potion'))));

  registerDollInfo(
      'fire dragon',
      DollInfo(
          boss: true,
          difficulty: 11,
          image: 'image/npc/fire_dragon.png',
          equipped: {'0': Item('fire dragon armor')},
          abilities: const ['fire bolt', 'burst attack'],
          loot: DropTable()..addAlways(() => Item('fire dragon scales'))));

  registerDollInfo(
      'griffin',
      DollInfo(
          boss: true,
          difficulty: 12,
          image: 'image/npc/griffin.png',
          loot: DropTable()
            ..addAlways(() => Item('regen potion'))
            ..addUncommon(() => Item('hatchet', 1, const [Ego.crystal]))));

  registerDollInfo(
      'doom shroom',
      DollInfo(
          boss: true,
          difficulty: 13,
          abilities: const ['confusion attack'],
          image: 'image/npc/doom_shroom.png',
          loot: DropTable()..addAlways(() => Item('confusion potion'))));

  registerDollInfo(
      'ice dragon',
      DollInfo(
          boss: true,
          difficulty: 14,
          image: 'image/npc/ice_dragon.png',
          equipped: {'0': Item('ice dragon armor')},
          abilities: const ['ice bolt', 'burst attack'],
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
          abilities: const ['ice bolt'],
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
            ..addRandom(() => Item('book', 1, const [Ego.gravity]))
            ..addUncommon(() => Item('accuracy boots'))));

  registerDollInfo(
      'storm dragon',
      DollInfo(
          boss: true,
          difficulty: 18,
          image: 'image/npc/storm_dragon.png',
          equipped: {'0': Item('storm dragon armor')},
          abilities: const ['electric bolt', 'burst attack'],
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
          abilities: const ['fire bolt', 'ice bolt', 'electric bolt'],
          image: 'image/npc/yeenoghu.png',
          loot: DropTable()
            ..addRandom(() => Item('ruby'))
            ..addRandom(() => Item('sapphire'))
            ..addRandom(() => Item('diamond'))
            ..addRandom(() => Item('emerald'))
            ..addUncommon(() => Item('super resist ring'))));

  registerDollInfo(
      'juiblex',
      DollInfo(
          difficulty: 25,
          boss: true,
          walkingCoolDown: 600,
          equipped: {
            '0': Item('natural armor', 1, const [Ego.resistAcid])
          },
          abilities: const ['acid attack'],
          image: 'image/npc/juiblex.png',
          loot: DropTable()..addAlways(() => Item('acid potion'))));

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
      'gatekeeper',
      DollInfo(
          boss: true,
          difficulty: 28,
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
      'dark star',
      DollInfo(
          boss: true,
          difficulty: 29,
          equipped: {
            '0': Item('natural armor', 1, const [Ego.resistGravity]),
          },
          abilities: const ['gravity bolt'],
          image: 'image/npc/dark_star.png',
          loot: DropTable()
            ..addUncommon(() => Item('rainbow diamond'))
            ..addUncommon(() => Item('starlight fabric'))));

  registerDollInfo(
      'cosmic turtle',
      DollInfo(
          boss: true,
          walkingCoolDown: 600,
          abilities: const ['meteor storm'],
          equipped: {
            '0': Item('cosmic turtle shell'),
            '1': Item('rock'),
          },
          difficulty: 30,
          image: 'image/npc/cosmic_turtle.png',
          loot: DropTable()
            ..addAlways(() => Item('cosmic turtle shell'))
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
            '2': Item('katana', 1, const [Ego.blood]),
            '3': Item('katana', 1, const [Ego.blood])
          },
          difficulty: 31,
          image: 'image/npc/fallen_angel.png',
          loot: DropTable()
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
          abilities: const ['gravity bolt', 'burst attack'],
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
          image: 'image/npc/spirit_griffin.png',
          loot: DropTable()
            ..addAlways(
                () => Item('gloves', 1, const [Ego.thieving, Ego.crystal]))));

  registerDollInfo(
      'cosmic horror',
      DollInfo(
          boss: true,
          moves: false,
          difficulty: 35,
          abilities: const ['meteor storm'],
          equipped: {'0': Item('rock')},
          image: 'image/npc/kraken.png',
          loot: DropTable()..addUncommon(() => Item('evasion gloves'))));

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

  // Acid and poison dragons appear on the same floor.

  registerDollInfo(
      'acid dragon',
      DollInfo(
          boss: true,
          difficulty: 37,
          image: 'image/npc/acid_dragon.png',
          equipped: {'0': Item('acid dragon armor')},
          abilities: const ['acid bolt', 'burst attack'],
          loot: DropTable()..addAlways(() => Item('acid dragon scales'))));

  registerDollInfo(
      'poison dragon',
      DollInfo(
          boss: true,
          difficulty: 37,
          image: 'image/npc/poison_dragon.png',
          equipped: {'0': Item('poison dragon armor')},
          abilities: const ['poison bolt', 'burst attack'],
          loot: DropTable()..addAlways(() => Item('poison dragon scales'))));

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
          image: 'image/npc/frog.png',
          loot: DropTable()..addAlways(() => Item('onyx'))));

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
            ..addAlways(() => Item('shark tooth'))
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
            '2': Item('crown', 1)
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
          image: 'image/npc/monolith.png',
          equipped: {
            // Like giants, it can dual wield weapons that players can't.

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
      'odin',
      DollInfo(
          boss: true,
          difficulty: 45,
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
      'stacy',
      DollInfo(
          boss: true,
          difficulty: 45,
          image: 'image/npc/stacy.png',
          equipped: {
            '0': Item('scepter', 1, const [Ego.electric]),
            '1': Item('distortion robe'),
            '2': Item('ring', 1, const [Ego.burst])
          },
          loot: DropTable()
            ..addAlways(() => Item('scepter', 1, const [Ego.electric]))
            ..addAlways(() => Item('distortion robe'))
            ..addAlways(() => Item('ring', 1, const [Ego.burst]))
            ..addRare(() => Item('sleipnirs'))));

  registerDollInfo(
      'popped collar chad',
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
            '3': Item('demon wings')
          },
          difficulty: 46,
          image: 'image/npc/dark_fallen_angel.png',
          loot: DropTable()
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
            '3': Item('robe', 1, [Ego.resistMagic]),
          },
          difficulty: 47,
          image: 'image/npc/shadow.png',
          loot: DropTable()
            ..addAlways(() => Item('robe', 1, [Ego.resistMagic]))
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
            '2': Item('crown'),
            '3': Item('cloak')
          },
          loot: DropTable()
            ..addAlways(() => Item('wrath'))
            ..addAlways(() => Item('chain mail'))
            ..addAlways(() => Item('crown'))
            ..addAlways(() => Item('cloak'))));

  // Bonus enemies.

  registerDollInfo(
      'infinity star',
      DollInfo(
          aggro: true,
          difficulty: 50,
          equipped: {'0': Item('rock')},
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
          abilities: const ['meteor storm', 'burst attack'],
          loot: DropTable()
            ..addAlways(() => Item('spear', 1, const [Ego.crystal]))
            ..addAlways(() => Item('cosmic dragon scales'))));

  registerDollInfo(
      'mecha dragon',
      DollInfo(
          aggro: true,
          difficulty: 60,
          image: 'image/npc/mecha_dragon.png',
          abilities: const ['burst attack'],
          equipped: {'0': Item('chain mail')},
          loot: DropTable()..addAlways(() => Item('iron'))));

  registerDollInfo(
      'stardust dragon',
      DollInfo(
          aggro: true,
          difficulty: Session.maxFloor,
          image: 'image/npc/stardust_dragon.png',
          equipped: {'0': Item('stardust dragon armor')},
          abilities: const ['supernova', 'burst energy attack'],
          loot: DropTable()
            ..addRare(() => Item('stardust sword'))
            ..addAlways(() => Item('stardust dragon scales'))));

  registerDollInfo(
      'lugonu',
      DollInfo(
          boss: true,
          moves: false,
          difficulty: 70,
          image: 'image/npc/monolith.png',
          equipped: {
            // Like giants, it can dual wield weapons that players can't.

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
          difficulty: 70,
          image: 'image/npc/war.png',
          equipped: {
            '0': Item('wrath'),
            '1': Item('brynhild'),
            '2': Item('dream crown'),
            '3': Item('distortion cloak'),
            '4': Item('brisingamen')
          },
          loot: DropTable()
            ..addAlways(() => Item('wrath'))
            ..addAlways(() => Item('brisingamen'))
            ..addAlways(() => Item('brynhild'))
            ..addAlways(() => Item('dream crown'))
            ..addAlways(() => Item('distortion cloak'))));

  registerDollInfo(
      'elyvilon',
      DollInfo(
          boss: true,
          difficulty: 70,
          image: 'image/npc/stacy.png',
          equipped: {
            '0': Item('aegis shield'),
            '1': Item('katana', 1, const [Ego.crystal, Ego.energy]),
            '2': Item('meteorite crown', 1, const [Ego.experience]),
            '3': Item('asprika'),
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
          difficulty: 70,
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
          difficulty: 70,
          image: 'image/npc/black_cat.png',
          abilities: const ['curse', 'burst attack'],
          equipped: {'0': Item('umbra'), '1': Item('brisingamen')},
          loot: DropTable()
            ..addRare(() => Item('invisibility boots'))
            ..addAlways(() => Item('umbra'))
            ..addAlways(() => Item('brisingamen'))));

  registerDollInfo(
      'ascended harambe',
      DollInfo(
          difficulty: 70,
          boss: true,
          equipped: {
            '0': Item('katana', 1, const [Ego.crystal, Ego.energy]),
            '1': Item('katana', 1, const [Ego.crystal, Ego.energy]),
            '2': Item('aegis armor'),
            '3': Item('angel wings'),
            '4': Item('halo'),
            '5': Item('life amulet'),
            '6': Item('power boots'),
            '7': Item('power gloves')
          },
          image: 'image/npc/ascended_harambe.png',
          loot: DropTable()
            ..addAlways(
                () => Item('katana', 2, const [Ego.crystal, Ego.energy]))
            ..addAlways(() => Item('aegis armor'))
            ..addAlways(() => Item('white feathers'))
            ..addAlways(() => Item('halo'))
            ..addAlways(() => Item('life amulet'))
            ..addAlways(() => Item('power boots'))
            ..addAlways(() => Item('power gloves'))
            ..addRare(() => Item('ring', 1, const [Ego.wrath]))));

  registerDollInfo(
      'ascended hero',
      DollInfo(
          difficulty: 70,
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
          difficulty: 70,
          boss: true,
          equipped: {
            '0': Item('smg', 1, const [Ego.electric, Ego.gravity]),
            '1': Item('smg', 1, const [Ego.electric, Ego.gravity]),
            '2': Item('vest', 1, const [Ego.resistBallistic]),
            '3': Item('distortion cloak'),
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
            ..addAlways(() => Item('distortion cloak'))
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
          difficulty: 70,
          boss: true,
          equipped: {
            '0': Item('scepter', 1, const [Ego.crystal, Ego.fire]),
            '1': Item('robe', 1, [Ego.arcane]),
            '2': Item('distortion cloak'),
            '3': Item('dream crown', 1, const [Ego.experience]),
            '4': Item('evasion amulet'),
            '5': Item('evasion boots'),
            '6': Item('evasion gloves'),
            '7': Item('ring', 1, const [Ego.burst, Ego.experience])
          },
          image: 'image/npc/ascended_wizard.png',
          loot: DropTable()
            ..addAlways(() => Item('scepter', 1, const [Ego.crystal, Ego.fire]))
            ..addAlways(() => Item('robe', 1, [Ego.arcane]))
            ..addAlways(() => Item('distortion cloak'))
            ..addAlways(() => Item('dream crown', 1, const [Ego.experience]))
            ..addAlways(() => Item('evasion amulet'))
            ..addAlways(() => Item('evasion boots'))
            ..addAlways(() => Item('evasion gloves'))
            ..addAlways(
                () => Item('ring', 1, const [Ego.burst, Ego.experience]))));

  // The hardest possible boss.

  registerDollInfo(
      'enryu',
      DollInfo(
          difficulty: Session.maxFloor,
          walkingCoolDown: 200,
          boss: true,
          equipped: {
            '0': Item('stardust sword'),
            '1': Item('aegis shield'),
            '2': Item('stardust dragon armor'),
            '3': Item('stardust dragon cloak'),
            '4': Item('dream crown'),
            '5': Item('brisingamen'),
            '6': Item('sleipnirs'),
            '7': Item('power gloves')
          },
          image: 'image/npc/enryu.png',
          loot: DropTable()
            ..addRare(() => Item('ancient ring'))
            ..addAlways(() => Item('stardust sword'))
            ..addAlways(() => Item('aegis shield'))
            ..addAlways(() => Item('stardust dragon armor'))
            ..addAlways(() => Item('stardust dragon cloak'))
            ..addAlways(() => Item('dream crown'))
            ..addAlways(() => Item('brisingamen'))
            ..addAlways(() => Item('sleipnirs'))
            ..addAlways(() => Item('power gloves'))));

  // Dolls on the world stage.

  registerDollInfo(
      'human',
      DollInfo(
          aggro: false,
          difficulty: 1,
          image: 'image/npc/human.png',
          equipped: {'0': Item('revolver')},
          loot: DropTable()..addAlways(() => Item('revolver'))));

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
            ..addAlways(() => Item('sword', 2, const [Ego.ice]))
            ..addAlways(() => Item('umbra'))
            ..addAlways(() => Item('black feathers'))));

  // Altars.

  registerDollInfo(
      'fedhas altar',
      DollInfo(
          image: 'image/block/fedhas_altar.png',
          canPassThis: Terrain.obstacles,
          interaction: (account, doll) {
            var name = godName('fedhas');

            _altar(account, doll, 'fedhas',
                ['$name doubles your summoning level.']);
          }));

  registerDollInfo(
      'makhleb altar',
      DollInfo(
          image: 'image/block/makhleb_altar.png',
          canPassThis: Terrain.obstacles,
          interaction: (account, doll) {
            var name = godName('makhleb');

            _altar(account, doll, 'makhleb',
                ['$name heals you when you deal damage.']);
          }));

  registerDollInfo(
      'elyvilon altar',
      DollInfo(
          image: 'image/block/elyvilon_altar.png',
          canPassThis: Terrain.obstacles,
          interaction: (account, doll) {
            var name = godName('elyvilon');

            _altar(account, doll, 'elyvilon',
                ['$name halves the damage you take.']);
          }));

  registerDollInfo(
      'dithmenos altar',
      DollInfo(
          image: 'image/block/dithmenos_altar.png',
          canPassThis: Terrain.obstacles,
          interaction: (account, doll) {
            var name = godName('dithmenos');
            _altar(account, doll, 'dithmenos', ['$name doubles your stealth.']);
          }));

  registerDollInfo(
      'trog altar',
      DollInfo(
          image: 'image/block/trog_altar.png',
          canPassThis: Terrain.obstacles,
          interaction: (account, doll) {
            var name = godName('trog');

            _altar(
                account, doll, 'trog', ['$name doubles the damage you deal.']);
          }));

  registerDollInfo(
      'lugonu altar',
      DollInfo(
          image: 'image/block/lugonu_altar.png',
          canPassThis: Terrain.obstacles,
          interaction: (account, doll) {
            var name = godName('lugonu');
            _altar(account, doll, 'lugonu',
                ['$name doubles your accuracy and evasion.']);
          }));

  registerDollInfo(
      'gozag altar',
      DollInfo(
          image: 'image/block/gozag_altar.png',
          canPassThis: Terrain.obstacles,
          interaction: (account, doll) {
            var name = godName('gozag');
            _altar(account, doll, 'gozag', ['$name doubles dropped items.']);
          }));

  registerDollInfo(
      'gravestone',
      DollInfo(
          image: 'image/block/gravestone.png',
          canPassThis: Terrain.obstacles,
          interaction: (account, doll) {
            // TODO: add a death log
          }));

  // Shops.

  registerDollInfo(
      'gozag',
      DollInfo(
          overheadText: 'item shop',
          image: 'image/npc/gozag.png',
          interaction: (account, doll) => account.shop([
                // Only gems that can be mined are included.

                Item('ruby'),
                Item('emerald'),
                Item('sapphire'),
                Item('diamond'),
                Item('onyx')
              ])));

  registerDollInfo(
      'newbie shop',
      DollInfo(
          overheadText: 'item shop',
          image: 'image/npc/shop.png',
          interaction: (account, doll) =>
              account.shop([Item('wood'), Item('iron'), Item('hide')])));

  registerDollInfo(
      'trapper shop',
      DollInfo(
          overheadText: 'item shop',
          image: 'image/npc/trapper.png',
          interaction: (account, doll) =>
              account.shop([Item('gunpowder'), Item('web'), Item('fur')])));

  registerDollInfo(
      'dragon shop',
      DollInfo(
          overheadText: 'item shop',
          image: 'image/npc/gunslinger.png',
          interaction: (account, doll) => account.shop([
                // Only scales that give resistances are included.

                Item('fire dragon scales'),
                Item('ice dragon scales'),
                Item('storm dragon scales'),
                Item('void dragon scales'),
                Item('acid dragon scales'),
                Item('poison dragon scales'),
                Item('blessed dragon scales')
              ])));

  registerDollInfo(
      'wizard shop',
      DollInfo(
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

  // [Doll]s that a player can interact with.

  registerDollInfo(
      'newbie guide',
      DollInfo(
          image: 'image/npc/gunslinger.png',
          interaction: (Account account, doll) => account.conversation(
                  const [], const ['Travel to the city.'], (choice) {
                if (choice.contains('temple'))
                  account.doll.jump(stages['dungeon0'], const Point(289, 19));

                if (choice.contains('city'))
                  account.doll.jump(stages['dungeon0'], const Point(117, 117));

                if (choice.contains('fields'))
                  account.doll.jump(stages['dungeon0'], const Point(247, 180));
              })));

  // Ascension.

  ({
    'combat': (Account account) => account.sheet.combat,
    'summoning': (Account account) => account.sheet.summoning,
    'luck': (Account account) => account.sheet.slaying,
    'fishing': (Account account) => account.sheet.fishing,
    'mining': (Account account) => account.sheet.mining,
    'gathering': (Account account) => account.sheet.woodcutting,
    'cooking': (Account account) => account.sheet.cooking,
    'metalworking': (Account account) => account.sheet.metalworking,
    'crafting': (Account account) => account.sheet.crafting,
    'stealth': (Account account) => account.sheet.crime
  }).forEach((key, function) => registerDollInfo(
      '$key ascension',
      DollInfo(
          image: 'image/block/fish.png',
          canPassThis: Terrain.obstacles,
          interaction: (Account account, Doll doll) {
            Stat stat = function(account);
            int requiredUpgrades = Stat.maxLevel * (stat.ascensions + 1);

            // Sigils are not required because that would make ascending
            // crafting a requirement to ascend other skills for players who
            // don't want to buy a sigil.

            bool sigilRequired = false;

            account.conversation([], [
              sigilRequired
                  ? 'Ascend $key (requires a +$requiredUpgrades elysian sigil).'
                  : 'Ascend $key.'
            ], (choice) {
              List<Item> sigils = List<Item>.from(account.items.items.values
                  .where((item) =>
                      item.infoName == 'elysian sigil' &&
                      item.bonus >= requiredUpgrades));

              if (sigilRequired && sigils.isEmpty) {
                account.conversation(
                    ['You need a +$requiredUpgrades elysian sigil to ascend.']);

                return;
              }

              if (stat.ascend()) {
                if (sigilRequired) {
                  var sigil = sigils.reduce((first, second) =>
                      first.bonus < second.bonus ? first : second);

                  account.items.removeItem(sigil.text);
                }

                if (key == 'combat') account.sheet.resetAttributes(10);
                return;
              }

              account.conversation(
                  ['You need a $key level of ${Stat.maxLevel} to ascend.']);
            });
          })));
}

void _altar(Account account, Doll doll, String god, List<String> messages) {
  var name = godName(god), joinMessage = 'Join $name.';

  account.conversation(
      messages, account.god == god ? ['Leave $name.'] : [joinMessage],
      (choice) {
    if (choice == 'Leave $name.') account.god = null;
    if (choice == joinMessage) account.god = god;
  });
}
