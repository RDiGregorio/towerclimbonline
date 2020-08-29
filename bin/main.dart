import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:logging/logging.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:quiver/async.dart';
import 'package:towerclimbonline/config.dart';
import 'package:towerclimbonline/content.dart';
import 'package:towerclimbonline/server.dart';
import 'package:towerclimbonline/util.dart';

// *****************************************************************************
// fixme: pet aggros when you heal a mob (need to prevent healing mobs)
// fixme: prevent players from healing monsters
// fixme: you can heal bosses to kill players afking them
// fixme: captcha wasn't working in Russia
// fixme: find a way to prevent account creation spam
// todo: split items/equip modals
// fixme: chat timestamps don't convert from time to date until refresh
// TODO: use the tick clock for all delays (including death/summoning delays)
// *****************************************************************************
// TODO: second action bar row
// TODO: ascended harambe
// TODO: have exchange offers fill if a higher tier +x item is for sale
//**********************************************************************
// TODO: privacy policy was lost in Dart 2 migration (for Play store)
// FIXME: can move while shopping, breaking interface
//**********************************************************************
// TODO: add barricades and prayer skill
// FIXME: some player image layers have the wrong dimensions
// FIXME: update.sh sometimes doesn't work (possible race condition?)
// FIXME: can lose connection to the database (cloud platform availability?)
// TODO: shoreline logic (is this needed? walls would still be jagged...)
// FIXME: trading with someone with a modal open is buggy
// TODO: proc gen shops
// TODO: give AOE abilities overlays
// TODO: eventually remove all usages of the "small" function
// TODO: big ints for item amounts, food threshold
// TODO: add a "guard" mode for pets
// FIXME: charming a human changes the human's looks
// TODO: dead trees
// FIXME: monsters don't retaliate when attacking after updates
// FIXME: shooting up 2 right 1, can't be shot back?
//**********************************************************************
// TODO: pearl dragon (resist evil)
// TODO: phoenix boss (phoenix feather drop)

void main() {
  Logger.root
    ..onRecord.listen((LogRecord record) async =>
        output('[${record.time}] ${record.message}'));

  runZoned(_main, onError: (error, trace) {
    Logger.root.severe(error);
    Logger.root.severe(trace);
  });
}

