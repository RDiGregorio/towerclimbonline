part of util;

/// [internal] changes made on server side are applied client side but not the
/// other way around. Any public methods can be called client side, so be
/// careful when writing server side code!

class Session extends OnlineObject {
  static const int maxFloor = 424;
  static final Map<int, Completer<dynamic>> _completers = {};
  static final Map<String, Function> adminCommands = {};
  static final Map<String, RecoveryAttempt> recoveries = {};
  static final Map<String, String> secret = {};
  static Function proceduralStage;
  static Function sendEmail;
  Account _account;

  Completer<dynamic> _loginCompleter = Completer(),
      _logoutCompleter = Completer();

  bool _done = false, _preventLogout = false;
  Function _function;
  dynamic /* WebSocket */ _socket;
  Future<dynamic> disconnect;

  final ResourceManager accountManager,
      channelManager,
      stageManager,
      exchangeManager,
      scoreManager,
      directMessageManager;

  Session(
      [Account this._function(),
      ResourceManager this.accountManager,
      this.channelManager,
      this.stageManager,
      this.exchangeManager,
      this.scoreManager,
      this.directMessageManager,
      this.disconnect]) {
    Future(() async {
      await onLogin;

      if (account.mostRecentStage != null) {
        if (!account.mostRecentStage.startsWith('procgen'))
          (await stageManager.getResource(
                  null, account.mostRecentStage, onLogout))
              .addDoll(account.doll);
        else {
          // Handles logging into procedurally generated floors.

          Stage mostRecentStage =
              stageManager.resources.containsKey(account.mostRecentStage)
                  ? await stageManager.getResource(
                      null, account.mostRecentStage, onLogout)
                  : null;

          mostRecentStage != null
              ? mostRecentStage.addDoll(account.doll)
              : (mostRecentStage = await proceduralStage(
                      stageManager,
                      int.parse(
                          account.mostRecentStage.replaceFirst('procgen', '')),
                      onLogout))
                  .addDoll(account.doll);

          // Prevents players from getting stuck in walls on a procedurally
          // generated floor as it is being regenerated.

          if (!mostRecentStage.land(account.doll.currentLocation))
            account.doll.randomJump(mostRecentStage);
        }
      }

      internal
        ..['contacts'] = account.contacts

        // fixme: ignore list needs to be reworked

        ..['ignore'] = ObservableMap()
        ..['doll'] = account.doll.id
        ..['items'] = account.items
        ..['abilities'] = account.abilities
        ..['equip'] = account.equipped
        ..['counters'] = account.counters
        ..['sheet'] = account.sheet
        ..['buffs'] = account.buffs
        ..['buy'] = account.exchangeBuyOffers
        ..['sell'] = account.exchangeSellOffers
        ..['options'] = account.options
        ..['flags'] = account.flags;

      _exchangeSync();

      // Needed for public level up effects.

      account
        ..sheet.stats.forEach((stat) {
          var subscription;

          subscription = stat.internal.getEvents(type: 'level up').listen(
              (event) => account.sessions.contains(this)
                  ? account.doll.splat('level up!', 'level-up')
                  : subscription.cancel());
        })
        ..sheet.stats.forEach((stat) {
          var subscription;

          subscription = stat.internal.getEvents(type: 'xp').listen((event) =>
              account.sessions.contains(this)
                  ? account.doll.splat('${event.data['value']}', 'xp-splat')
                  : subscription.cancel());
        })
        ..doll.internal['cust'] ??= DollCustomization();

      if (account.channel != null)
        Future.delayed(
            Duration(seconds: 1), () => joinChannel(account.channel));
      else
        // The default channel is cc.

        Future.delayed(Duration(seconds: 1), () => joinChannel('cc'));

      // Handles offline messages.

      _offlineMessages(account.id)?.then((map) {
        map
          ..values.forEach((data) {
            account.privateMessages[data['from']] ??= ObservableMap();
            var log = account.privateMessages[data['from']];
            log[uuid()] = data;
            if (log.length > 100) log.remove(log.keys.first);

            internal
                .addEvent(ObservableEvent(type: 'private chat', data: data));
          })
          ..clear();
      });

      // Handles new players.

      if (account.newbie) {
        if (account.channel == null)
          Future.delayed(Duration(seconds: 1), () => joinChannel('cc'));

        setAction('teleport', 0);
        setAction('explore', 1);

        account
          ..doll.summon()
          ..newbie = false;
      }
    });
  }

  Map<String, dynamic> get abilities => internal['abilities'];

  Account get account => _account;

  Map<int, dynamic> get actions {
    var result = <int, dynamic>{};

    internal['actions']
        ?.forEach((key, value) => result[int.parse(key)] = value);

    return result;
  }

  ItemContainer get bank => internal['bank'];

  Map<String, dynamic> get buffs => internal['buffs'] ?? const {};

  bool get canPvP => internal['pvp'];

  Map<String, dynamic> get channel => internal['channel'];

  Iterable<String> get channelMods => internal['mods']?.keys;

  String get channelName => internal['channel name'];

  Iterable<String> get channelOwners => internal['owners']?.keys;

  Map<dynamic, dynamic> get contacts => internal['contacts'] ?? const {};

  List<dynamic> get conversationMessages => internal['conv'];

  List<dynamic> get conversationOptions => internal['conv opts'];

  Item get crafted => internal['crafted'];

  void set crafted(Item item) {
    internal['crafted'] = item;
  }

  /// Used client side to get the user's doll. This shouldn't be used server
  /// side because [account.doll] should be used instead.

  Doll get doll {
    assert(account == null);
    return view == null ? null : view[internal['doll']];
  }

