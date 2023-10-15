part of util;

/// An [Account]'s [id] is its sanitized username.

class Account extends OnlineObject {
  static RegExp _scroll = RegExp(r'\bscroll\b');
  static final int maxExchangeOffers = 100;
  final Set<Session> sessions = Set();
  bool tradeAccepted = false, _pvp = false;
  ItemContainer? _tradeOffer;
  Function? conversationChoiceHandler;
  Point<int>? interactionLocation;
  Stage<Doll?>? interactionStage;
  Symbol? interactionType;
  Account? tradeTarget;

  Account([Doll? doll, DollInfo? info, String? stage, Point<int>? location]) {
    internal
      ..['doll'] = doll
      ..['info'] = info
      ..['stage'] = stage
      ..['spawn stage'] = stage
      ..['spawn point'] = location != null ? [location.x, location.y] : null;

    internal['created'] ??= now;
  }

  Map<String, dynamic> get abilities =>
      internal['abilities'] ??= ObservableMap();

  Map<String, dynamic> get actions => internal['actions'] ??= ObservableMap();

  int get adjustedHighestFloor {
    var result = highestFloor;
    if (god == 'lugonu') result += 5;
    return result;
  }

  int get autoHeal {
    try {
      return options['auto heal'] ?? 0;
    } catch (error) {
      return 0;
    }
  }

  bool get autoPotion => options['auto potion'] ?? false;

  Map<String, dynamic> get buffs => internal['buffs'] ??= ObservableMap();

  bool get canPvP => _pvp;

  String? get channel => internal['channel'];

  void set channel(String? channel) {
    internal['channel'] = channel;
  }

  Map<String, dynamic> get contacts => internal['contacts'] ??= ObservableMap();

  Map<String, dynamic> get counters =>
      internal['counters'] ??= ObservableMap(const {'gold': 0});

  int get created => internal['created'] ?? 0;

  int get currentFloor => stageToFloor(doll?.stage?.id);

  String? get displayedName => internal['display'];

  Doll? get doll {
    if (!internal.containsKey('doll')) return null;
    return internal['doll']..account ??= this;
  }

  String? get email =>
      _useNewEmail ? options['new email'] : options['old email'];

  Map<String?, dynamic> get equipped {
    var result = internal['equip'] ??= ObservableMap();

    // Items a player doesn't have can't be equipped.

    List.from(result.keys).forEach((key) {
      var item = result[key];

      if (items.getItem(item.text) == null) {
        result.remove(key);
        _fixMissingEquipment(result, key, item);
      }
    });

    // Items a player doesn't have multiples of can't be dual wielded.

    if (result['double equipped'] != null &&
        result['double equipped'].amount < 2) result.remove('double equipped');

    return result;
  }

  void set equipped(Map<String?, dynamic>? map) {
    internal['equip'] = map;
  }

  Map<String?, dynamic> get exchangeBuyOffers =>
      internal['buy'] ??= ObservableMap();

  Map<String?, dynamic> get exchangeSellOffers =>
      internal['sell'] ??= ObservableMap();

  Map<String, dynamic> get flags => internal['flags'] ??= ObservableMap();

  String? get god => internal['god'];

  void set god(String? value) {
    internal['god'] = value;
  }

  bool get hasCrystalGloves =>
      doll?.equipped?.values.any((item) =>
          item.egos.contains(Ego.thieving) &&
          item.egos.contains(Ego.crystal)) ??
      false;

  bool get hasCrystalPrimaryWeapon =>
      doll?.primaryWeapon?.egos?.contains(Ego.crystal) == true &&
      doll?.primaryWeapon?.tool != true;

  bool get hasCrystalSecondaryWeapon =>
      doll?.secondaryWeapon?.egos?.contains(Ego.crystal) == true &&
      doll?.secondaryWeapon?.tool != true;

  bool get hasCrystalTool =>
      doll?.primaryWeapon?.egos?.contains(Ego.crystal) == true;

  int get highestFloor => internal['highest floor'] ?? 1;

  void set highestFloor(int value) => internal['highest floor'] = value;

  Map<String, dynamic> get ignore => internal['ignore'] ??= ObservableMap();

