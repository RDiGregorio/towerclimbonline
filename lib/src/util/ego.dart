part of util;

// You can add new egos but you can't remove old ones because they are used for
// serialization.

class Ego {
  static const int fire = 0,
      ice = 1,
      electric = 2,
      poison = 3,
      sickness = 4,
      fast = 5,
      slow = 6,
      blood = 7,
      thieving = 8,
      power = 9,
      magic = 10,
      ballistic = 11,
      burst = 12,
      twoHanded = 13,
      healing = 14,
      confusion = 15,
      blindness = 16,
      charm = 17,
      wrath = 18,
      regen = 19,
      stealth = 20,
      food = 21,
      gravity = 22,
      reflection = 23,
      experience = 24,
      antimatter = 25,
      stun = 26,
      lucky = 27,
      acid = 28,
      crystal = 29,
      shield = 30,
      parry = 31,
      death = 32,
      metal = 33,
      all = 34,
      energy = 35,
      killWithoutReward = 36,
      life = 37,
      resistFire = 38,
      resistIce = 39,
      resistElectric = 40,
      resistPoison = 41,
      resistGravity = 42,
      resistAcid = 43,
      resistEvil = 44,
      resistBallistic = 45,
      maximumDamage = 46,
      accuracy = 47,
      arcane = 48,
      resistMagic = 49,
      fishing = 50,
      mining = 51,
      gathering = 52,
      rainbow = 53,
      demon = 54;

  static const Map<int, String> longDescriptions = {
    acid: 'acid attack (+100% damage; ignores target defense)',
    fire: 'fire attack (+200% damage)',
    ice: 'ice attack (+100% damage; prevents target movement)',
    electric: 'electric attack (+100% damage; ignores target evasion)',
    poison: 'poison attack (+100% damage; damages target over time)',
    fast: 'fast movement',
    slow: null,
    wrath: 'berserk attack (3 × damage)',
    blood: 'heals user by 10% damage dealt',
    thieving: '+1% resources from pickpocketing per upgrade',
    power: '+25% damage',
    magic: 'magic weapon (uses intelligence for damage)',
    ballistic: 'ballistic weapon (uses dexterity for damage)',
    burst: 'burst attack (3 × attack)',
    twoHanded: 'two handed weapon',
    healing: 'heals target',
    sickness: 'sickness attack (-50% target strength)',
    confusion: 'confusion attack (-50% target intelligence)',
    blindness: 'blindness attack (-50% target dexterity)',
    gravity:
        'gravity attack (+100% damage; target loses 2.5% remaining health)',
    experience: '+10% experience',
    antimatter: 'antimatter attack (+500% damage)',
    all: 'area of effect',

    // Energy can't be resisted.

    energy: 'energy attack (+100% damage)',
    crystal: 'made of crystal (+100% skill experience)',
    fishing: '+1% resources from fishing per upgrade',
    mining: '+1% resources from mining per upgrade',
    gathering: '+1% resources from gathering per upgrade',

    // "25%" and not "+25%" because the base parry is 0.

    parry: '25% parry',
    death: 'death attack (kills target without reward)',
    metal: 'made of metal',
    charm: 'increases summoning by upgrade amount',
    resistAcid: 'resists acid attacks',
    resistFire: 'resists fire attacks',
    resistIce: 'resists ice attacks',
    resistElectric: 'resists electric attacks',
    resistPoison: 'resists poison attacks',
    resistGravity: 'resists gravity attacks',
    resistEvil: 'resists evil (blood, death, and debuff) attacks',
    resistBallistic: 'resists ballistic attacks',
    resistMagic: 'resists magic attacks',
    regen: 'heals user over time',
    stealth: 'invisibility (+100% stealth)',
    reflection: 'reflects ballistic damage; reflects magic damage',
    lucky: '+100% dropped items',
    life: '+1 life',
    stun: 'stun attack (prevents target\'s next attack)',
    maximumDamage: 'deals maximum damage',
    accuracy: '+25% accuracy',
    arcane: '+100% magic damage',

    // "50%" and not "+50%" because the base damage reduction is 0.

    shield: '50% damage reduction',
    rainbow: 'rainbow',
    demon: 'demon'
  };

  static const Map<int, String> descriptions = {
    acid: 'acid',
    fire: 'fire',
    ice: 'ice',
    electric: 'electric',
    poison: 'poison',
    fast: 'fast',
    slow: 'slow',
    wrath: 'berserk',
    blood: 'blood',
    power: 'power',
    magic: 'magic',
    ballistic: 'ballistic',
    burst: 'burst',
    twoHanded: 'two handed',
    healing: 'heal',
    sickness: 'sickness',
    confusion: 'confusion',
    blindness: 'blindness',
    gravity: 'gravity',
    experience: 'experience',
    antimatter: 'antimatter',
    all: 'area of effect',
    energy: 'energy',
    crystal: 'crystal',
    parry: 'parry',
    death: 'death',
    metal: 'metal',
    charm: 'charm',
    resistAcid: 'resist acid',
    resistFire: 'resist fire',
    resistIce: 'resist ice',
    resistElectric: 'resist electric',
    resistPoison: 'resist poison',
    resistGravity: 'resist gravity',
    resistEvil: 'resist evil',
    resistBallistic: 'resist ballistic',
    resistMagic: 'resist magic',
    regen: 'regen',
    stealth: 'invisibility',
    reflection: 'reflection',
    lucky: 'lucky',
    life: 'life',
    thieving: 'thieving',
    stun: 'stun',
    maximumDamage: 'maximum damage',
    accuracy: 'accuracy',
    arcane: 'arcane',
    fishing: 'fishing',
    mining: 'mining',
    gathering: 'lumberjack',
    shield: 'defense',
    rainbow: 'rainbow',
    demon: 'demon'
  };

  static const Map<int, int> resistedBy = {
    fire: resistFire,
    ice: resistIce,
    electric: resistElectric,
    poison: resistPoison,
    gravity: resistGravity,
    acid: resistAcid,

    // Blood attacks are considered evil.

    blood: resistEvil,
    ballistic: resistBallistic
  };

  static List<int> parse(String string) {
    for (List<int> result = [];;) {
      string = string.trim();

      var key = descriptions.keys.firstWhere(
          (key) => string.startsWith(descriptions[key]),
          orElse: () => null);

      if (key == null) return result;
      string = string.replaceFirst(descriptions[key], '');
      result.add(key);
    }
  }
}
