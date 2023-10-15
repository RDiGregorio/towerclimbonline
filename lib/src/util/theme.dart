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
    'doom shroom',
    'ice dragon',
    'lucifer',
    'juiblex'
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
        'kraken'
      ],
      resources: const [
        'shellfish',
        'rock'
      ]);

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
    'yeenoghu'
  ], resources: const [
    'no fish',
    'herb',
    'rock'
  ]);

  static Theme angel = Theme(
      flags: ['background-color: lightskyblue'],
      floor: 'pink',
      water: 'blue',
      dolls: const [
        'sacred cow',
        'fallen angel',
        'golden jelly',
        'fairy',
        'cockatrice',
        'star',
        'storm turtle',
        'ice turtle'
      ],
      bosses: const [
        'blessed dragon',
        'dark star',
        'cosmic turtle',

        // Added for thematic reasons.

        'gatekeeper',
        'gabriel',
        'stacy',
        'giga chad',
        'odin'
      ],
      resources: const ['stardust fish', 'stardust rock', 'magic tree']);

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
    'cosmic horror'
  ], resources: const [
    'stardust fish',
    'stardust tree',
    'stardust rock'
  ]);

  static Theme snake = Theme(
      floor: 'midnightblue',
      wall: 'green',
      water: 'blue',
      dolls: const [
        'snake',
        'naga',
        'leech',
        'ice naga',
        'fire naga',
        'acid wasp',
        'ghost moth'
      ],
      bosses: const [
        'mothra',
        'acid dragon',
        'poison dragon',
        'pestilence'
      ],
      resources: const [
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

  static Theme sand =
      Theme(floor: 'yellow', water: 'blue', wall: 'brown', flags: [
    'background-color: lightskyblue'
  ], dolls: const [
    'arcane monolith',
    'dark fallen angel',
    'griffin',
    'cyclops',
    'mermaid',
    'blue crab'
  ], bosses: const [
    'king crab',
    'ascended crab',
    'spirit griffin'
  ], resources: const [
    'rock',
    'seaweed'
  ]);

  static Theme pyramid = Theme(
      floor: 'yellow',
      water: 'blue',
      wall: 'brown',
      dolls: const [
        'mummy',
        'mummy priest',
        'scorpion',
        'scarab',
        'egyptian kitten',
        'frog'
      ],
      bosses: const [
        'royal mummy',
        'golden scarab',
        'medusa',
        'lord baal'
      ]);

  static Theme machine = Theme(
      floor: 'gray',
      wall: 'gray',
      water: 'black',
      dolls: const [
        'mecha dragon',
        'juggernaut',
        'robot',
        'oil',
        'fire elemental',
        'flamethrower'
      ],
      bosses: const [
        'giant death robot',
        'demogorgon',
        'djinn'
      ],
      resources: const [
        'no fish'
      ]);

  // Has the hardest boss.

  static Theme endgame =
      Theme(floor: 'indigo', water: 'black', wall: 'darkblue', dolls: const [
    'ghost warrior',
    'rainbow elephant',
    'shadow',
    'creeper',
    'ghost moth',
    'kirin',
    'mind flayer'
  ], bosses: const [
    'enryu'
  ], resources: const [
    'gold',
    'seaweed'
  ]);

  String? floor, wall, water;
  List<String> dolls, bosses, resources, flags;

  Theme(
      {this.floor,
      this.wall,
      this.water,
      this.flags = const [],
      this.dolls = const [],
      this.bosses = const [],
      this.resources = const []});

  static Theme? random(int? floor) {
    // Floor x (as displayed in the game) has a [floor] of x - 1.

    var result = [
      dungeon,
      haunted,
      jungle,
      ice,
      lava,
      angel,
      space,
      snake,
      ocean,
      blood,
      sand,
      machine,
      pyramid,
      endgame
    ];

    return randomValue(result);
  }
}