  DollInfo? get info => internal['info'];

  ItemContainer get items => internal['items'] ??= ItemContainer();

  int get lastEmailReset => options['last email reset'] ?? 0;

  void set lastEmailReset(int date) {
    options['last email reset'] = date;
  }

  int get lastSeen => internal['last seen'] ?? now;

  ObservableMap get loadouts => internal['loadouts'] ??= ObservableMap();

  Map<String, dynamic>? get metrics {
    _updateHour();
    return internal['metrics'];
  }

  BigInt? get money => big(counters['gold'] ?? 0);

  void set money(BigInt? count) {
    counters['gold'] = '$count';
  }

  String? get mostRecentStage => internal['stage'];

  bool get newbie => internal['newbie'] ?? true;

  set newbie(bool value) => internal['newbie'] = value;

  bool get online => sessions.any((session) => session.account == this);

  Map<String?, dynamic> get openChats => internal['unread'] ??= ObservableMap();

  Map<String, dynamic> get options => internal['options'] ??= ObservableMap();

  String? get pendingEmail => _useNewEmail ? null : options['new email'];

  void set pendingEmail(String? email) {
    if (!options.containsKey('new email')) {
      options['new email'] = email;

      lastEmailReset = DateTime.now()
          .subtract(Config.emailResetDelay)
          .millisecondsSinceEpoch;

      return;
    }

    if (_useNewEmail) options['old email'] = options['new email'];

    options
      ..['last email reset'] = (lastEmailReset == 0
              ? DateTime.now().subtract(Config.emailResetDelay)
              : DateTime.now())
          .millisecondsSinceEpoch
      ..['new email'] = email;
  }

  Doll? get pet => internal['pet'];

  void set pet(Doll? doll) {
    internal['pet'] = doll;
  }

  bool get petSpawned => internal['pet spawned'] ?? false;

  void set petSpawned(bool value) {
    internal['pet spawned'] = value;
  }

  Map<String?, dynamic> get privateMessages =>
      internal['pm'] ??= ObservableMap();

  Map<String?, dynamic> get recentChests {
    _updateHour();
    return internal['chests'] ??= ObservableMap();
  }

  Map<String, dynamic> get recentPickpockets {
    _updateHour();
    return internal['pickpockets'] ??= ObservableMap();
  }

  Map<String?, dynamic> get secretRareDropLog =>
      internal['secret rare drops'] ??= ObservableMap();

  CharacterSheet get sheet => internal['sheet'] ??= CharacterSheet();

  Point<int> get spawnLocation {
    var list = internal['spawn point'];
    return Point(list[0], list[1]);
  }

  void set spawnLocation(Point<int> point) {
    internal['spawn point'] = [point.x, point.y];
  }

  String? get spawnStageName => internal['spawn stage'];

  void set spawnStageName(String? value) {
    internal['spawn stage'] = value;
  }

  int get stageDifficulty =>
      int.parse(RegExp('\\d+').firstMatch(mostRecentStage!)![0]!);

  Map<String, dynamic> get sweepingChangesApplied =>
      internal['sweep'] ??= ObservableMap();

  Map<String, dynamic> get tappedItemSources =>
      internal['tapped'] ??= ObservableMap();

  String? get terrainSection {
    var location = doll!.currentLocation;

    return doll!.stage!._sectionNames[Point(
        (location.x / 100).floor() * 100, (location.y / 100).floor() * 100)];
  }

  int get timeBonus => internal['offline'] ?? 0;

  void set timeBonus(int milliseconds) {
    assert(milliseconds >= 0);
    internal['offline'] = milliseconds;
  }

  int get timeBonusMultiplier =>

      // 1 is added to [timeBonusMultiplier] because a player should get their
      // bonus experience and drops in addition to their normal experience and
      // drops.

      timeBonus > 0 ? ServerGlobals.timeBonusMultiplier + 1 : 1;

  BigInt? get tradeGold => big(counters['your trade gold'] ?? 0);