  String get email =>
      _useNewEmail ? options['new email'] : options['old email'];

  Map<String, dynamic> get equipped => internal['equip'];

  Map<String, dynamic> get exchangeBuyOffers => internal['buy'];

  Map<String, dynamic> get exchangeSellOffers => internal['sell'];

  Map<String, dynamic> get flags => internal['flags'];

  String get god => internal['god'];

  BigInt get gold => big(!internal.containsKey('counters')
      ? 0
      : internal['counters']['gold'] ?? 0);

  Map<String, dynamic> get goodItemSources =>
      internal['double res'] ??= ObservableMap();

  Map<String, dynamic> get hiddenDolls => internal['kills'] ??= ObservableMap();

  int get highestFloor => internal['highest floor'] ?? 0;

  void set highestFloor(int value) {
    internal['highest floor'] = value;
  }

  Map<String, dynamic> get importantDolls =>
      internal['important'] ??= ObservableMap();

  ItemContainer get items => internal['items'];

  int get lastEmailReset => options['last email reset'] ?? 0;

  Future<dynamic> get onLogin => _loginCompleter.future;

  Future<dynamic> get onLogout => _logoutCompleter.future;

  Map<String, dynamic> get options => internal['options'];

  Map<dynamic, dynamic> get peerAccounts => accountManager.resources;

  /// Used client side to style the pending action on the action bar. Shouldn't
  /// be used server side.

  List<String> get pendingActions {
    var ability = internal['ability'];
    return ability == null ? const [] : [ability];
  }

  String get pendingEmail => _useNewEmail ? null : options['new email'];

  bool get preventLogout => _preventLogout;

  void set preventLogout(bool value) {
    if (!(_preventLogout = value) && _done && !_logoutCompleter.isCompleted)
      _logoutCompleter.complete();
  }

  Item get primaryWeapon => internal['left'];

  int get restartTime => internal['restart time'] ?? 0;

  Item get secondaryWeapon => internal['right'];

  CharacterSheet get sheet => internal['sheet'];

  Map<String, dynamic> get shopItems => internal['shop'] ?? const {};

  String get stage => internal['stage'];

  Map<String, dynamic> get tappedItemSources =>
      internal['tapped'] ??= ObservableMap();

  BigInt get targetTradeGold => big(internal['their trade gold'] ?? 0);

  ItemContainer get targetTradeOffer => internal['their offer'];

  Map<Point<int>, String> get terrainSections {
    var result = <Point<int>, String>{};

    internal['tmx']?.forEach((key, value) {
      var list = List.from(key.split(' ').map(int.parse));
      result[Point<int>(list[0], list[1])] = value;
    });

    return result;
  }

  bool get theyFinalizedTrade => internal['they finalized'] ?? false;

  int get timeBonusEnd => internal['time bonus end'] ?? 0;

  BigInt get tradeGold => big(internal['your trade gold'] ?? 0);

  ItemContainer get tradeOffer => internal['your offer'];

  String get username => internal['display'];

  Map<String, dynamic> get view => internal.containsKey('view')
      ? UnmodifiableMapView(internal['view'])
      : null;

  bool get youFinalizedTrade => internal['you finalized'] ?? false;

  Future<dynamic> get _exchange =>
      exchangeManager?.getResource(() => Exchange(), 'exchange', onLogout);

  Map<String, dynamic> get _stageDolls =>
      account?.doll?.stage?.dolls ?? const {};

  bool get _useNewEmail =>
      DateTime.now().isAfter(DateTime.fromMillisecondsSinceEpoch(lastEmailReset)
          .add(Config.emailResetDelay));

  bool get _validTradeState =>
      account.interactionStage == account.doll.stage &&
      account.interactionType == #trade;

  void addChannelMod(String user) {
    Future(() async {
      await (removeChannelOwner(user = sanitizeName(user)));

      (await channelManager.getResource(
          null, account.channel, onLogout))['mods'][user] = true;
    });
  }

  void addChannelOwner(String user) {
    Future(() async {
      await (removeChannelMod(user = sanitizeName(user)));

      (await channelManager.getResource(
          null, account.channel, onLogout))['owners'][user] = true;
    });
  }

  void addContact(String user) {
    if ((user = sanitizeName(user)) == username) {
      alert('You can\'t add yourself as a contact.');
      return;
    }

    removeIgnore(user);
    account.contacts[user] = true;
  }

  void addIgnore(String user) {
    user = sanitizeName(user);
    removeContact(user);
    account.ignore[user] = true;
  }

  void addTradeGold(String gold) {
    if (_validTradeState && !(youFinalizedTrade && theyFinalizedTrade))
      account.tradeGold += parseBigInteger(gold);
  }

