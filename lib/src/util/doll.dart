part of util;

class Doll extends OnlineObject {
  static const int _healLimit = 20;

  static Map<int, String> _debuffs = {
    Ego.sickness: 'str-',
    Ego.blindness: 'dex-',
    Ego.confusion: 'int-',
    Ego.acid: 'def-',
    Ego.slow: 'spd-',
  };

  static String _missingImage = 'image/block/missing.png';
  Account? account;
  Stage? _stage, spawnStage;
  Sprite? _sprite;
  String? message, _ability;
  DollCustomization? _customization;
  int _poisonCycle = 0;

  int? _created,
      messageTime = 0,
      lastCombatTime = -25,
      lastPlayerCombatTime = -25,
      combatStartTime,
      _lastUpkeep = 0,
      _lastTeleport = -25,
      _lastStun = 0,
      _wanderingRange = 10,
      _petSpawningTime;

  BigInt _charmDamage = BigInt.zero, _poisonDamage = BigInt.zero;

  Map<Symbol, int> _delays = {};
  Point<int>? targetLocation, spawnLocation;

  Doll? _targetDoll, masterDoll;

  final Set<Effect> effects = Set();
  final Set<Doll> _inCombatWith = Set();

  bool spawning = false, stuck = false, summoned = false, _noReward = false;

  final Map<String, String> style = {},
      messageStyle = {},
      healthBarStyle = {},
      innerHealthBarStyle = {},
      hitBoxStyle = {};

  final List<String> pendingUsedItems = [];

  final Set<Splat> _splats = Set();

  PathFinder? _pathFinder;

  Doll(
      [String? infoName,
      String? id,
      bool temporary = false,
      int? adjustedDifficulty]) {
    _created = Clock.time;
    this.temporary = temporary;
    difficulty = adjustedDifficulty;

    internal
      ..['info'] = infoName
      ..['img'] = image
      ..['timg'] = tappedImage;

    if (info?.hidden == true) internal['hidden'] = true;
    if (info?.boss == true) internal['boss'] = true;
    if (info?.overheadText != null) internal['overhead'] = info!.overheadText;
    if (id != null) internal['id'] = id;

    internal['level'] = adjustedDifficulty != null
        ? dollLevel(adjustedDifficulty, boss)
        : info?.level ?? 1;

    internal['adj equip'] = ObservableMap();

    info?.equipped?.forEach((key, value) {
      var copy = value.copy;
      adjustedEquipment![key] = copy;
    });

    internal['boss level'] = level;
  }

  List<String?> get abilities {
    var result = <String?>[];
    if (account != null) return result;

    // Bosses on floors higher than 50 can cast supernova.

    if (boss && (difficulty ?? 0) > 50) result.add('supernova');

    // Bosses do not lose their normal attacks when gaining supernova.

    var infoAbilities = info?.abilities ?? <String>[];
    if (infoAbilities.isEmpty) result.add(null);
    return result..addAll(infoAbilities);
  }

  String? get ability => internal['ability'] ?? _ability;

  void set ability(String? ability) {
    account == null ? _ability = ability : internal['ability'] = ability;
  }

  int get accuracyItems => List<Item>.from(equipped?.values ?? [])
      .where((Item item) => item.egos.contains(Ego.accuracy))
      .length;

  Map<String, dynamic>? get adjustedEquipment => internal['adj equip'];

  /// Returns the age of this [Doll] in clock ticks.

  int get age => Clock.time - _created!;

  int get agility =>
      _buff('agi', _sheet?.agility ?? _adjustedLevel(info!.agility));

  bool get altar => !player && (infoName?.endsWith('altar') ?? false);

  bool get boss {
    if (player) return false;

    // Resources are the same level as their floor's boss.

    if (resource) return true;
    if (info == null) return internal['boss'] ?? false;
    return info!.boss;
  }

  int get bossLevel => internal['boss level'] ?? 0;

  /// Used client side to display buffs on enemies.

  List<String> get buffKeys => List<String>.from(internal['buff keys'] ?? []);

  void set buffKeys(List<String> list) => internal['buff keys'] = list;

  Map<String?, dynamic> get buffs =>
      account?.buffs ?? (internal['buffs'] ??= ObservableMap());

  bool get burned => buffs.containsKey('burned');

  void set burned(bool value) {
    if (value) {
      if (!resistances.containsKey(Ego.resistFire)) buffs['burned'] = Buff();
    } else
      buffs.remove('burned');
  }

  int? get canPassThis => dead || spawning ? Terrain.land : info!.canPassThis;

