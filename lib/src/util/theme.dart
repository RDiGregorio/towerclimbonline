part of util;

class Theme {
  static Theme dungeon = Theme(
      floor: 'brown',
      wall: 'gray',
      water: 'blue',
      dolls: const ['rat', 'kobold', 'yak', 'bat', 'spider', 'yaktaur', 'wolf'],
      bosses: const ['leucrocotta', 'phoenix', 'djinn', 'gunslinger', 'apis'],
      resources: const ['fish', 'tree', 'rock']);

  static Theme haunted =
      Theme(floor: 'maroon', wall: 'brown', water: 'blue', dolls: const [
    'skeleton',
    'earth elemental',
    'whisper',
    'creeper',
    'unicorn',
    'scorpion',
    'shadow'
  ], bosses: const [
    'shadow dragon',
    'wiglaf',
    'pestilence',
    'royal mummy',
    'lich king'
  ], resources: const [
    'shellfish',
    'rock'
  ]);

  static Theme jungle =
      Theme(floor: 'green', wall: 'yellow', water: 'blue', dolls: const [
    'raven',
    'turtle',
    'rhino',
    'wasp',
    'ape',
    'trapper',
    'lion',

    // Added for thematic reasons.

    'cyclops',
    'spriggan'
  ], bosses: const [
    'fire dragon',
    'griffin',
    'doom shroom',
    'ice dragon',
    'lucifer'
  ], resources: const [
    'shark',
    'magic tree',
    'gold',
    'herb'
  ]);

  static Theme ice = Theme(
      floor: 'white',
      wall: 'blue',
      water: 'blue',
      dolls: const [
        'snow critter',
        'viking',
        'ice giant',
        'ice elemental',
        'ice fiend',
        'robot'
      ],
      bosses: const [
        'ancient one',
        'storm dragon',
        'kraken',
        'giant death robot'
      ],
      resources: const [
        'shellfish',
        'rock'
      ]);

  // TODO: use flags for backgrounds (lava background)

  static Theme lava =
      Theme(floor: 'midnightblue', wall: 'red', water: 'orange', dolls: const [
    'salamander',
    'fire elephant',
    'fire turtle',
    'flamethrower',
    'fire elemental',
    'demon cat',
    'spider demon'
  ], bosses: const [
    'medusa',
    'beelzebub',
    'demogorgon',
    'yeenoghu',
    'juiblex'
  ], resources: const [
    'herb',
    'rock'
  ]);

  // TODO: use flags for the backgrounds (sky background)

  static Theme angel = Theme(floor: 'pink', water: 'blue', dolls: const [
    'sacred cow',
    'fallen angel',
    'golden jelly',
    'fairy',
    'cockatrice',
    'star',
    'storm turtle',
    'ice turtle'
  ], bosses: const [
    'blessed dragon',
    'gatekeeper',
    'dark star',
    'cosmic turtle',

    // Added for thematic reasons.

    'gabriel',
    'stacy',
    'popped collar chad'
  ], resources: const [
    'stardust fish',
    'stardust rock',
    'magic tree'
  ]);

  static Theme space = Theme(floor: 'indigo', water: 'black', dolls: const [
    'eye',
    'entropy weaver',
    'temporal vortex',
    'void knight',
    'void mage',
    'black unicorn',
    'ancient believer',

    // Added for thematic reasons.

    'cosmic dragon',
    'infinity star',
    'mecha dragon'
  ], bosses: const [
    'envoy of the beginning',
    'void dragon',
    'death',
    'spirit griffin',
    'cosmic horror'
  ], resources: const [
    'stardust fish',
    'stardust tree',
    'stardust rock'
  ]);

  static Theme snake =
      Theme(floor: 'midnightblue', wall: 'green', water: 'blue', dolls: const [
    'snake',
    'naga',
    'leech',
    'ice naga',
    'fire naga',
    'acid wasp',
    'ghost moth'
  ], bosses: const [
    'mothra',
    'acid dragon',
    'poison dragon',
    'pestilence',
    'lord baal',
    'golden scarab'
  ], resources: const [
    'uranium',
    'shark',
    'herb'
  ]);

  static Theme ocean = Theme(floor: 'darkblue', wall: 'darkblue', dolls: const [
    'crab', 'mermaid', 'whirlpool', 'sea cow',

    // Added for thematic reasons.

    'jellyfish'
  ], bosses: const [
    'jaws',
    'king crab',
    'monolith',

    // Added for thematic reasons.

    'white whale'
  ], resources: const [
    'seaweed',
    'gold'
  ]);

  static Theme blood = Theme(floor: 'darkred', wall: 'red', dolls: const [
    'meat',
    'juggernaut',
    'demon eye',
    'skeleton warrior',
    'kirin',
    'mind flayer'
  ], bosses: const [
    'envoy of the end',
    'ereshkigal',
    'war'
  ], resources: const [
    'tentacles',
    'uranium'
  ]);

  static Theme random(int floor) {
    // Floor x (as displayed in the game) has a [floor] of x - 1.

    var result = [dungeon, haunted, jungle];

    // Unlocked themes.

    if (floor >= 15) result.add(ice);
    if (floor >= 20) result.add(lava);
    if (floor >= 25) result.add(angel);
    if (floor >= 30) result.add(space);
    if (floor >= 35) result.add(snake);
    if (floor >= 40) result.add(ocean);
    if (floor >= 45) result.add(blood);

    // Todo: add "ascended" and "desert" themes.

    return randomValue(result);
  }

  String floor, wall, water;

  List<String> dolls, bosses, resources;

  Theme(
      {this.floor,
      this.wall,
      this.water,
      this.dolls,
      this.bosses,
      this.resources});
}