Future<dynamic> _main() async {
  // Makes sure the port is available.

  await runZoned(
      () => ServerSocket.bind(InternetAddress.anyIPv6, Config.port)
          .then((server) => server.close()),
      onError: (error, trace) => exit(0));

  Logger.root.info('* * * * * starting server * * * * *');

  // Renews certificates.

  if (Platform.isLinux) {
    renew() => Process.run('./renew.sh', const [], runInShell: true);

    var renewResult = await renew();
    Logger.root.info('renew certificate exit code: ${renewResult.exitCode}');

    if (renewResult.stderr.isNotEmpty)
      Logger.root.info(renewResult.stderr.trim());

    Timer.periodic(const Duration(days: 1), (timer) => renew());
  } else {
    Logger.root.info('unable to run shell script');
  }

  // Handles serialization.

  registerFactory(#Account, () => Account());
  registerFactory(#Scores, () => Scores());
  registerFactory(#Exchange, () => Exchange());
  registerFactory(#ExchangeOffer, () => ExchangeOffer());
  registerFactory(#ObservableEvent, () => ObservableEvent());
  registerFactory(#Session, () => Session());
  registerFactory(#Doll, () => Doll());
  registerFactory(#DollInfo, () => DollInfo());
  registerFactory(#Item, () => Item());
  registerFactory(#ItemContainer, () => ItemContainer());
  registerFactory(#CharacterSheet, () => CharacterSheet());
  registerFactory(#Stat, () => Stat());
  registerFactory(#DollCustomization, () => DollCustomization());
  registerFactory(#CustomizationLayer, () => CustomizationLayer());
  registerFactory(#Buff, () => Buff());

  Future(() async {
    var secretConfig = await secret,
        playerSpawnStageName = 'dungeon0',
        playerSpawnStage = Stage(playerSpawnStageName, 100, 100),
        playerSpawnLocation = const Point(14, 18);

    // Stages and terrain sections must have unique names.
    // [playerSpawnStage] is filled with content later in the code.

    var stages = {playerSpawnStageName: playerSpawnStage};

    // Allows procedural generation in a session.

    Future<dynamic> _proceduralStage(
        ResourceManager stageManager, int floor, Future<dynamic> future) async {
      var stageKey = 'procgen$floor',
          fullKey = stageKey + '_0_0',
          file = File('dat/$fullKey.json');

      // Tries to load the stage as a resource.

      Stage<Doll> stage =
          await stageManager.getResource(() => null, stageKey, future);

      // If that fails, tries to load the stage from the disk.

      if (stage == null && await file.exists()) {
        stage = Stage(stageKey, 100, 100);

        stage.setCollisionMap(
            fullKey, await newCollisionMap(stage, fullKey, const Point(0, 0)));

        stageManager.replace(stageKey, stage);
        return stage;
      }

      // If the stage is loaded, and was generated this month, return it.

      // FIXME: this was very buggy
      // if (stage != null && thisMonth(stage.timestamp)) return stage;

      if (stage != null) return stage;

      // Otherwise, regenerates the floor and saves it to the disk.

      Logger.root.info('generating floor $floor');
      await ProceduralGenerator().generate(floor);

      // Loads the floor from the disk.

      stage = Stage(stageKey, 100, 100);

      stage.setCollisionMap(
          fullKey,
          await newCollisionMap(stage, fullKey, const Point(0, 0)),
          const Point(0, 0));

      stageManager.replace(stageKey, stage);
      return stageManager.getResource(() => stage, stageKey, future);
    }

    Session.proceduralStage = _proceduralStage;

    var data = List.from(Directory('dat')
        .listSync()
        .map((file) => file.uri.pathSegments[1].split('.')[0])
        .where((name) =>
            !name.startsWith('procgen') && !name.startsWith('placeholder'))
        .map((name) {
      assert('_'.allMatches(name).length == 2);
      dynamic parts = List<dynamic>.from(name.split('_'));
      parts[1] = int.parse(parts[1]);
      parts[2] = int.parse(parts[2]);
      return parts;
    }));

    for (var i = 0; i < data.length; i++) {
      var key = data[i][0];
      stages[key] ??= Stage(key, 100, 100);
    }

    // Registers abilities.

    registerAbilities(stages);

    // Registers items.

    registerItems(stages);

    // Enables crafting.

    Crafting.init();

    // Registers dolls.

    registerDolls(stages);

    for (var i = 0; i < data.length; i++) {
      var stage = stages[data[i][0]],
          key = data[i].join('_'),
          offset = Point<int>(data[i][1] * 100, data[i][2] * 100);

      stage.setCollisionMap(
          key, await newCollisionMap(stage, key, offset), offset);
    }

    var accountManager = await newPostgresResourceManager('accounts'),
        channelManager = await newPostgresResourceManager('channels'),

        // Stages aren't saved.

        stageManager = newMockResourceManager(stages),
        exchangeManager = await newPostgresResourceManager('exchange'),
        scoreManager = await newPostgresResourceManager('scores'),
        directMessageManager = await newPostgresResourceManager('dm');

    // Periodically updates scores.

    Timer.periodic(
        Duration(seconds: 1),
        (timer) => accountManager.resources.forEach((key, account) {
              if (account.sessions.isNotEmpty)
                account.sessions.first.updateScores(key);
            }));

    // Handles errors.

    onError(error, trace) {
      Logger.root.severe(error);
      Logger.root.severe(trace);
    }

    host(
        Config.port,
        (socket) => Session(() {
              var account = Account(
                  Doll()..currentLocation = playerSpawnLocation,
                  DollInfo(thisCanPass: Terrain.doll),
                  playerSpawnStageName,
                  playerSpawnLocation);

              [Item('revolver')]
                ..forEach(account.lootItem)
                ..forEach(account.doll.equip);

              if (Config.debug) {
                account.lootItem(Item('level up potion', maxFinite));
                account.lootItem(Item('fish', maxFinite));

                // Elyvilon is not found in the temple.

                account.god = 'elyvilon';
              }

              return account;
            }, accountManager, channelManager, stageManager, exchangeManager,
                scoreManager, directMessageManager, socket.done),
        onError: onError);

    kill() async {
      ServerGlobals.shuttingDown = true;
      await httpServer?.close(force: true);
      await httpsServer?.close(force: true);
      ServerGlobals.sockets.forEach((socket) => socket.close());

      accountManager.resources
        ..values.expand((value) => value.sessions).forEach(kick);

      // FIXME: Shouldn't save all be done on everything?

      var attempts = 0;

      function() {
        // Waits for everything to save before restarting.

        var accounts = accountManager.resources.length,
            channels = channelManager.resources.length,
            exchange = exchangeManager.resources.length,
            scores = scoreManager.resources.length,
            messages = directMessageManager.resources.length;

        if (attempts < 10 &&
            (accounts > 0 ||
                channels > 0 ||
                exchange > 0 ||
                scores > 0 ||
                messages > 0)) {
          attempts += 1;

          Logger.root.info(
              'restarting: a $accounts, c $channels, e $exchange, s $scores, m $messages');

          Future.delayed(const Duration(seconds: 1), function);
        } else {
          Logger.root.info(
              'restarting: a $accounts, c $channels, e $exchange, s $scores, m $messages');

          Future.delayed(const Duration(seconds: 1), () => exit(0));
        }
      }

      function();
    }

    Session.secret.addAll(secretConfig);

    // Allows sending emails.

    Session.sendEmail = (String email, String text) => send(
        Message()
          ..from = 'towerclimbonline@gmail.com'
          ..recipients.add(email)
          ..subject = 'recovery code'
          ..text = text,
        gmail(secretConfig['email'], secretConfig['email password']));

    Clock.start(Duration(milliseconds: ServerGlobals.tickDelay));

    Clock.ticks.expand((time) {
      var result = [];

      result.addAll(nearbyDolls(
          accountManager.resources.values.map((account) => account.doll),
          ServerGlobals.sight * 2,
          ServerGlobals.sight * 2));

      // Shuffles the result to make dolls act in a random order.

      return result..shuffle();
    })
      ..listen((doll) => runZoned(() => doll.upkeep(), onError: onError))
      ..listen((doll) => runZoned(() => doll.act(), onError: onError))
      ..listen((doll) => runZoned(() => doll.applyEffects(), onError: onError));

    // Tracks memory.

    /*
    if (Platform.isLinux)
      Timer.periodic(Duration(minutes: 1), (timer) async {
        var memory = await availableMemory;
        Logger.root.info('memory: $memory');
      });
    */

    // Registers a command that saves everything before exiting.

    Session.adminCommands['kill'] = (Session session, String password) async {
      if (password != (await secret)['admin password']) return;

      var restartDelay = Config.debug
              ? const Duration(seconds: 1)
              : const Duration(minutes: 5),
          restartTime = DateTime.now().add(restartDelay).millisecondsSinceEpoch;

      // Warns about the server restarting.

      Metronome.periodic(const Duration(seconds: 1)).listen((time) => session
          .peerAccounts
          .forEach((id, account) => account.sessions.forEach((peerSession) =>
              peerSession.internal['restart time'] ??= restartTime)));

      Future.delayed(restartDelay, kill);
    };
  });
}