  int get crystalShields =>
      inSlot(#shield).where((item) => item.egos.contains(Ego.crystal)).length;

  Point<int> get currentLocation {
    var location = internal['loc'] ?? const [0, 0];
    return Point(location[0], location[1]);
  }

  void set currentLocation(Point<int> point) {
    stage == null
        ? internal['loc'] = [point.x, point.y]
        : stage!.moveDoll(this, point);
  }

  DollCustomization? get customization {
    if (['human', 'newbie shop', 'random shop'].contains(infoName)) {
      if (_customization == null)
        _customization =
            json.decode(randomHumanJson(id), reviver: mapWrapperDecoder);

      return _customization;
    }

    if (infoName == 'stacy') {
      if (_customization == null)
        _customization = json.decode(
            '{"_t":"DollCustomization","id":"30ee-173e3ea286b-92360956","_override":"DollCustomization","hair":{"_t":"CustomizationLayer","id":"30ef-173e3ea286b-84d3519d","_override":"CustomizationLayer","type":"1","h":69,"s":360,"l":360,"c":98},"gender":"female","base":{"_t":"CustomizationLayer","id":"30f0-173e3ea286b-882a9256","_override":"CustomizationLayer","type":"0","h":0,"s":100,"l":100,"c":100},"back":{"_t":"CustomizationLayer","id":"30f1-173e3ea286b-cb3becae","_override":"CustomizationLayer","type":"1","h":69,"s":360,"l":360,"c":98},"bottom":{"_t":"CustomizationLayer","id":"30f2-173e3ea286b-a4bd5841","_override":"CustomizationLayer","type":"0","h":200,"s":100,"l":0,"c":100},"eyes":{"_t":"CustomizationLayer","id":"30f3-173e3ea286b-1be09971","_override":"CustomizationLayer","type":"0","h":200,"s":100,"l":100,"c":100},"face":{"_t":"CustomizationLayer","id":"30f4-173e3ea286b-de109ddd","_override":"CustomizationLayer","type":"1","h":0,"s":100,"l":100,"c":100},"shoes":{"_t":"CustomizationLayer","id":"30f5-173e3ea286b-c8bd9815","_override":"CustomizationLayer","type":"2","h":132,"s":0,"l":360,"c":360},"top":{"_t":"CustomizationLayer","id":"30f6-173e3ea286b-c953ff2f","_override":"CustomizationLayer","type":"2","h":320,"s":143,"l":112,"c":100}}',
            reviver: mapWrapperDecoder);

      return _customization;
    }

    if (infoName == 'chad' || infoName == 'giga chad') {
      if (_customization == null)
        _customization = json.decode(
            '{"_t":"DollCustomization","id":"1a88-173da0fcf52-5476f491","_override":"DollCustomization","hair":{"_t":"CustomizationLayer","id":"1a89-173da0fcf53-bb244086","_override":"CustomizationLayer","type":"0","h":37,"s":68,"l":115,"c":100},"top":{"_t":"CustomizationLayer","id":"1a90-173da0fcf54-39ea616f","_override":"CustomizationLayer","type":"3","h":282,"s":78,"l":170,"c":122},"gender":"male","base":{"_t":"CustomizationLayer","id":"1a8a-173da0fcf53-db9f76ed","_override":"CustomizationLayer","type":"0","h":0,"s":100,"l":100,"c":100},"back":{"_t":"CustomizationLayer","id":"1a8b-173da0fcf53-46e906d2","_override":"CustomizationLayer","type":"0","h":37,"s":68,"l":115,"c":100},"bottom":{"_t":"CustomizationLayer","id":"1a8c-173da0fcf53-22e7c039","_override":"CustomizationLayer","type":"2","h":245,"s":10,"l":360,"c":282},"eyes":{"_t":"CustomizationLayer","id":"1a8d-173da0fcf53-1a305c00","_override":"CustomizationLayer","type":"0","h":119,"s":98,"l":100,"c":100},"face":{"_t":"CustomizationLayer","id":"1a8e-173da0fcf53-e1929718","_override":"CustomizationLayer","type":"0","h":0,"s":100,"l":100,"c":100},"shoes":{"_t":"CustomizationLayer","id":"1a8f-173da0fcf54-d04e083e","_override":"CustomizationLayer","type":"0","h":0,"s":100,"l":100,"c":100}}',
            reviver: mapWrapperDecoder);

      return _customization;
    }

    if (infoName == 'elyvilon') {
      if (_customization == null)
        _customization = json.decode(
            '{"_t":"DollCustomization","id":"14049-1719c7a87ed-858f36e5","_override":"DollCustomization","hair":{"_t":"CustomizationLayer","id":"1404c-1719c7a87ed-eb4d9d82","_override":"CustomizationLayer","type":"1","h":190,"s":0,"l":360,"c":300},"gender":"female","base":{"_t":"CustomizationLayer","id":"1404a-1719c7a87ed-9b637c0a","_override":"CustomizationLayer","type":"0","h":0,"s":76,"l":79,"c":190},"back":{"_t":"CustomizationLayer","id":"1404b-1719c7a87ed-a1d7a70e","_override":"CustomizationLayer","type":"1","h":190,"s":0,"l":360,"c":300},"bottom":{"_t":"CustomizationLayer","id":"1404d-1719c7a87ed-44def187","_override":"CustomizationLayer","type":"0","h":200,"s":0,"l":0,"c":100},"eyes":{"_t":"CustomizationLayer","id":"1404e-1719c7a87ed-ebecf515","_override":"CustomizationLayer","type":"0","h":200,"s":100,"l":100,"c":100},"face":{"_t":"CustomizationLayer","id":"1404f-1719c7a87ed-7d46a65d","_override":"CustomizationLayer","type":"1","h":0,"s":100,"l":100,"c":100},"shoes":{"_t":"CustomizationLayer","id":"14050-1719c7a87ed-e7000da6","_override":"CustomizationLayer","type":"0","h":0,"s":0,"l":100,"c":100},"top":{"_t":"CustomizationLayer","id":"14051-1719c7a87ed-2451bda","_override":"CustomizationLayer","type":"1","h":183,"s":0,"l":177,"c":100}}',
            reviver: mapWrapperDecoder);

      return _customization;
    }

    return internal['cust'];
  }

  void set customization(DollCustomization? value) {
    internal['cust'] = value;
  }

  bool get dead => health <= BigInt.zero && maxHealth! > BigInt.zero;

  int get defense =>
      equipped.values.fold(0, (result, item) => result + item.defense as int);

  int get dexterity =>
      _buff('dex', _sheet?.dexterity ?? _adjustedLevel(info!.dexterity));

  int? get difficulty => internal['difficulty'] ?? info?.difficulty;

  void set difficulty(int? difficulty) {
    internal['difficulty'] = difficulty;
  }

  String? get displayName {
    if (overheadText != null) return overheadText;
    if (playerPet) return '';

    var result = internal['display'] != null
        ? internal['display']
        : image == _missingImage || boss
            ? infoName
            : '';

    if (boss) return result + ' (level ${formatNumber(bossLevel)})';

    if (result != null && result != '')
      result += ' (level ${formatNumber(level)})';

    if (playerKiller) result = '☠️ ' + result;
    return result;
  }

  bool get dropsSecretRare => boss && (difficulty ?? 0) > 50;

  Map<int, int> get equipmentEgos =>
      equipped.values.expand((item) => item.egos).fold({}, (result, ego) {
        increase(result, ego);
        return result;
      });

  Map<String?, dynamic> get equipped =>
      account?.equipped ?? adjustedEquipment ?? info!.equipped;

  int get evasion => calculateEvasion(this);

  BigInt get experience => BigIntUtil.max(BigInt.one, maxHealth! ~/ big(10)!);

  bool get expired {
    if (account != null ||
        playerPet ||
        !boss ||
        !inCombat ||
        dead ||
        combatStartTime == null) return false;

    // 5 minutes.

    return Clock.time - combatStartTime! > 1500;
  }

  int get foodEaten => internal['eat'] ?? 0;

  void set foodEaten(int value) => internal['eat'] = value;

  bool get frozen => buffs.containsKey('frozen');

  void set frozen(bool value) {
    if (value) {
      if (!resistances.containsKey(Ego.resistIce))
        // 5 seconds.

        buffs['frozen'] = Buff(duration: 25);
    } else
      buffs.remove('frozen');
  }

  bool get full => foodEaten >= _healLimit;

  /// Returns true if this doll can be interacted with.

  bool get hasInteraction => info?.interaction != null;

  bool get healer {
    var list = List.from(weapons);

    return !list.isEmpty &&
        list.every((weapon) => weapon.egos.contains(Ego.healing));
  }

  BigInt get health => maxHealth! - totalDamageTaken!;

  void set health(BigInt value) {
    var damage = BigIntUtil.max(BigInt.zero, maxHealth! - value);
    internal['dmg'] = '$damage';
  }

  Item? get helmet {
    var helmets = inSlot(#helmet);
    if (helmets.isNotEmpty) return helmets.first;
    return null;
  }

  bool get hidden {
    if (Config.hidePlayers && player) return true;
    return info?.hidden ?? internal['hidden'] ?? false;
  }

  /// Used client side to hide old overhead messages.

  bool get hideMessage => now - messageTime! > 5000;

  String get image => info?.image ?? internal['img'] ?? _missingImage;

  /// Combat lasts 25 ticks (including the tick it started). This is about 5
  /// seconds.

  bool get inCombat {
    if (account != null && inCombatWith.any((doll) => doll.inCombat))
      return true;

    return Clock.time < lastCombatTime! + 25;
  }

  Set<Doll> get inCombatWith =>
      _inCombatWith..retainWhere((doll) => doll.inCombat);

  DollInfo? get info =>
      account?.info ?? _dollInfo[internal['info']] ?? _dollInfo['missing'];

  String? get infoName => internal['info'];

  int get intelligence =>
      _buff('int', _sheet?.intelligence ?? _adjustedLevel(info!.intelligence));

  /// Returns true if the doll has a target that can be interacted with.

  bool get interacting => targetDoll?.info?.interaction != null;

  bool get isStairsDown => infoName == 'down stairs';

  bool get isStairsUp => infoName == 'up stairs';

  int get level => internal['level'] ?? 1;

  void set level(int level) {
    internal['level'] = max(level, 1);
  }

  bool get masterIsVisible => search(40, 40).contains(masterDoll);

  int get maxEnergy => internal['mmp'] ?? 0;

  BigInt? get maxHealth {
    // The internal value is needed client side.

    if (vitality == 0) return big(internal['mhp'] ?? 0);

    // This code should only be needed server side.

    BigInt multiplier = BigInt.one;

    if (equipped.values.any((item) => item.egos.contains(Ego.health)))
      multiplier = BigInt.two;

    return _vitalityToHealth(vitality) * multiplier;
  }

  bool get missingInfo => info == _dollInfo['missing'];

  int get modifiedSummoningLevel => account?.sheet?.summoning?.level ?? 1;

  /// Equipped non-weapon items.

  Iterable<dynamic> get nonWeaponEquipment => equipped.values.where(
      (item) => item?.info?.slot != #weapon && item?.info?.slot != #thrown);

  int get nonWeaponEquipmentDamage =>
      nonWeaponEquipment.fold(0, (total, item) => total + item.damage as int);

  String? get overheadText => internal['overhead'];

  int get petRequirement => boss ? level * 2 : level;

  bool get player => internal['player'] ?? false;

  bool get playerKiller => internal['pker'] ?? false;

  bool get playerPet => internal['pet'] ?? false;

  Iterable<Account?> get playersInRange =>
      search(ServerGlobals.sight, ServerGlobals.sight)
          .where((doll) => doll!.account != null)
          .map<Account?>((doll) => doll!.account);

  bool get poisoned => buffs.containsKey('poisoned');

  void set poisoned(bool value) {
    if (value) {
      if (poisoned || resistances.containsKey(Ego.resistPoison)) return;
      if (!regenerating) _poisonCycle = 0;
      buffs['poisoned'] = Buff();
    } else
      buffs.remove('poisoned');
  }

  int get powerItems => List<Item>.from(equipped?.values ?? [])
      .where((Item item) => item.egos.contains(Ego.power))
      .length;

  int get primaryAttackRange => primaryWeapon?.attackRange ?? info!.attackRange;

  Item? get primaryWeapon {
    var iterable = weapons;
    if (iterable.isEmpty) return null;
    return iterable.first;
  }

  BigInt get regenAmount =>
      BigIntUtil.max(BigInt.one, _vitalityToHealth(_vitality) ~/ big(20)!);

  bool get regenerating =>
      buffs.containsKey('regen') || equipmentEgos.containsKey(Ego.regen);

  Map<int, int> get resistances =>
      buffs.values.fold(equipmentEgos, (result, buff) {
        buff.egos.forEach((ego) => increase(result, ego));
        return result;
      });

  bool get resource => info?.resource ?? false;

  String? get sanitizedName =>
      account?.id == null ? infoName : sanitizeName(account!.id!);

  int get secondaryAttackRange =>
      secondaryWeapon?.attackRange ?? info!.attackRange;

  Item? get secondaryWeapon {
    var iterable = weapons;
    if (iterable.length < 2) return null;
    return iterable.skip(1).first;
  }

  bool get shop {
    if (player) return false;
    return infoName?.endsWith('shop') == true;
  }

  Iterable<Splat> get splats =>
      _splats.length > 10 ? (_splats..remove(_splats.first)) : _splats;

  Sprite get sprite => _sprite ??= Sprite(this);

  Stage<Doll?>? get stage => _stage;

  int get stealth {
    if (account == null) return 0;
    num result = account!.sheet.crime!.level;
    result += result * stealthItems / 4;
    if (account?.god == 'dithmenos') result *= 2;
    result += result * thievingBonus / 100;
    return result.floor();
  }

  int get stealthItems {
    var result = 0;

    // Only players can be stealthy.

    if (account == null) return result;
    result += resistances[Ego.stealth] ?? 0;
    return result;
  }

  int get strength =>
      _buff('str', _sheet?.strength ?? _adjustedLevel(info!.strength));

  String? get tappedImage => info?.tappedImage ?? internal['timg'];

  Doll? get targetDoll => _targetDoll;

  void set targetDoll(Doll? doll) {
    _targetDoll = doll;
    if (account != null) account!.internal['target'] = doll?.id;
  }

  bool get temporary => internal['temporary'] ?? false;

  void set temporary(bool value) => internal['temporary'] = value;

  int get thievingBonus =>

      // Having multiple +25% stealth items makes up for not having something
      // like a mining helmet for stealth.

      equipped?.values.where((item) => item.egos.contains(Ego.thieving)).fold(
          0,
          ((result, item) => result + item.bonus as int?) as int? Function(
              int?, dynamic)) ??
      0;

  int? get thisCanPass {
    var result = info!.thisCanPass;
    if (summoned) return max(result!, Terrain.doll);
    return result;
  }

  BigInt? get totalDamageTaken => big(internal['dmg'] ?? 0);

  int get vitality => _vitality;

  int? get walkingCoolDown {
    var value = info?.walkingCoolDown ?? internal['speed'], result = value;
    if (result == null) return null;

    // The signs are deliberately inverted.

    if (buffs.containsKey('spd+')) result -= value ~/ 2;
    if (buffs.values.any((buff) => buff.egos.contains(Ego.slow)))
      result += value ~/ 2;

    // Only players should have equipment that changes their speed.

    if (account != null) {
      if (equipped.values.any((item) => item.egos.contains(Ego.fast)))
        result -= value ~/ 2;

      if (equipped.values.any((item) => item.egos.contains(Ego.slow)))
        result += value ~/ 2;
    }

    // The result should be either 200, 400, or 600.

    return clamp(result, 200, 600) as int?;
  }

  Iterable<Item> get weapons => inSlot(#weapon);

  bool get _hasTarget =>
      targetLocation != null && targetLocation != currentLocation ||
      targetDoll != null;

  CharacterSheet? get _sheet => account?.sheet;

  int get _vitality =>
      _buff('vit', _sheet?.vitality ?? _adjustedLevel(info?.vitality ?? 0));

  void act() {
    if (expired) {
      splat('time limit', 'effect-text');
      killWithNoReward();
    }

    if (account != null) {
      // A player's temporary invisibility is lost when they target something.

      if (_hasTarget) _lastTeleport = -25;

      // Keeps track of bonus experience and drops for being offline.

      account!
        ..updateLastSeen()
        ..timeBonus = max(
            0,
            account!.timeBonus -
                ServerGlobals.tickDelay * ServerGlobals.timeBonusMultiplier);

      // Automatically uses potions.

      if (!dead && account!.autoPotion) {
        var whitelist = [
          'agility potion',
          'strength potion',
          'dexterity potion',
          'intelligence potion',
          'regen potion',
          'fast potion'
        ];

        bool buffed(Item item) {
          if (item.infoName == 'agility potion')
            return buffs.containsKey('agi+');

          if (item.infoName == 'strength potion')
            return buffs.containsKey('str+');

          if (item.infoName == 'dexterity potion')
            return buffs.containsKey('dex+');

          if (item.infoName == 'intelligence potion')
            return buffs.containsKey('int+');

          if (item.infoName == 'regen potion')
            return buffs.containsKey('regen');

          if (item.infoName == 'fast potion') return buffs.containsKey('spd+');

          // Only potions on the whitelist should be automatically used.

          throw ArgumentError(item.infoName);
        }

        account!.actions.values
            .map((item) => account!.items.getItem(item))
            .where(
                (item) => whitelist.contains(item?.infoName) && !buffed(item!))
            .forEach((potion) => _useItem(potion));
      }
    }

    if (info?.interaction != null) return;

    if (masterDoll != null && summoned && !masterIsVisible)
      stage?.removeDoll(this);

    // Prevents monsters from getting stuck behind walls.

    if (stuck && targetDoll != null && !canFireAt(targetDoll!))
      targetDoll = null;

    if (summoned) {
      targetLocation = null;

      if (masterDoll?.stage != stage || masterDoll?.dead != false) {
        if (!summoned) masterDoll = null;
      } else if (_abilities[masterDoll!.ability]?.combat != false &&
          masterDoll?.interacting != true &&
          masterDoll?.healer != true) targetDoll ??= masterDoll?.targetDoll;
    }

    // Prevents pets from killing resources.

    if (summoned && targetDoll?.info?.interaction != null) {
      targetDoll = null;
      targetLocation = null;
    }

    // Pets shouldn't attack their owners.

    if (summoned && targetDoll == masterDoll) {
      targetDoll = null;
      targetLocation = null;
    }

    // Pets shouldn't attack players but should be able to heal them.

    if (summoned && !healer && targetDoll?.account != null) {
      targetDoll = null;
      targetLocation = null;
    }

    // Handles death and cool down. Cool downs happen even while dead.

    coolDown(ServerGlobals.tickDelay);
    if (dead) return;

    if (account?.petSpawned == true &&
        account!.pet?.dead == true &&
        _petSpawningTime == null) {
      _petSpawningTime = now + 30000;
    }

    if (account?.petSpawned == true &&
        _petSpawningTime != null &&
        now >= _petSpawningTime!) {
      _petSpawningTime = null;
      account!.pet?.spawning = false;
      account!.pet?.health = account!.pet!.maxHealth!;
      account!.doll?.summon();
    }

    // Prevents a monster from targeting itself.

    if (this == targetDoll) {
      targetDoll = null;
      targetLocation = null;
    }

    // Prevents monsters from searching the entire floor for a player.

    if (targetDoll != null &&
        chessDistanceTo(targetDoll!.currentLocation) >
            ServerGlobals.sight * 2) {
      targetDoll = null;
      targetLocation = null;
    }

    if (account == null && targetDoll != null && !_visible(targetDoll)) {
      targetDoll = null;
      targetLocation = null;
    }

    void getOffMaster() {
      if (masterDoll!.currentLocation != currentLocation) return;
      walk(randomValue(List.from(adjacent(currentLocation))));
    }

    if (_abilities[ability]?.combat != false) if (summoned) {
      if (targetDoll == null && masterDoll != null)
        chessDistanceTo(masterDoll!.currentLocation) > 1
            ? walk(masterDoll!.currentLocation)
            : getOffMaster();
    } else
      walk();

    if (targetDoll?.stage != stage || targetDoll?.dead != false)
      targetDoll = null;

    // Handles AI.

    if (account == null) {
      _aggro();
      if (!summoned) _idle();
    }

    if (account != null) usePendingItems();

    if (ability == 'trade' &&
        targetDoll != null &&
        targetDoll!.account == null) {
      targetDoll = null;
      targetLocation = null;
      return;
    }

    if (account != null &&
        interacting &&
        (ability == null || !targetDoll!.resource)) {
      walk();

      if (chessDistanceTo(targetDoll!.currentLocation) > 1) return;
      targetLocation = null;

      if (!account!.doll!.warm(#walk)) {
        targetDoll!.info!.interaction!(account, targetDoll);

        // [targetDoll] is reset while using portals.

        if (targetDoll?.info?.repeatInteraction != true) {
          targetDoll = null;
        }
      }

      return;
    }

    String? randomAbility() {
      var distanceToTarget = chessDistanceTo(targetDoll!.currentLocation);

      var result = List<String>.from(abilities.where((String? ability) {
        if (ability == null) return distanceToTarget <= attackRange();
        var range = _abilities[ability]?.range ?? 0;
        return distanceToTarget <= range;
      }));

      return result.isEmpty ? null : randomValue(result);
    }

    if (account == null && targetDoll != null) ability = randomAbility();

    if (targetDoll != null) {
      var approach = _abilities[ability]?.combat ?? true;

      if (approach && attackRange() > 1 && !canFireAt(targetDoll!)) {
        prepareAttack(targetDoll, 1);
        return;
      }

      var pickpocketing = ability == 'pickpocket' && canPickpocket(targetDoll);

      if (pickpocketing && chessDistanceTo(targetDoll!.currentLocation) > 1)
        walk(targetDoll!.currentLocation);
      else
        prepareAttack(targetDoll, attackRange(false));
    }

    if (account != null) throwItem();

    // Sometimes, after a monster moves closer to its target, it can use an
    // ability that it couldn't use before. This handles that case.

    if (account == null && targetDoll != null && ability == null)
      ability = randomAbility();

    useAbility(ability);
    if (ability != null && _abilities[ability]?.combat == true) ability = null;

    // Gathering nodes should never be attacked.

    if (targetDoll?.info?.interaction != null) return;

    if (targetDoll != null && _abilities[ability]?.combat != false) {
      var weaponList = List.from(weapons);

      // Unarmed attack.

      if (weaponList.isEmpty) {
        if (warm(#left)) return;

        if (chessDistanceTo(targetDoll!.currentLocation) > primaryAttackRange)
          return;

        targetDoll!.effects.add(Effect(this,
            damage: calculateDamage(this), accuracy: calculateAccuracy(this)));

        warmUp(#left, calculateCoolDown(this));
      } else
        // Armed attack.

        for (var hands = const [#left, #right],
                range = [primaryAttackRange, secondaryAttackRange],
                i = 0;
            i < weaponList.length;
            i++) {
          if (warm(hands[i])) continue;

          if (chessDistanceTo(targetDoll!.currentLocation) > range[i]) {
            continue;
          }

          List<int> egos = weaponList[i].egos;

          effect([Doll? doll, bool aoe = false]) {
            if (doll?.info?.interaction != null) return;
            var missile = weaponList[i].missile ?? weaponList[i].info.missile;

            (doll ?? targetDoll)!.effects.add(Effect(this,
                delay: missile != null
                    ? aoe
                        ? fireAoe(doll, missile)
                        : fireMissile(missile)
                    : 0,
                damage: calculateDamage(this, weaponList[i]),
                accuracy: calculateAccuracy(this, weaponList[i]),
                egos: egos));
          }

          for (var i = 0,
                  j = egos.contains(Ego.burst) ||
                          nonWeaponEquipment
                              .any((item) => item.egos.contains(Ego.burst))
                      ? 3
                      : 1;
              i < j;
              i++)
            if (egos.contains(Ego.all))
              search(10, 10)
                  .where(
                      (doll) => canAreaEffect(doll, egos.contains(Ego.healing)))
                  .forEach((doll) => effect(doll, true));
            else
              effect();

          warmUp(hands[i], calculateCoolDown(this, weaponList[i]));
        }
    }
  }

  /// Alerts this [Doll]'s user if one exists.

  void alert(String? message, [String? classes]) =>
      account?.alert(message, classes);

  /// Reduces [damage].

  BigInt applyDefense(BigInt damage, [List<int>? egos]) {
    if (damage <= BigInt.zero) return BigInt.zero;
    egos ??= const [];

    // Healing and charming ignores defense.

    if (egos.contains(Ego.healing) || egos.contains(Ego.charm)) return damage;
    var resists = resistances;

    var bonus = nonWeaponEquipment
        .where((item) => !item.upgradesIncreaseEvasion)
        .fold(defense, (dynamic result, item) => result + item.bonus / 10);

    // Acid attacks ignore defense, including from shields and spirit items.

    var shields = List.from(
            equipped.values.where((item) => item.egos.contains(Ego.shield))),
        spirits = List.from(
            equipped.values.where((item) => item.egos.contains(Ego.spirit)));

    if (egos.contains(Ego.acid) && !resists.containsKey(Ego.resistAcid)) {
      shields.clear();
      spirits.clear();
      bonus = 0;
    } else {
      // Acid also ignores magic resistance and ballistic resistance.

      if (egos.contains(Ego.ballistic) &&
          resists.containsKey(Ego.resistBallistic))
        damage ~/= BigInt.one << resists[Ego.resistBallistic]!;

      if (egos.contains(Ego.magic) && resists.containsKey(Ego.resistMagic))
        damage ~/= BigInt.one << resists[Ego.resistMagic]!;
    }

    if (!shields.isEmpty)
      damage = BigIntUtil.multiplyByDouble(damage, pow(.5, shields.length));

    if (!spirits.isEmpty)
      damage = BigIntUtil.multiplyByDouble(damage, pow(.75, spirits.length));

    // Weapon bonuses increase damage and armor bonuses decrease damage.

    num adjustedDamageReductionPercent = damageReductionPercent(bonus);

    if (bonus > 0)
      damage = BigIntUtil.multiplyByDouble(
              damage, 100 - adjustedDamageReductionPercent) ~/
          big(100)!;

    return BigIntUtil.max(BigInt.zero, damage);
  }

  void applyEffects() {
    var list = List<Effect>.from(effects.where((effect) => effect.delay <= 0))
      ..forEach((effect) {
        // This check is needed because effects are cleared on death (including
        // revival with a life amulet).

        if (effects.contains(effect)) _applyEffect(effect);
      });

    (effects..removeAll(list))
        .forEach((effect) => effect.delay -= ServerGlobals.tickDelay);
  }

  int attackRange([bool withAbility = true]) {
    if (inSlot(#thrown).isNotEmpty) return 5;

    if (withAbility && ability != null && _abilities[ability] != null)
      return _abilities[ability]!.range;

    if (weapons.isEmpty) return info!.attackRange;
    return weapons.fold(1, (result, weapon) => max(result, weapon.attackRange));
  }

  bool canAreaEffect(Doll? doll, [bool healing = false]) {
    if (player && healing) {
      // Player AOE healing is special cased to heal all players and pets, even
      // if an enemy is being targeted.

      if (doll!.player || doll.playerPet) return true;
      return false;
    }

    if (doll!.dead) return false;
    if (doll.id == id || doll.hasInteraction) return false;
    if (!canFireAt(doll)) return false;
    if (!canTarget(doll)) return false;
    if (doll.id == targetDoll?.id) return true;

    // Non-pet monsters can't hit other non-pet monsters with AOE.

    if (!player && !playerPet && (!doll.player && !doll.playerPet))
      return false;

    // Players/pets can't hit other players/pets they aren't targeting with AOE.

    if ((player || playerPet) && (doll.player || doll.playerPet)) return false;
    return true;
  }

  bool canFireAt(Doll target) => ray(currentLocation, target.currentLocation)
      .every((point) => traversable(point, Terrain.obstacles));

  bool canPickpocket(Doll? doll, [bool showAlert = false]) {
    if (doll == null ||
        doll.info?.interaction != null ||
        doll.summoned ||
        doll.account != null) return false;

    return true;
  }

  bool canTarget(Doll? doll) {
    // Pets can't target players.

    if (playerPet && doll!.player) return false;
    return true;
  }

  bool canWalk() => info?.moves != false && !dead && !frozen;

  /// Returns the distance to [point] as if moving like a king in chess.

  int chessDistanceTo(Point<int> point) {
    var location = currentLocation;
    return max((point.x - location.x).abs(), (point.y - location.y).abs());
  }

  Doll closest(Iterable<Doll> dolls) => (List.from(dolls)
        ..shuffle()
        ..sort((first, second) => first
            .chessDistanceTo(currentLocation)
            .compareTo(second.chessDistanceTo(currentLocation))))
      .first;

  void coolDown([int amount = 1]) => List.from(_delays.keys).forEach((symbol) {
        if ((_delays[symbol] = _delays[symbol]! - amount) <= 0)
          _delays.remove(symbol);
      });

  void enterCombat(Doll target) {
    // [inCombatWith] is only used for players fighting non-players.

    if (target != null && account != null && target.account == null)
      inCombatWith.add(target);

    if (!inCombat) combatStartTime = Clock.time;
    lastCombatTime = Clock.time;
  }

  void equip(Item? item) {
    if (item?.info?.slot == null) return;

    if (item!.info!.slot == #weapon || item.info!.slot == #shield) {
      if (item.twoHanded) {
        if (account!.equipped.remove(item.id) == null) {
          _disarm();
          account!.equipped[item.id] = item;
        }
      } else if (account!.equipped.remove(item.id) == null) {
        for (var list = List.from(inSlot(#shield))..addAll(weapons), i = 0;
            i < list.length;
            i++) if (i > 0 || list[i].twoHanded) equipped.remove(list[i].id);

        var other = account!.equipped['double equipped'];

        if (other != null && other.id != item.id)
          account!.equipped[other.id] =
              account!.equipped.remove('double equipped');

        account!.equipped[item.id] = item;
      } else if (item.amount >=
          2) if (account!.equipped['double equipped']?.id == item.id)
        account!.equipped.remove('double equipped');
      else {
        _disarm();

        account!.equipped
          ..[item.id] = item
          ..['double equipped'] = item;
      }
    } else if (account!.equipped.remove(item.id) == null) {
      var slot = inSlot(item.info!.slot);
      if (slot.isNotEmpty) equipped.remove(slot.first.id);
      account!.equipped[item.id] = item;
    }
  }

  int fireAoe(Doll? target, String image) {
    if (image == null) return 0;

    internal.addEvent(ObservableEvent(
        type: 'aoe',
        data: {'image': image, 'source': id, 'target': target!.id}));

    return 100;
  }

  int fireMissile(String? image) {
    if (image == null) return 0;

    internal.addEvent(ObservableEvent(
        type: 'missile',
        data: {'image': image, 'source': id, 'target': targetDoll!.id}));

    return (currentLocation.distanceTo(targetDoll!.currentLocation) * 100)
        .floor();
  }

  bool getDebuff(int ego) => buffs.keys.contains(_debuffs[ego]);

  /// Returns 0 for normal resources, 1 for good resources, and 2 for great
  /// resources.

  int goodResource(Account player) {
    if (info?.resource != true || const ['chest', 'dummy'].contains(infoName))
      return 0;

    var hash = digest('$id-$daysSinceEpoch').hashCode;
    if (hash % 10 == 0) return 1;
    if (hash % 10 == 1) return 2;
    if (hash % 10 == 2) return 3;
    return 0;
  }

  /// Moves like a king in chess.

  bool gridApproach(Point<int> target) {
    var point = _gridApproach(currentLocation, target);

    if (currentLocation != point) {
      currentLocation = point as Point<int>;
      return true;
    } else
      return false;
  }

  bool heal(dynamic amount, [bool limit = false]) {
    amount = big(amount);
    assert(amount >= BigInt.zero);

    if (limit && inCombat) {
      if (full) return false;
      foodEaten++;
    }

    // A doll can't heal while dead or burned.

    if (health <= BigInt.zero) return true;

    if (burned) {
      splat('0', 'heal-text');
      return true;
    }

    amount = BigIntUtil.max(BigInt.one, amount);
    health += amount;
    splat('$amount', 'heal-text');
    return true;
  }

  void hurt(Doll damageSource, dynamic amount,
      [String? message, String? classes]) {
    if (info?.interaction != null || health <= BigInt.zero) return;
    amount = big(amount);
    if (account?.god == 'elyvilon') amount ~/= BigInt.two;
    amount = BigIntUtil.max(BigInt.one, amount);
    health -= amount;

    splat(message != null ? '$amount ($message)' : '$amount',
        classes ?? 'damage-text');

    // Extra lives. Players should never have more than one extra life because
    // extra lives are too strong.

    if (health <= BigInt.zero &&
        equipmentEgos.containsKey(Ego.life) &&
        buffs['extra life'] == null) {
      splat('extra life', 'effect-text');
      health = maxHealth!;

      // Prevents losing multiple lives to a single burst attack.

      effects.clear();

      // Being revived acts like leaving combat.

      if (buffs.isNotEmpty) buffs.clear();
      buffs['extra life'] = Buff();
      foodEaten = 0;
      _poisonDamage = BigInt.zero;
      _charmDamage = BigInt.zero;
      _poisonCycle = 0;
    }

    // Auto heal.

    while (account != null &&
        account!.autoHeal > 0 &&
        health > BigInt.zero &&
        health < maxHealth! &&
        health < big(account!.autoHeal)! &&
        foodEaten < _healLimit &&
        !burned) {
      // Automatically uses the food that heals the least.

      var items = List.from(account!.actions.values
          .map((item) => account!.items.getItem(item))
          .where((item) => item?.egos?.contains(Ego.food) == true))
        ..sort((dynamic first, dynamic second) =>
            first.healingAmount.compareTo(second.healingAmount));

      if (items.isEmpty || !_useItem(items.first)) break;
    }

    if (health <= BigInt.zero) account?.noteLethalDamage(damageSource, amount);
  }

  void informationPrompt(String message) => account?.informationPrompt(message);

  Iterable<Item> inSlot(Symbol? symbol) => List<Item>.from(
      equipped.values.where((item) => item.info?.slot == symbol));

  void jump(Stage<Doll?>? newStage,
      [Point<int>? newLocation, bool showSplat = false, heal = false]) {
    // Enemies do not continue to target players or pets after they jump.

    if (account != null || playerPet)
      stage?.dolls?.values.forEach((doll) {
        if (doll!.targetDoll?.id == id) doll.targetDoll = null;
      });

    if (newLocation == null)
      newLocation =
          newStage?.randomTraversableLocation(this) ?? const Point(0, 0);
    else
      newLocation = _handleStairs(newStage, newLocation);

    var pet = account?.pet?.masterIsVisible == true;
    targetDoll = null;
    targetLocation = null;
    stage?.removeDoll(this);
    newStage?.addDoll(this, newLocation);
    _stage = newStage;
    internal.addEvent(ObservableEvent(type: 'jump'));
    if (showSplat) splat('jump', 'effect-text');

    // Causes the client side view to update correctly.

    account?.sessions?.forEach((session) => session.internal.remove('view'));

    // Handles pets.

    if (pet) account!.pet!.jump(newStage, newLocation);

    // Leaves combat, which heals.

    if (heal) {
      leaveCombat();
      updateLastTeleportTime();
    } else {
      // Even if a teleport doesn't heal a player, it begins the process of
      // leaving combat.

      inCombatWith.clear();
    }
  }

  void killWithNoReward() {
    _noReward = true;
    health = BigInt.zero;

    informationPrompt('You have been killed by a death attack. ' +
        'Equip a wooden charm to resist death attacks.');
  }

  void leaveCombat() {
    combatStartTime = null;
    lastCombatTime = -25;
    inCombatWith.clear();
  }

  void pickpocket(Doll target) {
    if (target == null) return;

    // The same formulas are used for gathering and pickpocketing.
    // 1 item is worth 10 wei.

    var amount = stealth ~/ 20,
        bigAmount = big(max(1, amount.floor()))! +
            extraResources(target.level, amount.floor());

    bigAmount *= big(10)!;

    // This is correct. The experience is later multiplied by the time bonus in
    // the [gainExperience] method.

    var experience = bigAmount;

    // A player gets extra experience and loot for being offline.

    bigAmount = bigAmount * big(account!.timeBonusMultiplier)!;

    account!
      ..gainExperience(
          account!.hasCrystalGloves ? experience * BigInt.two : experience,
          'crime')
      ..money = account!.money! + bigAmount
      ..alert('You gain: ${formatCurrency(bigAmount)}.');
  }

  /// Approaches [target] if needed, then returns true if in [range].
  /// Non-players always approach melee range.

  bool prepareAttack(Doll? target, int range) {
    if (target == null) return false;
    if (account != null && ability != null) return true;
    if (account == null) range = 1;

    if (chessDistanceTo(target.currentLocation) > range)
      walk(target.currentLocation);

    return chessDistanceTo(target.currentLocation) <= range;
  }

  void randomJump(Stage<Doll?> stage) => account!.doll!
      .jump(stage, stage.randomTraversableLocation(this) ?? const Point(0, 0));

  void regenerate(int duration) {
    if (!regenerating && !poisoned) _poisonCycle = 0;
    buffs['regen'] = Buff(duration: duration);
  }

  void revivePet() {
    _petSpawningTime = now;
  }

  void reward(Account looter, [int count = 1]) {
    // The same formula is used for gathering.

    num looterSlayingLevel = looter.sheet.slaying!.level,
        luckyItems = looter.doll?.equipmentEgos[Ego.lucky] ?? 0;

    looterSlayingLevel += looterSlayingLevel * luckyItems / 4;
    if (looter.god == 'gozag') looterSlayingLevel += looterSlayingLevel / 4;
    looterSlayingLevel = looterSlayingLevel.floor();

    num amount = looterSlayingLevel / 20;

    // An implied tool is used.

    amount += amount * level / 100;
    amount = amount.floor();
    var multiplier =
        big(max(1, amount))! + extraResources(level, amount as int);

    // A player gets extra experience and loot for being offline.

    count *= looter.timeBonusMultiplier;
    var drops = List.from(info!.loot?.drops ?? []);

    // Secret rares.

    if (dropsSecretRare && random(100) == 0) drops.add(Item('puzzle box'));

    drops.forEach((item) {
      Item copy = item.copy;

      // To prevent inventory clutter, randomness is not used.

      copy.canUpgrade && !copy.food && !copy.potion
          ? copy.bonus =
              calculateDropBonus(looterSlayingLevel as int, multiplier)
          : copy.setAmount(copy.getAmount()! * multiplier);

      copy.setAmount(copy.getAmount()! * big(count)!);
      looter.lootItem(copy);
    });
  }

  /// If searching for players, use [userSearch] instead.

  Iterable<Doll?> search(num width, num height) {
    assert(width >= 0 && height >= 0);
    if (stage == null) return [this];
    return stage!.search(rectangleFromCenter(currentLocation, width, height));
  }

  void setDebuff(int ego, bool value) {
    if (value) {
      if (getDebuff(ego) || resistances.containsKey(ego)) return;
      buffs[_debuffs[ego]] = Buff();
    } else
      buffs.remove(_debuffs[ego]);
  }

  /// Used server side to show effects over this [Doll] client side.

  void splat(String text, [String? classes]) =>
      internal.addEvent(ObservableEvent(
          type: 'splat', data: {'value': text, 'classes': classes}));

  void summon() {
    if (stage == null) return;
    account!.petSpawned = true;
    account!.pet ??= Doll('puppy');
    account!.pet!.internal['pet'] = true;

    account!.pet!
      ..masterDoll = this
      ..summoned = true
      ..jump(stage, currentLocation, false, false);

    var spawningTime = _petSpawningTime ?? 0;

    if (now < spawningTime) {
      var delay = (spawningTime - now) ~/ 1000;
      alert('Your pet will appear in $delay seconds.');
    }
  }

  bool tamableBy(Doll master) =>
      account == null && summoned == false && infoName != null;

  void throwItem() {
    var thrown = inSlot(#thrown);
    if (thrown.isEmpty || ability != null) return;
    var item = thrown.first;
    if (item == null || item.amount < 1) return;
    if (item.info!.use!(this, item)) account!.items.removeItem(item.id);
  }

  bool traversable(Point<int> point, [int? overrideThisCanPass]) =>
      point == currentLocation || _traversable(point, overrideThisCanPass);

  void updateLastTeleportTime() {
    if (account != null) _lastTeleport = Clock.time;
  }

  void upkeep() {
    _lastUpkeep = now;

    // Preserves procedurally generated floors.

    if (account != null) stage?.keepAlive = now;

    if (account == null &&
        spawnStage != null &&
        spawnLocation != null &&
        currentLocation != spawnLocation)
      Future.delayed(const Duration(minutes: 1), () {
        // Resets doll locations for dolls that have been inactive for too long.

        if (!summoned && !temporary && now - _lastUpkeep! >= 30000) {
          if (Config.debug && boss) Logger.root.info('resetting $infoName');
          _lastUpkeep = now;
          jump(spawnStage, spawnLocation);
        }
      });

    internal
      ..['speed'] = walkingCoolDown
      ..['mhp'] = '$maxHealth';

    _handleDeath();
    account?.sessions?.forEach((session) => session.updateClient());

    if (account != null) {
      account!.updateCanPvP();
      account!.preventLogout(inCombat);
    }

    if (!dead && !inCombat) {
      // [Doll]s are healed after combat.

      foodEaten = 0;
      _poisonDamage = BigInt.zero;
      _charmDamage = BigInt.zero;
      _poisonCycle = 0;

      removeAllBut(buffs, const [
        'agi+',
        'str+',
        'dex+',
        'int+',
        'spd+',
        'regen',
        'resist fire',
        'resist ice',
        'resist electric',
        'resist gravity',
        'resist acid',
        'resist poison',
        'pker'
      ]);

      health = maxHealth!;
    }

    Map.from(buffs).forEach((key, value) {
      if (value.expired) {
        buffs.remove(key);
        return;
      }

      value.tick(1);
    });

    if (_poisonCycle++! % 25 == 0) {
      // Regeneration is done before poison to make killing bosses with only
      // gravity and poison harder.

      if (regenerating && health < maxHealth!) {
        var count = equipmentEgos[Ego.regen] ?? 0;
        if (buffs.containsKey('regen')) count++;
        heal(regenAmount * big(count)!);
      }

      // Handles poison. Poison hits every 25 ticks (5 seconds).

      if (poisoned) {
        var amount = BigIntUtil.max(BigInt.one, _poisonDamage ~/ big(4)!);
        hurt(this, amount, 'poison', 'poison-text');
      }
    }
  }

  bool useAbility(String? ability) {
    if (ability == null || _abilities[ability] == null || warm(#left))
      return false;

    targetLocation = null;

    if (targetDoll != null &&

        // Only combat abilities need a range.

        _abilities[ability]!.combat &&
        chessDistanceTo(targetDoll!.currentLocation) >
            _abilities[ability]!.range) return false;

    // Abilities always use the primary hand. The secondary hand is only used
    // for dual wielding.

    if (_abilities[ability]!.use!(this)) {
      warmUp(#left, calculateCoolDown(this));
      return true;
    }

    return false;
  }

  void usePendingItems() {
    if (pendingUsedItems.isNotEmpty)
      _useItem(account!.items.getItem(pendingUsedItems.removeAt(0)));
  }

  Iterable<Doll?> userSearch(num width, num height) {
    assert(width >= 0 && height >= 0);
    if (stage == null) return [this];

    return stage!
        .userSearch(rectangleFromCenter(currentLocation, width, height));
  }

  void walk([Point<int>? location]) {
    if (info!.interaction != null || !info!.moves) return;

    if (interacting && chessDistanceTo(targetDoll!.currentLocation) > 1)
      targetLocation = targetDoll!.currentLocation;

    var result;

    if (canWalk() &&
        (location ??= targetLocation) != null &&
        !warm(#walk) &&
        (result = _path(location ?? targetLocation!)))
      warmUp(#walk, walkingCoolDown!);

    // A [Doll] is stuck if it fails to move.

    stuck = _hasTarget && result == false;
  }

  /// Used with [warmUp] and [coolDown].

  bool warm(Symbol symbol) => _delays.containsKey(symbol);

  void warmUp(Symbol symbol, int amount) {
    var value = (_delays[symbol] ?? 0) + amount;
    value <= 0 ? _delays.remove(symbol) : _delays[symbol] = value;
  }

  int _adjustedLevel(int level) {
    if (info == null || difficulty == null) return level ?? 1;
    return info!.adjustedAttribute(difficulty!);
  }

  void _aggro() {
    if (!summoned && info?.aggro == false) return;

    if (summoned && !(masterDoll?.account?.options['pet aggro'] ?? false))
      return;

    if (targetDoll != null) if (!_visible(targetDoll)) {
      targetDoll = null;
      targetLocation = null;
    } else
      return;

    var length = ServerGlobals.sight * 2,
        function = summoned
            ? () => masterDoll!.search(length, length)
            : () => userSearch(length, length);

    // Monsters don't aggro pets for the same reason they don't aggro other
    // monsters. However, they do retaliate when attacked.

    List<Doll> targets = List.from(function().where((Doll? target) {
      // Pets shouldn't aggro players or other pets.

      if (summoned &&
          (target!.account != null ||
              target.info?.interaction != null ||
              target.summoned)) return false;

      // Monsters that don't move shouldn't target things they can't attack.

      var moves = info?.moves ?? false;

      if ((!moves || frozen) && chessDistanceTo(target!.currentLocation) > 5)
        return false;

      return !target!.dead && _visible(target) && canFireAt(target);
    }));

    if (targets.isNotEmpty) {
      targetLocation = null;
      targetDoll = closest(targets);
    }
  }

  void _applyEffect(Effect effect) {
    // Prevents missiles from the previous stage from working.

    if (effect.source?.stage != stage || Clock.time - _lastTeleport! < 25)
      return;

    if (effect.source?.canTarget(this) == false) {
      splat('no effect', 'effect-text');
      return;
    }

    var healing = effect.egos.contains(Ego.healing),
        charming = effect.egos.contains(Ego.charm);

    // Allows players to get drops.

    var sourceAccount =
        effect.source?.account ?? effect.source?.masterDoll?.account;

    if (sourceAccount != null && account != sourceAccount && !healing)
      lastPlayerCombatTime = Clock.time;

    // Hidden targets are generally environmental and can't be attacked.

    if (dead || hidden) return;

    if (effect.source != null && !healing) {
      if (sourceAccount != null && account != null) {
        // Handles non-pvp areas.

        if (!account!.canPvP || !sourceAccount.canPvP) {
          splat('pvp disabled', 'effect-text');
          return;
        }
      }

      // Both enter combat at the same time.

      enterCombat(effect.source);
      effect.source.enterCombat(this);
    }

    // Causes non-players to retaliate to attacks if they don't already have a
    // target, are stuck, can't fire at their target, or their target is too far
    // away.

    if (effect.causesRetaliation(this) &&
        !player &&
        (targetDoll == null ||
            stuck ||
            !canFireAt(targetDoll!) ||
            chessDistanceTo(targetDoll!.currentLocation) > 5)) {
      targetLocation = null;
      targetDoll = effect.source;
    }

    // Handles player retaliation.

    if (effect.causesRetaliation(this) &&
        player &&
        targetDoll == null &&
        (targetLocation == null || targetLocation == currentLocation)) {
      targetLocation = null;
      targetDoll = effect.source;
    }

    // FIXME BIG HP: BigInt.toDouble might cause problems.

    var resists = resistances, accuracy = effect.accuracy?.toDouble();

    // Only effects that deal damage can be critical.

    var critical = !healing &&
        !charming &&
        effect.damage! > BigInt.zero &&
        random(20) == 0;

    // Handles misses. Healing, charming, and electric attacks ignore evasion.

    if (!effect.egos.contains(Ego.electric) ||
        resists
            .containsKey(Ego.resistElectric)) if (!critical &&
        accuracy != null &&
        !charming &&
        !healing &&
        !calculateHit(this, accuracy, evasion)) return;

    var parries = weapons.where((item) => item.egos.contains(Ego.parry)).length;
    if (healing) parries = 0;

    if (parries > 0) {
      // With 2 swords, a player has a 43.75% chance of parrying.
      // With Okawaru and 2 swords, a player has a 75% chance of parrying.

      if (randomDouble > pow(account?.god == 'okawaru' ? .25 : .5, parries)) {
        splat('parry', 'effect-text');
        return;
      }
    }

    // Handles damage.

    if (effect.damage != null) {
      assert(effect.damage! >= BigInt.zero);

      // Critical hits never miss and deal maximum damage. Healing and charming
      // effects always deal maximum damage.

      BigInt? maxDamage = applyDefense(effect.damage!, effect.egos),
          damage = effect.egos.contains(Ego.maximumDamage) ||
                  critical ||
                  healing ||
                  charming
              ? maxDamage
              : BigIntUtil.random(maxDamage + BigInt.one);

      // Extra ego damage to make up for being resisted (not including blood
      // or ballistic).

      BigInt? base = damage;
      int blood = 0;

      const [
        // +500%

        Ego.antimatter,
        Ego.antimatter,
        Ego.antimatter,
        Ego.antimatter,
        Ego.antimatter,

        // +100%

        Ego.energy,
        Ego.fire,
        Ego.ice,
        Ego.electric,
        Ego.gravity,
        Ego.poison,
        Ego.acid
      ]
          .where((ego) =>
              effect.egos.contains(ego) &&
              !resists.containsKey(Ego.resistedBy[ego]))
          .forEach((ego) => damage = damage! + base!);

      // Berserk, like burst, does not stack.

      if (effect.egos.contains(Ego.berserk) ||
          effect.sourceNonWeaponEgos.keys.contains(Ego.berserk))
        damage = damage! * big(3)!;

      BigInt? rebase = damage;

      // Handles egos from the source's armor.

      effect.sourceNonWeaponEgos.forEach((ego, amount) {
        if (ego == Ego.blood) blood += amount;

        if (ego == Ego.arcane && effect.egos.contains(Ego.magic))
          damage = damage! + rebase! * big(amount)!;
      });

      if (healing) {
        if (effect.source.account != null && summoned)
          // A player is healing their pet.

          heal(damage);
        else if (effect.source.summoned)
          // A pet is healing their master.

          effect.source.masterDoll?.heal(damage);
        else
          heal(damage);
      } else if (charming) {
        if (!tamableBy(effect.source)) {
          splat('no effect', 'effect-text');

          effect.source
            ..targetDoll = null
            ..ability = null;

          return;
        }

        // There is no need for Elyvilon to reduce charm damage, because players
        // can't be charmed.

        damage = BigIntUtil.max(BigInt.one, damage!);
        _charmDamage += big(damage)!;

        BigInt percentage =
            BigIntUtil.min(big(100)!, _charmDamage * big(100)! ~/ maxHealth!);

        var text = '$percentage% tamed';

        splat(critical ? '$damage ($text, critical)' : '$damage ($text)',
            'charm-text');

        if (_charmDamage >= maxHealth!) {
          if (effect.source.account!.pet != null)
            effect.source.account!.pet!.stage
                ?.removeDoll(effect.source.account!.pet);

          effect.source.account!.pet = Doll(infoName, null, false, difficulty);
          effect.source.account!.doll!.summon();
          killWithNoReward();
        }
      } else
        hurt(effect.source, damage, critical ? 'critical' : null);

      // Gravity hurts 2.5% of a target's remaining health.

      if (effect.egos.contains(Ego.gravity) &&
          !equipmentEgos.containsKey(Ego.resistGravity))
        hurt(effect.source, BigIntUtil.max(BigInt.one, health ~/ big(40)!),
            'gravity', 'gravity-text');

      if (effect.source != null && !healing && !charming) {
        var reflections = equipmentEgos[Ego.reflection] ?? 0;

        if (reflections > 0) {
          BigInt reflectedDamage = calculateReflectedDamage(this);

          // Like gravity damage, reflected damage is not affected by gods or
          // equipment like power gloves or power boots.

          reflectedDamage = effect.source.applyDefense(reflectedDamage);

          reflectedDamage = BigIntUtil.max(
              BigInt.one, BigIntUtil.random(reflectedDamage + BigInt.one)!);

          effect.source
              .hurt(this, reflectedDamage, 'reflection', 'reflection-text');
        }
      }

      // Handles death attacks.

      if (effect.egos.contains(Ego.death) &&
          !resists.containsKey(Ego.resistEvil)) {
        killWithNoReward();
        splat('no reward', 'effect-text');
        account?.noteLethalDamage(effect.source, damage);
      }

      // Handles blood attacks.

      if (effect.egos.contains(Ego.blood)) blood++;
      if (effect.source?.account?.god == 'makhleb') blood++;

      // Blood attacks are considered evil.

      if (blood > 0 && !equipmentEgos.containsKey(Ego.resistEvil))
        effect.source?.heal(
            BigIntUtil.max(BigInt.one, big(damage)! * big(blood)! ~/ big(4)!));

      if (effect.egos.contains(Ego.poison) &&
          !equipmentEgos.containsKey(Ego.resistPoison)) {
        _poisonDamage += damage!;
        poisoned = true;
      }
    }

    var resistedCurse = equipmentEgos.containsKey(Ego.resistEvil);

    if (!resistedCurse && effect.egos.contains(Ego.sickness))
      setDebuff(Ego.sickness, true);

    if (!resistedCurse && effect.egos.contains(Ego.blindness))
      setDebuff(Ego.blindness, true);

    if (!resistedCurse && effect.egos.contains(Ego.confusion))
      setDebuff(Ego.confusion, true);

    if (effect.egos.contains(Ego.ice)) frozen = true;
    if (effect.egos.contains(Ego.fire)) burned = true;

    // Handles stun.

    if (effect.egos.contains(Ego.stun)) {
      if (Clock.time - _lastStun! >=
          CoolDown.average ~/ ServerGlobals.tickDelay * 2) {
        splat('stun', 'effect-text');
        _lastStun = Clock.time;
        warmUp(#left, CoolDown.average);
        warmUp(#right, CoolDown.average);
      }
    }

    if (effect.egos.contains(Ego.killWithoutReward)) killWithNoReward();
  }

  int _buff(String key, int value) {
    int attributeBuff() {
      if (account == null) return level;
      if (key == 'str') return _sheet!.strengthBuffs;
      if (key == 'dex') return _sheet!.dexterityBuffs;
      if (key == 'int') return _sheet!.intelligenceBuffs;
      if (key == 'agi') return _sheet!.agilityBuffs;
      if (key == 'vit') return _sheet!.healthBuffs;
      throw ArgumentError(key);
    }

    value += value * attributeBuff() ~/ 100;
    var result = value;
    if (buffs.containsKey('$key+')) result += value ~/ 2;
    if (buffs.containsKey('$key-')) result -= value ~/ 2;
    return result;
  }

  bool _canGridApproach(Point<int> current, Point<int> target) {
    while (true) {
      var point = _gridApproach(current, target);
      if (point == target) return true;
      if (point == current) return false;
      current = point as Point<int>;
    }
  }

  void _disarm() {
    account!.equipped.remove('double equipped');

    (List.from(inSlot(#shield))..addAll(weapons))
        .forEach((item) => equipped.remove(item.id));
  }

  void _dropLoot() => playersInRange
      .where((looter) => looter!.canLoot(this))
      .forEach((looter) => reward(looter!));

  List<List<int?>> _findPath(
      Point<int> start, Point<int> end, dynamic at(dynamic point)) {
    _getNeighbors(node, at(point)) {
      var x = node.x,
          y = node.y,
          neighbors = <Node>[],
          s0 = false,
          s1 = false,
          s2 = false,
          s3 = false;

      if (at(Point<int>(x, y - 1)).walkable) {
        neighbors.add(at(Point<int>(x, y - 1)));
        s0 = true;
      }

      if (at(Point<int>(x + 1, y)).walkable) {
        neighbors.add(at(Point<int>(x + 1, y)));
        s1 = true;
      }

      if (at(Point<int>(x, y + 1)).walkable) {
        neighbors.add(at(Point<int>(x, y + 1)));
        s2 = true;
      }

      if (at(Point<int>(x - 1, y)).walkable) {
        neighbors.add(at(Point<int>(x - 1, y)));
        s3 = true;
      }

      if (s3 && s0 && at(Point<int>(x - 1, y - 1)).walkable)
        neighbors.add(at(Point<int>(x - 1, y - 1)));

      if (s0 && s1 && at(Point<int>(x + 1, y - 1)).walkable)
        neighbors.add(at(Point<int>(x + 1, y - 1)));

      if (s1 && s2 && at(Point<int>(x + 1, y + 1)).walkable)
        neighbors.add(at(Point<int>(x + 1, y + 1)));

      if (s2 && s3 && at(Point<int>(x - 1, y + 1)).walkable)
        neighbors.add(at(Point<int>(x - 1, y + 1)));

      return neighbors;
    }

    List<List<int?>> _backtrace(node) {
      var path = <List<int?>>[
        [node.x, node.y]
      ];
      while (node.parent != null) {
        node = node.parent;
        path.add([node.x, node.y]);
      }
      return path.reversed.toList();
    }

    var openList = Heap((first, second) => first.f - second.f),
        startNode = at(start),
        endNode = at(end),
        node,
        neighbors,
        neighbor,
        i,
        l,
        x,
        y,
        ng;

    startNode.g = 0;
    startNode.f = 0;

    openList.push(startNode);
    startNode.opened = true;

    while (!openList.empty()) {
      node = openList.pop();
      node.closed = true;
      if (node == endNode) return _backtrace(endNode);

      neighbors = _getNeighbors(node, at);
      i = 0;
      for (l = neighbors.length; i < l; ++i) {
        neighbor = neighbors[i];

        if (neighbor.closed == true) continue;
        x = neighbor.x;
        y = neighbor.y;
        ng = node.g + ((x - node.x == 0 || y - node.y == 0) ? 1 : sqrt2);

        if (neighbor.opened != true || ng < neighbor.g) {
          neighbor.g = ng;
          neighbor.h = neighbor.h != null
              ? neighbor.h
              : Heuristic.chebyshev(abs(x - end.x), abs(y - end.y));
          neighbor.f = neighbor.g + neighbor.h;
          neighbor.parent = node;

          if (neighbor.opened != true) {
            openList.push(neighbor);
            neighbor.opened = true;
          } else
            openList.updateItem(neighbor);
        }
      }
    }

    return const [];
  }

  Point<num> _gridApproach(Point<int> current, Point<int> target) {
    var dx = (target.x - current.x).sign,
        dy = (target.y - current.y).sign,
        next = Point(current.x + dx, current.y + dy);

    // Prevents players from getting trapped in walls.

    if (account != null && !_traversable(current)) return next;

    // Prevents dancing when reaching a target.

    if (current == next || target == next && !traversable(next)) return current;

    // Stops with a collision heading horizontally or vertically.

    if (!traversable(Point(current.x, current.y + dy)) ||
        !traversable(Point(current.x + dx, current.y)) ||
        [
          Point(current.x + dx, current.y + dy),
          Point(current.x, current.y + dy),
          Point(current.x + dx, current.y)
        ].any((point) => !traversable(point))) if (dx == 0 || dy == 0)
      return current;
    else {
      var considerations = [];

      // Slides with a collision heading horizontally or diagonally.

      if (traversable(Point(current.x + dx, current.y)))
        considerations.add(Point(current.x + dx, current.y));

      if (traversable(Point(current.x, current.y + dy)))
        considerations.add(Point(current.x, current.y + dy));

      if (considerations.isEmpty) return current;

      next = considerations.reduce((result, point) =>
          point.distanceTo(target) < result.distanceTo(target)
              ? point
              : result);
    }

    return next;
  }

  void _handleDeath() {
    if (!dead || spawning) return;
    _handlePlayerLoot();
    if (!dead) return;
    spawning = true;
    targetLocation = null;
    targetDoll = null;
    pendingUsedItems.clear();

    // Removes things like poison.

    effects.clear();
    if (buffs.isNotEmpty) buffs.clear();

    // Prevents pets from keeping bosses in combat after their masters die.

    if (account?.pet != null) stage?.removeDoll(account!.pet);

    // The spawn delay should allow splats to display. If too many splats appear
    // they may not all display. That's OK. The spawn delay also allows monsters
    // to heal from not being in combat.

    if (account != null) {
      // Will run even if a player logs in while dead.

      Future.delayed(const Duration(seconds: 5), () {
        if (account!.online) {
          leaveCombat();
          lastPlayerCombatTime = -25;
          _abilities['respawn']!.use!(this);
          spawning = false;
          _noReward = false;
          health = maxHealth!;
        } else
          Logger.root.info('${account!.id} died while offline.');
      });

      return;
    }

    // Summoned monsters give no items or experience.

    if (!summoned) {
      if (!_noReward) {
        _dropLoot();
        _rewardExperience();

        playersInRange.forEach((Account? looter) {
          if (!looter!.canLoot(this)) return;

          if (info!.boss) {
            // The floor after the current floor is unlocked.

            var unlocked = stageToFloor(stage?.id) + 1;

            // There are overflow errors after the highest floor.

            if (unlocked > looter.highestFloor) {
              looter
                ..highestFloor = unlocked
                ..alert('Floor $unlocked is unlocked.');

              // Players are teleported to floors as they are unlocked.

              Future.delayed(Duration(seconds: 1), () {
                if (looter.sessions.isNotEmpty &&
                    looter.currentFloor < looter.adjustedHighestFloor &&
                    looter.currentFloor < Session.maxFloor)
                  looter.sessions.first
                      .teleport(looter.adjustedHighestFloor, false);
              });
            }
          }

          info!.killFlags.forEach((flag) => looter.flags[flag] = true);
        });
      }

      // Summoned and temporary monsters don't respawn like other monsters.

      Future.delayed(const Duration(seconds: 30), () {
        if (!temporary && !summoned) {
          jump(spawnStage, spawnLocation);
          leaveCombat();
          spawning = false;
          _noReward = false;
          health = maxHealth!;
        }
      });
    }
  }

  void _handlePlayerLoot() {
    if (account == null) return;
    alert('You die.');
  }

  Point<int>? _handleStairs(Stage? stage, Point<int> location) {
    // Only players can use stairs.

    if (account == null ||
        stage == null ||
        stage.id == ServerGlobals.playerSpawnStage!.id) return location;

    // Stairs allow players to teleport on top of other dolls, but not obstacles
    // like resources.

    var points = List<Point>.from(adjacent(location)
        .where((point) => stage.traversable(this, point, Terrain.doll)));

    if (points.isEmpty)
      return stage.randomTraversableLocation(this) ?? const Point(0, 0);

    // TODO: Make stairs more deterministic.

    return randomValue(points);
  }

  void _idle() {
    if (!info!.moves || targetDoll != null || random(50) != 0) return;

    var home = Rectangle(
        spawnLocation!.x - _wanderingRange!,
        spawnLocation!.y - _wanderingRange!,
        _wanderingRange! * 2,
        _wanderingRange! * 2);

    targetLocation = randomPoint(home);
  }

  bool _path(Point<int> target) {
    // Players and pets have better path finding than mobs.

    var smart = masterDoll?.account != null;
    if (!smart && account == null) return gridApproach(target);

    // Prevents hanging on very distant targets.

    target = Point(
        clamp(target.x, currentLocation.x - 100, currentLocation.x + 100)
            as int,
        clamp(target.y, currentLocation.y - 100, currentLocation.y + 100)
            as int);

    // FIXME: this is buggy and sometimes the correct path isn't found.

    if (_canGridApproach(currentLocation, target)) {
      _pathFinder = null;
      return gridApproach(target);
    }

    if (_pathFinder == null || _pathFinder!.target != target)
      _pathFinder = PathFinder(target);

    _pathFinder!.path ??= _findPath(
        currentLocation,
        target,
        (point) => _pathFinder!.nodes[point] ??=
            Node(point.x, point.y, point == target || traversable(point)));

    if (_pathFinder!.path!.length < 2) return gridApproach(target);
    var list = _pathFinder!.path!.removeAt(1);
    return gridApproach(Point(list[0]!, list[1]!));
  }

  void _rewardExperience() =>
      playersInRange.where((looter) => looter!.canLoot(this)).forEach((looter) {
        BigInt result = experience;
        if (looter!.hasCrystalPrimaryWeapon) result += experience;
        if (looter.hasCrystalSecondaryWeapon) result += experience;
        result += big(looter.doll!.crystalShields)! * experience;
        var mode = looter.options['xp mode'];

        if (mode == 'summoning')
          looter.gainExperience(result, 'summoning');
        else if (mode == 'slaying')
          looter.gainExperience(result, 'slay');
        else
          looter.gainExperience(result, 'combat');
      });

  bool _traversable(Point<int> point, [int? overrideThisCanPass]) =>
      stage?.traversable(this, point, overrideThisCanPass ?? thisCanPass) ==
      true;

  bool _useItem(Item? item) {
    if (item == null || item.amount < 1) return false;

    if (item.info?.use != null && item.info!.use!(this, item)) {
      if (item.info!.consumed) account!.items.removeItem(item.id);
      return true;
    }

    item.egos.contains(Ego.food)
        ? account!.alert(alerts[#noEat])
        : account!.alert(alerts[#noUse]);

    return false;
  }

  bool _visible(Doll? target) {
    // Prevents players from being attacked after teleporting.

    if (target?.account != null && Clock.time - target!._lastTeleport! < 25)
      return false;

    if (target?.account == null || targetDoll?.id == target?.id) return true;

    // Bosses always attack players.

    return boss || target!.account!.options['stealth'] == false;
  }

  BigInt _vitalityToHealth(int vitality) {
    var result = big(vitality)! * big(10)!;

    // Non-players have additional health to make up for not having food.

    if (account == null) result += result * big(level)! ~/ big(100)!;
    return BigIntUtil.max(BigInt.one, result);
  }

  int _weaponAttribute([Item? weapon]) {
    if (weapon == null) return strength;
    if (weapon.info!.egos.contains(Ego.magic)) return intelligence;
    if (weapon.info!.egos.contains(Ego.ballistic)) return dexterity;
    return strength;
  }
}