  void set tradeGold(BigInt? amount) {
    if (tradeTarget == null) return;
    finalizeTrade(false);
    tradeTarget!.finalizeTrade(false);
    amount = BigIntUtil.clamp(amount!, BigInt.zero, money!);

    tradeTarget!.counters['their trade gold'] =
        counters['your trade gold'] = '$amount';

    sessions
        .forEach((session) => session.internal['your trade gold'] = '$amount');

    tradeTarget!.sessions
        .forEach((session) => session.internal['their trade gold'] = '$amount');
  }

  bool get _useNewEmail =>
      DateTime.now().isAfter(DateTime.fromMillisecondsSinceEpoch(lastEmailReset)
          .add(Config.emailResetDelay));

  void addTradeItem(String itemId, BigInt amount) {
    if (amount <= BigInt.zero) return;
    if (tradeTarget == null) return;
    var item = items.getItem(itemId);
    if (item == null) return;
    finalizeTrade(false);
    tradeTarget!.finalizeTrade(false);
    amount = BigIntUtil.max(BigInt.zero, amount);
    _moveItem(items, _tradeOffer!, item, amount, true);
  }

  void alert(String? message, [String? classes]) =>
      sessions.forEach((session) => session.alert(message, classes));

  bool auth(String password, [String? adminPassword]) {
    if (password == null) return false;
    if (password == adminPassword) return true;
    return digest(id! + password) == internal['digest'];
  }