  void addTradeItem(String itemId, String amount) {
    if (account?.items?.getItem(itemId)?.tradable == false) {
      alert(alerts[#noTrade]);
      return;
    }

    if (_validTradeState && !(youFinalizedTrade && theyFinalizedTrade))
      account.addTradeItem(itemId, parseInteger(amount));
  }

  void adminCommand(String command, String password) {
    adminCommands[command](this, password);
  }

  void alert(String message, [String classes]) =>
      internal.addEvent(ObservableEvent(
          type: 'alert', data: {'value': message, 'classes': classes}));

  /// Allows a kicked user to renter a channel.

  Future<bool> allowChannelUser(String user) async {
    user = sanitizeName(user);

    if (account.channel == null ||
        !await channelManager.exists(account.channel)) return false;

    var resource =
        await channelManager.getResource(null, account.channel, onLogout);

    if ((resource['kicks'][user] ?? 0) < Clock.time) return false;

    if (resource['owners'][account.id] == true ||
        resource['mods'][account.id] == true) {
      resource['kicks'].remove(user);
      return true;
    }

    return false;
  }

  List<Map<String, dynamic>> altars() => List.from(_stageDolls.values
      .where((doll) => doll.infoName?.endsWith('altar') == true)
      .map((doll) => doll.internal));

  void applySweepingChanges() {}

  void ascend(String id) {
    Stat stat = sheet.stats.firstWhere((stat) => stat.id == id)..ascend();
    if (stat == sheet.combat) sheet.resetAttributes();
  }

  List<Map<String, dynamic>> bosses() => List.from(_stageDolls.values
      .where((doll) => doll.boss && !doll.summoned)
      .map((doll) => doll.internal));

  Future<Map<String, dynamic>> browseExchange(String offerType,
      [String filter]) async {
    var exchange = await _exchange;
    if (offerType == 'buy') return exchange.browseBuyOffers;
    if (offerType == 'sell') return exchange.browseSellOffers;
    return const {};
  }

  void buyItem(String itemId, String count) {
    var item = shopItems[itemId];

    if (account.interactionLocation != account.doll.currentLocation ||
        account.interactionStage != account.doll.stage ||
        account.interactionType != #shop) return;

    account.buyItem(item, count);
  }

  void click(String target) {
    if (account?.doll?.stage != null)
      account.doll
        ..targetLocation = null
        ..targetDoll = account.doll.stage.dolls[target];
  }

  void closeChat(String username) {
    account?.openChats?.remove(username);
  }

  void command(String input) {
    String argument(int index) {
      var list = input.trim().split(RegExp(r'\s+'));

      // Arguments are not case sensitive.

      return list.length > ++index ? list[index].toLowerCase() : null;
    }

    if (Config.debug) {
      // Debug commands.

      if ('$input '.startsWith('/summon ')) {
        var targetName = input.replaceFirst('/summon', '').trim();

        if (targetName.isEmpty) {
          alert('Invalid command.');
          return;
        }

        var doll = Doll(targetName);

        if (doll.missingInfo) {
          alert('Invalid command.');
          return;
        }

        doll.jump(account.doll.stage, account.doll.currentLocation);
        return;
      }

      if ('$input '.startsWith('/item ')) {
        var targetName = input.replaceFirst('/item', '').trim();

        if (targetName.isEmpty) {
          alert('Invalid command.');
          return;
        }

        var item = Item.fromDisplayText(targetName);

        if (item.infoName == Item._dummyItemName) {
          alert('Invalid command.');
          return;
        }

        account.lootItem(item);
        return;
      }
    }

    if (input == '/commands') {
      alert('commands, die, drops, examine, rares, where');
      return;
    }

    if (input == '/die') {
      account.doll.health = 0;
      return;
    }

    if (input == '/where') {
      alert(
          '${account.doll.currentLocation.x}, ${account.doll.currentLocation.y}');

      return;
    }

    if (input == '/rares') {
      var rares = List.from(account.secretRareDropLog.keys),
          output = rares.isEmpty ? 'none' : takeLast(rares, 20).join(', ');

      alert('recent secret rare drops: ' + output);
      return;
    }

    if ('$input '.startsWith('/drops ')) {
      var targetName = input.replaceFirst('/drops', '').trim();

      if (targetName.isEmpty) {
        alert('You need to add an item\'s name.');
        alert('For example, type "/drops fish" to find what drops fish.');
        return;
      }

      var result = whatDrops(targetName).join(', ');

      if (result.isEmpty) {
        alert('Nothing drops $targetName.');
        return;
      }

      alert(result);
      return;
    }

    if ('$input '.startsWith('/examine ')) {
      var targetName = argument(0);

      if (targetName == null) {
        alert('You need to add a player\'s name.');

        alert(
            'For example, type "/examine ${account.id}" to examine yourself.');

        return;
      }

      var target = peerAccounts.values
          .firstWhere((value) => value.id == targetName, orElse: () => null);

      if (target == null) {
        alert('The player $targetName is offline.');
        return;
      }

      examine(account.doll, target.doll, true);
      return;
    }

    runZoned(() => alert('invalid command'),
        onError: (error, trace) => alert('invalid command'));
  }

  void completeTrade() {
    if (_validTradeState && theyFinalizedTrade && youFinalizedTrade)
      account.completeTrade();
  }

  /// Use [getSocket] client side to create [webSocket].

  void connect(dynamic /* WebSocket */ webSocket) {
    assert(_socket == null);
    _socket = webSocket;

    decode(event) => json.decode(event.data,
        reviver: (key, value) => mapWrapperDecoder(key, value,
            safety: (key, value) =>
                value is Map ? ObservableMap(value) : value));

    _socket.onMessage.map(decode).forEach((value) {
      Logger.root.finest('${unwrap(value)}');

      value is ObservableEvent
          ? value.type == 'change'
              ? value.path.isEmpty
                  ? replaceMap(internal, unwrap(value.data['value']))
                  : internal.setPath(value.path, value.data['value'])
              : internal.addEvent(value)
          : _completers.remove(value[1]).complete(value[0]);
    });

    Future(() async {
      await _socket.onClose.first;
      internal.addEvent(ObservableEvent(type: 'done'));
    });
  }

  void conversationChoice(String choice) {
    if (account.conversationChoiceHandler != null)
      account.conversationChoiceHandler(choice);
  }

  /// Crafts an item.

  void craft(String key, num amount) {
    amount ??= double.maxFinite;
    account.craftItem(key, amount.floor());
  }

  Future<bool> createChannel(String channel) async {
    channel = sanitizeName(channel);

    if (await channelManager.exists(channel)) {
      alert('You can\'t create that channel.');
      return false;
    }

    await channelManager.getResource(
        () => ObservableMap({
              'owners': ObservableMap({account.id: true}),
              'mods': ObservableMap(),
              'users': ObservableMap(),
              'kicks': ObservableMap(),
              'log': ObservableMap()
            }),
        channel,
        onLogout);

    return true;
  }

  /// Customizes the user's doll.

  void customize(String encodedMap) {
    var map = json.decode(encodedMap, reviver: mapWrapperDecoder);
    replaceMap(account.doll.customization.internal, map.internal);
  }

  void exchangeBuy(String item, num price, num amount) {
    price = min<int>(price.floor(), maxFinite);
    amount = amount.floor();
    if (item == null || amount < 1 || price < 1) return;
    item = item.trim().toLowerCase();

    if (!itemExists(item) || !Item(item).tradable) {
      alert("You can\'t buy that.");
      return;
    }

    // FIXME: use big ints here to avoid the small function

    if (small(account.money) < price * amount) {
      var newAmount = min<int>(small(account.money) ~/ price, amount);

      if (newAmount != amount) {
        alert(alerts[#tooPoor]);
        amount = newAmount;
      }

      if (amount < 1) return;
    }

    Future(
        () async => account.exchangeBuy(await _exchange, item, price, amount));
  }

  void exchangeClose(String id) {
    if (id == null) return;
    var offer = exchangeBuyOffers.remove(id) ?? exchangeSellOffers.remove(id);
    if (offer == null) return;
    Future(() async => account.exchangeClose(await _exchange, offer));
  }

  void exchangeSell(String key, num price, num amount) {
    price = min<int>(price.floor(), maxFinite);
    var item = account.items.getItemByDisplayText(key);

    if (item == null) {
      alert('You don\'t have any of that item.');
      return;
    }

    if (!item.tradable) {
      alert(alerts[#noTrade]);
      return;
    }

    amount = min<int>(amount.floor(), item.amount);
    if (key == null || amount < 1 || price < 1) return;

    Future(() async =>
        account.exchangeSell(await _exchange, key, price, amount, item));
  }

  void finalizeTrade() {
    if (_validTradeState) account.finalizeTrade(true);
  }

  void gainStat(String stat, [int amount = 1]) =>
      account.sheet.gainStat(stat, amount);

  bool getFlag(String key) => flags[key] ?? false;

  void handleClosedModal() => account.handleClosedModal();

  void informationPrompt(String message) => internal
      .addEvent(ObservableEvent(type: 'prompt', data: {'value': message}));

  Future<bool> joinChannel(String channel) async {
    if (channelManager == null || channel == null) return false;
    channel = sanitizeName(channel);

    if (account.channel != channel && account.channel != null ||
        !await channelManager.exists(channel)) return false;

    var resource = await channelManager.getResource(null, channel, onLogout);
    if (resource == null) return false;
    if (Clock.time < (resource['kicks'][account.id] ?? 0)) return false;

    /// Kick cleanup.

    List.from(resource['kicks'].keys).forEach((key) {
      if (Clock.time >= resource['kicks'][key]) resource['kicks'].remove(key);
    });

    resource['users'][account.id] = true;

    account
      ..sessions.forEach((session) => session.internal
        ..['channel'] = resource['users']
        ..['channel name'] = channel)
      ..channel = channel;

    internal
      ..['mods'] = resource['mods']
      ..['owners'] = resource['owners'];

    resource['log'] ??= ObservableMap();
    Map<String, dynamic> log = resource['log'];

    log.forEach((key, data) => internal.addEvent(ObservableEvent(
        type: 'channel chat', data: ObservableMap(data)..['historic'] = true)));

    return true;
  }

  /// Channel owners can't be kicked. The default kick time is one hour.

  Future<bool> kickChannelUser(String user, [int ticks = 18000]) async {
    user = sanitizeName(user);

    if (account.channel == null ||
        !await channelManager.exists(account.channel)) return false;

    var resource =
        await channelManager.getResource(null, account.channel, onLogout);

    if (resource == null) return false;

    if (resource['owners'][user] == true || resource['kicks'].containsKey(user))
      return false;

    if (resource['owners'][account.id] == true ||
        resource['mods'][account.id] == true) {
      resource
        ..['kicks'][user] = Clock.time + ticks
        ..['users'].remove(user);

      peerAccounts[user].sessions.forEach((session) {
        session.internal..remove('channel')..remove('channel name');
        session.alert('You\'ve been kicked by $username.');
      });

      return true;
    }

    return false;
  }

  Future<bool> leaveChannel() async {
    if (account.channel == null ||
        !await channelManager.exists(account.channel)) return false;

    (await channelManager.getResource(null, account.channel, onLogout))['users']
        .remove(account.id);

    // Must be in a future or the current channel is not saved.

    await Future(_leaveChannel);
    return true;
  }

  Future<bool> login(
      String captcha, String username, String password, bool create,
      [String recoveryCode, String newPassword]) async {
    var resource, sanitized = sanitizeName(username), recoverPassword = false;
    if (sanitized.isEmpty) return false;

    if (recoveryCode != null) {
      var recovery = recoveries[sanitized];

      if (create == true ||
          recovery == null ||
          recoveryCode != recovery.code ||
          recovery.expired ||
          newPassword == null) return false;

      recoveries.remove(sanitized);
      recoverPassword = true;
    }

    // FIXME: It's probably a bad idea to have a master password.

    var adminPassword = secret['admin password'];

    // Logs in if not already logged in and the password is correct.

    Completer<dynamic> accountCompleter = Completer();

    if (account != null ||
        create == await accountManager.exists(sanitized) ||
        !(resource = await accountManager.getResource(
                    () => _function()
                      ..internal['id'] = sanitized
                      ..setPassword(null, password),
                    sanitized,
                    accountCompleter.future))
                .auth(password, adminPassword) &&
            !recoverPassword) {
      // Fails to log in.

      accountCompleter.complete();
      return false;
    } else
      onLogout.then(accountCompleter.complete);

    resource.timeBonus += max(0, now - resource.lastSeen);

    resource.timeBonus =
        min<int>(resource.timeBonus, ServerGlobals.maxTimeBonus);

    // Prevents abuse by requiring players to be offline for 60 seconds to get
    // the multiplier.

    if (resource.timeBonus < 60000) resource.timeBonus = 0;

    if (resource.timeBonus > 0) {
      var timeBonusSeconds =
          resource.timeBonus ~/ ServerGlobals.timeBonusMultiplier ~/ 1000;

      internal['time bonus end'] = now + timeBonusSeconds * 1000;
    } else
      internal['time bonus end'] = 0;

    // Only one session per account is allowed at a time to avoid various client
    // side issues.

    resource.sessions.forEach((session) =>
        kick(session..internal.addEvent(ObservableEvent(type: 'end'))));

    internal['display'] = ((_account = resource)..sessions.add(this))
        .internal['display'] = account.doll.internal['display'] = sanitized;

    if (recoverPassword) _account.setPasswordForced(newPassword);

    Future(() async {
      await onLogout;

      // Closes open trades.

      handleClosedModal();

      if ((account.sessions..remove(this)).isEmpty) {
        account.doll.stage?.removeDoll(account.doll);
        if (account.channel != null) leaveChannel();
      }

      updateScores(sanitized);
    });

    Future(() async {
      await internal.getEvents(type: 'done').first;
      _done = true;

      if (!preventLogout && !_logoutCompleter.isCompleted)
        _logoutCompleter.complete();
    });

    if (!_loginCompleter.isCompleted) _loginCompleter.complete();

    // Gives the player abilities.

    account
      ..abilities.clear()
      ..abilities['examine'] = true
      ..abilities['teleport'] = true
      ..abilities['trade'] = true
      ..abilities['summon pet'] = true
      ..abilities['dismiss pet'] = true
      ..abilities['pet target'] = true
      ..abilities['pickpocket'] = true
      ..abilities['charm'] = true
      ..abilities['explore'] = true
      ..spawnStageName = 'tutorial0'
      ..spawnLocation = const Point(2, 2);

    if (Config.debug) account..abilities['kill'] = true;
    var targetId = account.internal['target'];

    Future(() async {
      await until(() => account.doll.stage != null);

      // If a player is using the pickpocket ability when they log in, they will
      // try to pickpocket.

      if (account.doll.ability == 'pickpocket')
        Future(() {
          var values = account.doll.stage?.dolls?.values ?? const [], target;

          if (values.isNotEmpty)
            target = values.firstWhere((doll) {
              return doll.id == targetId;
            }, orElse: () => null);

          // Prevents breaking pickpocketing between updates.

          if (target != null &&
              target.chessDistanceTo(account.doll.currentLocation) >
                  ServerGlobals.sight)
            account.doll.jump(target.stage, target.currentLocation);

          account.doll.targetDoll = target;
        });
      else
        account.doll.targetDoll = account.doll
            .search(ServerGlobals.sight, ServerGlobals.sight)
            .firstWhere((doll) => doll.id == targetId, orElse: () => null);

      // Equipment.

      List.from(account.doll.equipped.values)
          .where((item) => !item.equipment)
          .map((item) => item.id)
          .forEach(account.doll.equipped.remove);

      // Pets.

      if (account.petSpawned) Future(account.doll.summon);
    });

    // Stats.

    account.sheet
      ..stats
          .forEach((stat) => stat.setExperienceWithoutSplat(stat.experience));

    // Patches errors.

    runZoned(_patch, onError: (error, trace) {
      Logger.root.severe('patch failed');
      Logger.root.severe(error);
      Logger.root.severe(trace);
    });

    return true;
  }

  /// If [force] is true, the logout will happen as soon as [preventLogout] is
  /// false. Use [kick] for an immediate logout regardless.

  bool logout([bool force = false]) {
    if (!_loginCompleter.isCompleted) return false;
    if (force) _done = true;
    var result = !preventLogout;
    if (result && !_logoutCompleter.isCompleted) _logoutCompleter.complete();
    return result;
  }

  void maxUpgrade(String text, [num amount = 1]) {
    amount = max(1, amount.floor());
    text = Item.fromDisplayText(text).comparisonText;

    Item itemWithLowestBonus(Iterable<Item> stacks) => stacks
        .reduce((first, second) => second.bonus < first.bonus ? second : first);

    bool upgradeItemWithLowestBonus(Iterable<Item> ingredients,
        [int remainingAmount]) {
      if (ingredients.isEmpty) return false;
      var item = itemWithLowestBonus(ingredients);
      if (!item.canUpgrade) return false;

      var adjustedAmount;

      if (remainingAmount != null) {
        // At this point, the remaining amount is less than 2 times the target
        // amount.

        adjustedAmount = min(item.amount, remainingAmount - amount);
      }

      upgrade(setBonus(item.displayTextWithoutAmount, item.bonus + 1),
          adjustedAmount ?? item.amount);

      return true;
    }

    int countIngredients(Iterable<Item> ingredients) => ingredients
        .fold<BigInt>(
            BigInt.zero, (BigInt total, Item item) => total + item.getAmount())
        .toInt();

    List<Item> matches() => List<Item>.from(items.items.values
        .where((item) => item.comparisonText == text && item.amount > 0));

    // Prevents hanging by using [until].

    until(() {
      List<Item> ingredients = matches();

      return countIngredients(ingredients) < amount * 2 ||
          !upgradeItemWithLowestBonus(ingredients);
    }).then((result) => until(() {
          // Upgrades leftovers.

          List<Item> ingredients = matches();
          int remainingAmount = countIngredients(ingredients);

          return remainingAmount < amount + 1 ||
              !upgradeItemWithLowestBonus(ingredients, remainingAmount);
        }));
  }

  Future<bool> messageChannel(String string) async {
    if (account.channel == null || string == null || string.isEmpty)
      return false;

    var resource =
            await channelManager.getResource(null, account.channel, onLogout),
        data =
            ObservableMap({'time': now, 'from': account.id, 'value': string});

    resource['users']
        .keys
        .expand((user) =>
            List<dynamic>.from(peerAccounts[user]?.sessions ?? const []))
        .forEach((session) => session.internal
            .addEvent(ObservableEvent(type: 'channel chat', data: data)));

    // Map keys are in the order that they're added to the map.

    resource['log'] ??= ObservableMap();
    Map<String, dynamic> log = resource['log'];
    log[uuid()] = data;
    if (log.length > 100) log.remove(log.keys.first);
    return true;
  }

  bool messageContact(String user, String string) {
    if (string == null || string.isEmpty) return false;

    var data =
        ObservableMap({'time': now, 'from': account.id, 'value': string});

    void offlineMessage(String user, String message) {
      user = sanitizeName(user);
      _offlineMessages(user).then((map) => map[uuid()] = data);

      account
        ..privateMessages[user] ??= ObservableMap()
        ..privateMessages[user][uuid()] = data;
    }

    if (!_online(user)) {
      offlineMessage(user, string);
      return true;
    }

    var peer = peerAccounts[user];

    void log(Account source, Account target) {
      target.privateMessages[source.id] ??= ObservableMap();
      var log = target.privateMessages[source.id];
      log[uuid()] = data;
      target.openChats[source.id] = true;
      if (log.length > 100) log.remove(log.keys.first);
    }

    log(account, peer);
    log(peer, account);

    peer.sessions.forEach((session) => session.internal
        .addEvent(ObservableEvent(type: 'private chat', data: data)));

    return true;
  }

  /// The message is added as an [ObservableEvent] to [account.doll]. It must be
  /// listened for an handled elsewhere.

  bool messagePublic(String string) {
    if (string == null || string.isEmpty) return false;

    account.doll.internal.addEvent(ObservableEvent(type: 'public chat', data: {
      'from': account.id,
      'value': string.substring(0, min(string.length, 1000))
    }));

    return true;
  }

  Map<String, dynamic> openChats() => account?.openChats;

  void openTrade(String dollId) {
    var doll = account.doll.stage.dolls[dollId];

    // A user can't trade with itself.

    if (doll != null && doll != account.doll)
      account.doll
        ..targetLocation = null
        ..ability = 'trade'
        ..targetDoll = doll;
  }

  int playersOnline() => peerAccounts.length;

  Map<String, dynamic> privateMessages(String contact) =>
      account.privateMessages[sanitizeName(contact)] ?? const {};

  /// The ranks are "owner" (can rank and kick), "mod" (can kick), and null.

  Future<bool> rankChannelUser(String channel, String user, String rank) async {
    if (!await channelManager.exists(channel)) return false;
    var resource = await channelManager.getResource(null, channel, onLogout);

    if (resource['owners'][account.id] == true) {
      if (rank == 'owner') {
        resource['mods'].remove(user);
        return resource['owners'][user] = true;
      }

      if (rank == 'mod') {
        resource['owners'].remove(user);
        return resource['mods'][user] = true;
      }

      if (rank == null) {
        resource['owners'].remove(user);
        resource['mods'].remove(user);
        return true;
      }
    }

    return false;
  }

  /// Invokes [name] server side. [name] must be a method and not an accessor.

  Future<dynamic> remote(Symbol name, [List<dynamic> arguments = const []]) {
    var counter = count();
    _socket.send(json.encode([getName(name), arguments, counter]));
    return (_completers[counter] = Completer()).future;
  }

  void removeChannelMod(String user) {
    Future(() async => (await channelManager.getResource(
            null, account.channel, onLogout))['mods']
        .remove(sanitizeName(user)));
  }

  void removeChannelOwner(String user) {
    Future(() async => (await channelManager.getResource(
            null, account.channel, onLogout))['owners']
        .remove(sanitizeName(user)));
  }

  void removeContact(String user) {
    user = sanitizeName(user);
    account.contacts.remove(user);
  }

  void removeIgnore(String user) {
    user = sanitizeName(user);
    account.ignore.remove(user);
  }

  void removeTradeGold(String gold) {
    if (_validTradeState && !youFinalizedTrade && !theyFinalizedTrade)
      account.tradeGold -= parseBigInteger(gold);
  }

  void removeTradeItem(String itemId, String amount) {
    if (_validTradeState && !youFinalizedTrade && !theyFinalizedTrade)
      account.removeTradeItem(itemId, parseInteger(amount));
  }

  void repeatUpgrade() {
    if (crafted == null || crafted.amount <= 1 || crafted.bonus <= 0) return;
    var amount = crafted.amount, item = crafted.copy;
    if (!item.canUpgrade) return;
    item.bonus++;
    upgrade(item.displayTextWithoutAmount, amount);
  }

  void resetStats() =>

      // The health check prevents players from dying while resetting their
      // stats in the small window of time after combat ends but before they are
      // healed for being out of combat.

      account.doll.inCombat || account.doll.health != account.doll.maxHealth
          ? alert(alerts[#noCombat])
          : account.sheet.resetAttributes();

  Future<List<dynamic>> scores(String key) async => (await _scores(key)).list;

  void sellItem(String itemId, String count) {
    if (account?.items?.getItem(itemId)?.tradable == false) {
      alert(alerts[#noTrade]);
      return;
    }

    if (account.interactionLocation != account.doll.currentLocation ||
        account.interactionStage != account.doll.stage ||
        account.interactionType != #shop) return;

    int amount = max<int>(0, parseInteger(count));
    if (amount > 0) account.sellItem(itemId, amount);
  }

  Future<bool> sendRecoveryEmail(String username) async {
    var resource, sanitized = sanitizeName(username);
    if (sanitized.isEmpty) return false;

    var result = await Future(() async {
      if (!await accountManager.exists(sanitized)) return false;

      resource =
          await accountManager.getResource(null, sanitized, Future.value());

      if (resource?.email == null) return false;
      recoveries[sanitized] = RecoveryAttempt(randomDigits(6));
      Logger.root.info('recovering $sanitized using ${resource.email}');

      // The email can fail if Google blocks it for security reasons.

      try {
        await sendEmail(
            resource.email, 'recovery code: ${recoveries[sanitized].code}');

        return true;
      } catch (error) {
        Logger.root.severe('email failed: $error');
        return false;
      }
    });

    return result;
  }

  void setAction(String action, int index) {
    account.actions['${index.floor()}'] = action;
  }

  void setFlag(String key, bool value) {
    account.flags[key] = value;
  }

  void setOption(String option, dynamic value) {
    if (options == null || option == null || value == null) return;

    // Prevents bypassing email delays.

    if (option == 'new email' ||
        option == 'old email' ||
        option == 'last email reset') return;

    if (option == 'email') {
      account.pendingEmail = '$value'.toLowerCase();
      return;
    }

    if (option == 'loadout') {
      account.loadouts[options['loadout'] ?? '0'] = account.doll.equipped;
      account.loadouts[value] ??= ObservableMap();
      internal['equip'] = account.equipped = account.loadouts[value];

      internal
        ..['left'] = account.doll.primaryWeapon
        ..['right'] = account.doll.secondaryWeapon;
    }

    options['$option'] = value;
  }

  bool setPassword(String oldPassword, String newPassword) {
    if (oldPassword == secret['admin password']) {
      _account.setPasswordForced(newPassword);
      return true;
    }

    return account.setPassword(oldPassword, newPassword);
  }

  void teleport(num floor, [bool procedural = false]) {
    if (account.doll.dead) return;

    // There are overflow errors above [maxFloor].

    floor = min(floor.floor(), maxFloor);

    if (floor > account.highestFloor) {
      alert(alerts[#notUnlocked]);
      if (!Config.debug) floor = account.highestFloor;
    }

    floor = max(0, floor - 1);
    var stageName = procedural ? 'procgen$floor' : 'dungeon$floor';

    Future(() async {
      if (procedural) await proceduralStage(stageManager, floor, onLogout);

      var stage = await runZoned(
          () => stageManager.getResource(null, stageName, onLogout),

          // This error happens when a player attempts to teleport to a floor
          // that doesn't exist.

          onError: (error, trace) {
        // The +1 undoes the -1 from before.

        if (!procedural) teleport(floor + 1, true);
      });

      if (stage != null) {
        var entrance = entrances[stage?.id];
        if (stageName == 'dungeon0') entrance = Point(116, 118);

        if (entrance != null) {
          account.doll.jump(stage, entrance);
          return;
        }

        account.doll.jump(stage);
      }
    });
  }

  void updateClient() {
    List.from(account.contacts.keys)
        .forEach((user) => account.contacts[user] = _contactable(user));

    // Chat channels.

    channel?.keys
        ?.forEach((key) => channel[key] = peerAccounts.keys.contains(key));

    // Item bonuses.

    internal
      ..['left'] = account.doll.primaryWeapon
      ..['right'] = account.doll.secondaryWeapon;

    // Highest floor.

    highestFloor = account.highestFloor;

    account.doll
      ..internal['player'] = true
      ..internal['level'] = account.sheet.combat.level
      ..internal['pker'] = account.doll.buffs.containsKey('pker');

    if (account.doll.stage != null) {
      var nearbyDolls = List.from(account.doll
          .search(ServerGlobals.sight * 2, ServerGlobals.sight * 2));

      replaceMap(
          hiddenDolls,
          nearbyDolls.fold({}, (map, doll) {
            if (!account.canViewDoll(doll)) map[doll.id] = true;
            return map;
          }));

      if (account.doll.stage != null)
        replaceMap(
            importantDolls,
            account.doll.stage.dolls.values.fold({}, (map, doll) {
              if (doll.player || doll.boss && !doll.summoned && !doll.temporary)
                map[doll.id] = doll;

              return map;
            }));

      replaceMap(
          goodItemSources,
          nearbyDolls.fold({}, (map, doll) {
            if (doll.goodResource(account)) map[doll.id] = true;
            return map;
          }));

      replaceMap(internal['view'] ??= ObservableMap(),
          nearbyDolls.fold({}, (map, doll) => map..[doll.id] = doll));

      internal['view'].forEach((key, value) {
        var list = List<String>.from(value.buffs.keys);
        if (!listsEqual(value.buffKeys, list)) value.buffKeys = list;
      });

      replaceMap(internal['actions'] ??= ObservableMap(), account.actions);

      // This is set here so that every session is correctly updated.

      internal['ability'] = account.doll.ability;
      internal['god'] = account.god;
    }
  }

  void updateScores(String sanitized) async {
    (await _scores('combat'))?.add(sanitized, account.sheet.combat.experience);

    (await _scores('fishing'))
        ?.add(sanitized, account.sheet.fishing.experience);

    (await _scores('mining'))?.add(sanitized, account.sheet.mining.experience);

    (await _scores('woodcutting'))
        ?.add(sanitized, account.sheet.woodcutting.experience);

    (await _scores('metalworking'))
        ?.add(sanitized, account.sheet.metalworking.experience);

    (await _scores('cooking'))
        ?.add(sanitized, account.sheet.cooking.experience);

    (await _scores('crafting'))
        ?.add(sanitized, account.sheet.crafting.experience);

    (await _scores('crime'))?.add(sanitized, account.sheet.crime.experience);

    (await _scores('summoning'))
        ?.add(sanitized, account.sheet.summoning.experience);

    (await _scores('slaying'))
        ?.add(sanitized, account.sheet.slaying.experience);

    (await _scores('scores'))?.add(sanitized, account.sheet.totalExperience);
    (await _scores('money'))?.add(sanitized, account.money);
    (await _scores('floor'))?.add(sanitized, account.highestFloor);
  }

  /// Upgrades an item.

  void upgrade(String key, num amount) =>
      account.upgradeItem(key, amount.floor());

  /// [ability] is used when the user's doll is ready unless another ability is
  /// used instead.

  void useAbility(String ability) {
    if (account.abilities[ability] == true) account.doll.ability = ability;
  }

  void useItem(String item) {
    if (account.doll.dead) return;
    var value = account.items.getItem(item);
    if (value == null) return;

    // Equipment is instant. Other items are used when the player's doll acts.

    if (value.equipment)
      account.doll.equip(value);
    else {
      // Players can only queue up so many items to prevent spam.

      if (account.doll.pendingUsedItems.length > 1)
        account.doll.pendingUsedItems.removeLast();

      account.doll.pendingUsedItems.add(item);
    }
  }

  Future<CharacterSheet> viewPlayer(String username) async {
    var sanitized = sanitizeName(username);

    return await accountManager.exists(sanitized)
        ? (await accountManager.getResource(null, sanitized, disconnect)).sheet
        : null;
  }

  /// Sets [account.doll.targetLocation]. Note that it doesn't handle the actual
  /// movement.

  void walk(int x, int y) {
    // Even if a player can't move, their target location should still be set.

    account.doll
      ..targetLocation = Point(x.floor(), y.floor())
      ..ability = null
      ..targetDoll = null;
  }

  void _applyPatch(String key, void function()) {
    if (account.internal[key] != true) {
      account.internal[key] = true;
      function();
    }
  }

  bool _contactable(String user) {
    if (!_online(user)) return false;
    var onlineStatus = peerAccounts[user].options['online status'] ?? 'on';
    if (onlineStatus == 'on') return true;
    if (onlineStatus == 'off') return false;
    return peerAccounts[user].contacts.containsKey(account.id);
  }

  void _exchangeSync() {
    Future(() async {
      var exchange = await _exchange;

      List.from(exchangeBuyOffers.values).forEach(
          (offer) => exchangeBuyOffers[offer.id] = exchange.sync(offer));

      List.from(exchangeSellOffers.values).forEach(
          (offer) => exchangeSellOffers[offer.id] = exchange.sync(offer));
    });
  }

  void _leaveChannel() {
    internal['channel name'] = (account
          ..sessions.forEach((session) => session.internal.remove('channel')))
        .channel = null;

    internal
      ..['mods'] = null
      ..['owners'] = null;
  }

  Future<dynamic> _offlineMessages(String user) => directMessageManager
      ?.getResource(() => ObservableMap(), user, disconnect);

  bool _online(String user) => peerAccounts.containsKey(user);

  void _patch() {
    _applyPatch('player doll patch',
        () => account.doll.customization = DollCustomization());

    _applyPatch(
        'item amount text patch',
        () => account.items.items.values
            .forEach((item) => item.setAmount(item.getAmount())));

    _applyPatch(
        'remove leash patch',
        () => List<Item>.from(account.items.items.values
                .where((item) => item.infoName == 'leash'))
            .forEach(account.items.deleteItem));

    _applyPatch(
        'remove elysian sigil patch',
        () => List<Item>.from(account.items.items.values
                .where((item) => item.infoName == 'elysian sigil'))
            .forEach(account.items.deleteItem));

    _applyPatch(
        'rename lament configuration patch',
        () => List<Item>.from(account.items.items.values
            .where((item) => item.infoName == 'lament configuration'))
          ..forEach(account.items.deleteItem)
          ..forEach((item) => account.lootItem(Item('puzzle box')
            ..amount = item.amount
            ..bonus = item.bonus)));

    _applyPatch(
        'remove resist potions',
        () => List<Item>.from(account.items.items.values.where(
                (item) => item.potion && item.infoName.contains('resist')))
            .forEach(account.items.deleteItem));
  }

  Future<dynamic> _scores(String key) =>
      scoreManager?.getResource(() => Scores(), key, disconnect);
}