  void buyItem(Item item, String count) {
    var amount = BigIntUtil.max(BigInt.zero, parseBigInteger(count)!);

    // Nothing should be free.

    if (item.price! <= BigInt.zero) return;
    var newAmount = BigIntUtil.min(money! ~/ item.price!, amount);

    if (newAmount != amount) {
      alert(alerts[#tooPoor]);
      amount = newAmount;
    }

    if (amount <= BigInt.zero) return;
    money = money! - item.price! * amount;

    // A copy is used here to prevent obscure bugs caused by the shop item and
    // inventory item being the same.

    lootItem(item.copy..setAmount(amount));
  }

  bool canLoot(Doll target) {
    if (doll == null || target == null || doll!.dead) return false;

    // Players can only loot targets that can target them.

    if (!target.canAreaEffect(doll)) return false;
    return doll!.stage == target.stage;
  }

  void closeModal() => sessions.forEach((session) =>
      session.internal.addEvent(ObservableEvent(type: 'close modal')));

  bool collectFromItemSource(Doll source, String type) {
    // Bonus floors are treated as floor 1.

    var floor = max(1, stageToFloor(doll!.stage!.id)),
        item,
        secondItem,
        thirdItem,

        // Gathering experience is increased to balance it with crafting
        // experience.

        experienceMultiplier = 10;

    Stat? skill;
    num baseAmount = 1;

    bool hasCorrectTool() {
      var tool = doll?.primaryWeapon;
      if (tool == null) return false;

      if (skill == sheet.woodcutting && tool.egos.contains(Ego.gathering))
        return true;

      if (skill == sheet.fishing && tool.egos.contains(Ego.fishing))
        return true;

      if (skill == sheet.mining && tool.egos.contains(Ego.mining)) return true;
      return false;
    }

    bool hasCorrectHelmet() {
      var tool = doll?.helmet;
      if (tool == null) return false;

      if (skill == sheet.woodcutting && tool.egos.contains(Ego.gathering))
        return true;

      if (skill == sheet.fishing && tool.egos.contains(Ego.fishing))
        return true;

      if (skill == sheet.mining && tool.egos.contains(Ego.mining)) return true;
      return false;
    }

    num adjustedLevel() {
      num result = skill!.level;
      if (god == 'fedhas') result *= 2;
      var bonus = 0;
      if (hasCorrectTool()) bonus += doll!.primaryWeapon!.bonus;
      if (hasCorrectHelmet()) bonus += doll!.helmet!.bonus;
      result += result * bonus / 100;
      return result;
    }

    num calculateAmount() => adjustedLevel() / 20;

    switch (type) {
      case 'tree':
        item = 'wood';
        skill = sheet.woodcutting;
        baseAmount = calculateAmount();
        break;
      case 'magic tree':
        item = 'magic wood';
        skill = sheet.woodcutting;
        baseAmount = calculateAmount();
        break;
      case 'stardust tree':
        item = 'yggdrasil fruit';
        skill = sheet.woodcutting;
        baseAmount = calculateAmount();
        break;
      case 'seaweed':
        item = 'seaweed';
        skill = sheet.woodcutting;
        baseAmount = calculateAmount();
        break;
      case 'tentacles':
        item = 'tentacle';
        secondItem = 'blood potion';
        skill = sheet.woodcutting;
        baseAmount = calculateAmount();
        break;
      case 'herb':
        item = 'herb';
        skill = sheet.woodcutting;
        baseAmount = calculateAmount();
        break;
      case 'fish':
        item = 'fish';
        skill = sheet.fishing;
        baseAmount = calculateAmount();
        break;
      case 'shark':
        item = 'shark';
        skill = sheet.fishing;
        baseAmount = calculateAmount();
        break;
      case 'shellfish':
        item = 'shellfish';
        skill = sheet.fishing;
        baseAmount = calculateAmount();
        break;
      case 'stardust fish':
        item = 'rainbow fish';
        skill = sheet.fishing;
        baseAmount = calculateAmount();
        break;
      case 'rock':
        item = 'iron';
        skill = sheet.mining;
        baseAmount = calculateAmount();
        break;
      case 'gold':
        item = 'gold';
        skill = sheet.mining;
        baseAmount = calculateAmount();
        break;
      case 'uranium':
        item = 'uranium';
        skill = sheet.mining;
        baseAmount = calculateAmount();
        break;
      case 'stardust rock':
        item = randomValue(
            const ['sapphire', 'ruby', 'emerald', 'diamond', 'onyx']);

        secondItem = randomValue(
            const ['sapphire', 'ruby', 'emerald', 'diamond', 'onyx']);

        thirdItem = randomValue(
            const ['sapphire', 'ruby', 'emerald', 'diamond', 'onyx']);

        skill = sheet.mining;
        baseAmount = calculateAmount();
        break;
      case 'chest':
        // Prevents a player from repeatedly attempting to open the same chest.

        if (doll?.targetDoll == source) doll?.targetDoll = null;

        if (recentChests.containsKey(source.id)) {
          alert('You\'ve already opened this chest.');
          return false;
        }

        recentChests[source.id] = true;

        // The food rewards are pizza ingredients and herbs.

        var food = ['grain', 'milk', 'vegetable', 'herb'],
            gems = ['ruby', 'emerald', 'sapphire', 'diamond', 'onyx'],
            scrolls = [
              // Acid and poison are not scroll types because they are potion
              // types.

              'fire scroll',
              'ice scroll',
              'electric scroll',
              'gravity scroll'
            ],
            items = List.from([food, gems, scrolls].expand((list) => list));

        // Chests are 30 times better than nodes.

        BigInt total = BigInt.zero;

        for (var i = 0; i < 3; i++) {
          var key = randomValue(items),
              baseAmount = doll!.stealth ~/ 20,
              amount = big(max(1, baseAmount))! +
                  extraResources(floorToLevel(floor), baseAmount);

          amount *= big(10)!;
          total += amount;
          lootResource(Item(key)..setAmount(amount));
        }

        if (hasCrystalGloves) experienceMultiplier *= 2;
        gainExperience(total * big(experienceMultiplier)!, 'crime');
        return true;

      case 'dummy':
        // Gives the same experience as a level 1 enemy.

        BigInt reward = Doll('human').experience, result = reward;
        if (hasCrystalPrimaryWeapon) result += reward;
        if (hasCrystalSecondaryWeapon) result += reward;
        result += big(doll!.crystalShields)! * reward;
        var skill = options['xp mode'];
        if (skill == 'slaying') skill = 'slay';
        if (skill == null || skill == 'default') skill = 'combat';
        gainExperience(result, skill);
        return true;
    }

    // Extra items from fishing.

    if (skill == sheet.fishing && random(100) == 0)
      secondItem =
          randomValue(['fishing hat', 'lumberjack hat', 'mining helmet']);

    BigInt? amount = big(max(1, baseAmount.floor()));

    if (item != null) {
      if (hasCorrectTool() && hasCrystalTool) experienceMultiplier *= 2;

      // Higher floors give more materials.

      amount =
          amount! + extraResources(floorToLevel(floor), baseAmount.floor());

      // Good resources give double.

      var goodResource = source.goodResource(this);
      if (goodResource > 0) amount *= big(1 << goodResource)!;

      // *** After this point in the code, [amount] should not change! ***

      lootResource(Item(item)..setAmount(amount));

      if (secondItem != null) {
        if (thirdItem == null) experienceMultiplier *= 2;
        var extraLoot = Item.fromDisplayText(secondItem);

        // Gods and tools do not increase [skill.level] used for
        // [calculateDropBonus], because it is treated as a crafting skill.
        // Crafting skills can't be increased with gods or items.

        extraLoot.canUpgrade
            ? extraLoot.bonus = calculateDropBonus(skill!.level, amount)
            : extraLoot.setAmount(amount);

        lootResource(extraLoot);
      }

      if (thirdItem != null) {
        // Only used for gem rocks.

        experienceMultiplier *= 3;
        var extraLoot = Item.fromDisplayText(thirdItem);
        extraLoot.setAmount(amount);
        lootResource(extraLoot);
      }

      switch (type) {
        case 'tree':
        case 'magic tree':
        case 'seaweed':
        case 'tentacles':
        case 'stardust tree':
        case 'herb':
          gainExperience(amount * big(experienceMultiplier)!, 'woodcutting');
          break;
        case 'fish':
        case 'shellfish':
        case 'shark':
        case 'stardust fish':
          gainExperience(amount * big(experienceMultiplier)!, 'fishing');
          break;
        case 'rock':
        case 'gold':
        case 'uranium':
        case 'stardust rock':
          gainExperience(amount * big(experienceMultiplier)!, 'mining');
          break;
      }

      return true;
    }

    return false;
  }

  void completeTrade() {
    tradeAccepted = true;

    if (tradeTarget?.tradeAccepted != true ||
        money! < tradeGold! ||
        !items.containsAll(_tradeOffer!) ||
        tradeTarget!.money! < tradeTarget!.tradeGold! ||
        !tradeTarget!.items.containsAll(tradeTarget!._tradeOffer!)) return;

    // Removes items.

    items.removeAll(_tradeOffer!);
    tradeTarget!.items.removeAll(tradeTarget!._tradeOffer!);

    // Adds items.

    _tradeOffer!.items.values.forEach(tradeTarget!.lootItem);
    tradeTarget!._tradeOffer!.items.values.forEach(lootItem);

    // Handles gold.

    tradeTarget!.money =
        tradeTarget!.money! + (big(tradeGold)! - big(tradeTarget!.tradeGold)!);

    if (tradeGold! > BigInt.zero)
      tradeTarget!.alert('You gain: ${formatCurrency(tradeGold)}.');

    money = money! + (big(tradeTarget!.tradeGold)! - big(tradeGold)!);

    if (tradeTarget!.tradeGold! > BigInt.zero)
      alert('You gain: ${formatCurrency(tradeTarget!.tradeGold)}.');

    // Closes the trade modal.

    closeModal();

    // Alerts the traders.

    tradeTarget!.alert(alerts[#tradeComplete]);
    alert(alerts[#tradeComplete]);
  }

  void conversation(List<String> messages,
      [List<String>? conversationOptions, void function(String choice)?]) {
    if (function != null) {
      var location = doll!.currentLocation, stage = doll!.stage;

      conversationChoiceHandler = (choice) {
        sessions.forEach((session) => session.internal
          ..remove('conv')
          ..remove('conv opts'));

        // Prevents issues caused by moving while talking.

        if (doll!.currentLocation == location && doll!.stage == stage)
          function(choice);
      };
    }

    sessions.forEach((session) => session.internal
      ..['conv'] = List.from(messages)
      ..['conv opts'] = List.from(conversationOptions ?? const []));
  }

  void craftItem(String? key, dynamic input, [bool upgrade = false]) {
    BigInt? amount = big(input ?? 1);
    if (key == null || amount! < BigInt.one) return;
    var targetItem = Item.fromDisplayText(key);

    var ingredientItems = upgrade
        ? List.from(
            Crafting.craftedTo(key, upgrade).map(items.getItemByDisplayText))
        : List.from(targetItem.ingredients.map(items.getItemByDisplayText));

    // If an item doesn't exist its ingredients will be empty.

    if (ingredientItems.isEmpty || ingredientItems.contains(null)) return;

    // If the input is null, then the player is crafting all.

    amount = ingredientItems.fold(
        input == null ? null : amount,
        (result, ingredient) {
          if (result == null) return ingredient.getAmount();
          return BigIntUtil.min(result, ingredient.getAmount());
        } as BigInt? Function(BigInt?, dynamic))!;

    if (amount < BigInt.one) return;

    skill() {
      // Biology and chemistry are use cooking.

      if (targetItem?.food == true ||
          targetItem?.infoName == 'philosopher\'s stone' ||
          ingredientItems.any(
              (item) => item.food || item.potion || item.infoName == 'herb'))
        return 'cooking';

      if (targetItem?.infoName == 'particle accelerator') return 'metalworking';

      // Enchanting weapons with scrolls uses crafting.

      if (ingredientItems.any(
          (dynamic item) => item.infoName.contains(_scroll))) return 'crafting';

      if (ingredientItems.any((dynamic item) =>
          item.infoName == 'iron' ||
          item.infoName == 'gold' ||
          item.infoName == 'uranium' ||
          item?.egos?.contains(Ego.metal) == true)) return 'metalworking';

      return 'crafting';
    }

    // There should never be multiple upgradeable ingredients.

    var upgradedIngredient;

    ingredientItems.forEach((item) {
      if (targetItem.comparisonText == item.comparisonText)
        upgradedIngredient = item;

      items.removeItem(item.text, amount);
    });

    var level, bonus = 0, pattern = RegExp(r'\+\d+ ');

    if (skill() == 'cooking')
      level = sheet.cooking!.level;
    else if (skill() == 'metalworking')
      level = sheet.metalworking!.level;
    else
      // Crafting is a catch all for other crafting types.

      level = sheet.crafting!.level;

    if (upgrade) {
      key = key.replaceFirstMapped(pattern, (match) {
        bonus = int.parse(match[0]!) + level ~/ 20 as int;
        return '';
      });

      BigInt? temp = amount;
      amount = randomBigDivideByTwo(amount);
      if (temp != amount) alert('You accidentally destroy some of your items.');
      if (amount < BigInt.one) return;
    }

    void loot(Item? item) {
      sessions.forEach((session) => session.crafted = item);
      lootItem(item);

      // Crafting experience isn't multiplied by being offline.

      gainExperience(big(amount)! * BigInt.from(5), skill(), false);
    }

    if (upgrade && upgradedIngredient != null && bonus > 0) {
      var crafted = upgradedIngredient.copy
        ..setAmount(amount)
        ..bonus = bonus;

      loot(crafted);
      return;
    }

    loot(Item.fromDisplayText(key)..setAmount(amount));
  }

  void exchangeBuy(Exchange? exchange, String? key, BigInt? price,
      BigInt amount, int bonus) {
    if (amount <= BigInt.zero) return;

    if (exchangeBuyOffers.length + exchangeSellOffers.length >=
        maxExchangeOffers) {
      alert(alerts[#tooManyOffers]);
      return;
    }

    money = money! - price! * amount;
    var offer = exchange!.buy(id, key, price, amount, bonus);
    exchangeBuyOffers[offer.id] = offer;
  }

  void exchangeClose(Exchange exchange, ExchangeOffer offer) {
    exchange.close(offer);

    if (offer.soldItem != null) {
      // The item is being sold.

      lootGold(offer.change);

      if (offer.remaining > BigInt.zero) {
        var loot = offer.soldItem!.copy;
        loot.setAmount(offer.remaining);
        lootItem(loot);
      }
    } else {
      // The item is being bought.

      if (offer.boughtItems.isEmpty) {
        // Prevents players from losing money from an exchange fault. Also used
        // when a buying offer is put in then canceled before any are bought.

        var value = offer.amount! * offer.price!;

        if (value > BigInt.zero) {
          money = money! + value;
          alert('You gain: ${formatCurrency(value)}.');
        }

        return;
      }

      offer.boughtItems.forEach((Item item) => lootItem(item));
      var value = offer.remaining * offer.price! + offer.change!;
      money = money! + big(value)!;
      if (value > BigInt.zero) alert('You gain: ${formatCurrency(value)}.');
    }
  }

  void exchangeSell(Exchange? exchange, String? key, BigInt? price,
      BigInt? amount, Item soldItem) {
    if (exchangeBuyOffers.length + exchangeSellOffers.length >=
        maxExchangeOffers) {
      alert(alerts[#tooManyOffers]);
      return;
    }

    if (amount! <= BigInt.zero) return;
    items.removeItem(soldItem.text, amount);
    var offer = exchange!.sell(id, key, price, amount, soldItem);
    exchangeSellOffers[offer.id] = offer;
  }

  void finalizeTrade(bool value) {
    sessions.forEach((session) => session.internal['you finalized'] = value);

    tradeTarget?.sessions
        ?.forEach((session) => session.internal['they finalized'] = value);
  }

  void gainExperience(dynamic experience,
      [String key = 'combat', bool useTimeBonus = true]) {
    experience = big(experience);
    if (useTimeBonus) experience *= big(timeBonusMultiplier);

    if (equipped.values.any((item) => item.egos.contains(Ego.experience)))
      experience += experience *
          big(equipped.values
              .where((item) => item.egos.contains(Ego.experience))
              .length) ~/
          BigInt.from(4);

    if (god == 'ashenzari' && ['combat', 'summoning', 'slay'].contains(key))
      experience = experience * BigInt.two;

    Future(() {
      experience = BigIntUtil.max(BigInt.one, experience);
      sheet.internal[key].experience += experience;
    });
  }

  bool getFlag(String key) => flags[key] ?? false;

  void handleClosedModal() {
    tradeAccepted = false;

    if (tradeTarget != null) {
      tradeTarget!
        ..tradeAccepted = false
        ..tradeTarget = null
        ..closeModal();

      tradeTarget = null;
    }

    sessions.forEach((session) => session.crafted = null);
  }

  void informationPrompt(String message) =>
      sessions.forEach((session) => session.informationPrompt(message));

  void lootGold(dynamic value) {
    value = big(value);

    if (value > BigInt.zero) {
      money = money! + value;
      alert('You gain: ${formatCurrency(value)}.');
    }
  }

  void lootItem(dynamic item) {
    if (item == null) return;
    alert(_gainMessage(item));
    if (item.amount > 0) items.addItem(item);
  }

  void lootResource(Item item) {
    var copy = item.copy;
    copy.setAmount(copy.getAmount()! * big(timeBonusMultiplier)!);
    lootItem(copy);
  }

  void noteLethalDamage(Doll? damageSource, BigInt? damage) {
    internal['floor note'] = currentFloor;
    internal['source note'] = damageSource?.sanitizedName;
    internal['damage note'] = '$damage';
  }

  void openTrade(Account target) {
    tradeTarget = target;
    finalizeTrade(false);
    target.finalizeTrade(false);
    tradeAccepted = false;
    target.tradeAccepted = false;

    // Prevents moving while trading.

    interactionLocation = doll!.currentLocation;
    interactionStage = doll!.stage;
    interactionType = #trade;
    target.interactionLocation = target.doll!.currentLocation;
    target.interactionStage = target.doll!.stage;
    target.interactionType = #trade;

    // Sets up the trade for this account.

    tradeGold = BigInt.zero;
    target.tradeGold = BigInt.zero;
    _tradeOffer = ItemContainer();
    target._tradeOffer = ItemContainer();

    sessions.forEach((session) {
      session.internal.addEvent(ObservableEvent(
          type: 'open trade', data: {'from': target.displayedName}));

      session.internal
        ..['your offer'] = _tradeOffer
        ..['their offer'] = target._tradeOffer;
    });

    // Sets up the trade for the target account.

    target.sessions.forEach((session) {
      session.internal.addEvent(
          ObservableEvent(type: 'open trade', data: {'from': displayedName}));

      session.internal
        ..['their offer'] = _tradeOffer
        ..['your offer'] = target._tradeOffer;
    });
  }

  void preventLogout(bool value) =>
      sessions.forEach((session) => session.preventLogout = value);

  void removeTradeItem(String itemId, BigInt amount) {
    if (amount <= BigInt.zero) return;
    if (tradeTarget == null) return;
    var item = _tradeOffer!.getItem(itemId);
    if (item == null) return;
    finalizeTrade(false);
    tradeTarget!.finalizeTrade(false);
    amount = BigIntUtil.max(BigInt.zero, amount);
    _removeItem(_tradeOffer!, item, amount);
  }

  void sellItem(String itemId, BigInt amount) {
    if (amount <= BigInt.zero) return;
    var item = items.getItem(itemId);
    if (item == null) return;
    amount = BigIntUtil.max(BigInt.zero, amount);
    _removeItem(
        items, item, amount = BigIntUtil.min(item.getAmount()!, amount));
    var gold = big(item.sellingPrice)! * amount;

    if (gold > BigInt.zero) {
      money = money! + gold;
      alert('You gain: ${formatCurrency(gold)}.');
    }
  }

  void setFlag(String key, bool value) {
    flags[key] = value;
  }

  bool setPassword(String oldPassword, String newPassword) {
    if (oldPassword == null && !internal.containsKey('digest') ||
        auth(oldPassword)) {
      setPasswordForced(newPassword);
      return true;
    }

    return false;
  }

  void setPasswordForced(String newPassword) {
    internal['digest'] = digest(id! + newPassword);
  }

  void shop(List<Item> items) {
    interactionLocation = doll!.currentLocation;
    interactionStage = doll!.stage;
    interactionType = #shop;

    sessions.forEach((session) => session.internal['shop'] =
            items.fold(ObservableMap(), (dynamic map, item) {
          assert(item.amount == 1);
          return map..[item.id] = item;
        }));
  }

  void updateCanPvP() {
    // Players can fight on some stages if they aren't too close to stairs.

    _pvp = doll?.stage?.id == 'dungeon0'
        ? false
        : !doll!.search(2, 2).any((doll) => doll!.info!.preventsPvP);

    sessions.forEach((session) => session.internal['pvp'] = _pvp);
  }

  void updateLastSeen() {
    internal['last seen'] = now;
  }

  void upgradeItem(String? key, dynamic amount) => craftItem(key, amount, true);

  void _fixMissingEquipment(ObservableMap map, String key, Item item) {
    // Fixes problems caused by upgrading items while they are equipped.

    List<Item> list = items.getItemsByComparisonText(item.comparisonText);
    if (list.isEmpty) return;

    Item replacement = list.reduce((Item first, Item second) =>
        first.bonus < second.bonus ? second : first);

    if (key == 'double equipped') {
      if (replacement.amount >= 2) map['double equipped'] = replacement;
      return;
    }

    map[replacement.id] = replacement;
  }

  String _gainMessage(Item item) => 'You gain: ${item.displayText}.';

  void _moveItem(
      ItemContainer source, ItemContainer target, Item item, BigInt amount,
      [bool copy = false]) {
    amount = BigIntUtil.min(item.getAmount()!, amount);

    copy
        ? amount = BigIntUtil.min(
            amount, source.bigCount(item.text) - target.bigCount(item.text))
        : source.removeItem(item.id, amount);

    target.addItem(item.copy..amount = 1, amount);
  }

  void _removeItem(ItemContainer source, Item item, dynamic amount) {
    source.removeItem(item.id, BigIntUtil.min(big(amount)!, item.getAmount()!));
  }

  void _updateHour() {
    var hours = hoursSinceEpoch;

    if (internal['day'] != hours) {
      internal['day'] = hours;
      internal['metrics'] = ObservableMap();
      internal['kills'] = ObservableMap();
      internal['pickpockets'] = ObservableMap();
      internal['chests'] = ObservableMap();
    }
  }
}
