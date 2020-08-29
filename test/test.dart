import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:test/test.dart';
import 'package:towerclimbonline/content.dart';
import 'package:towerclimbonline/util.dart';

void main() {
  var manager = newMockResourceManager();

  test('clock', () async {
    var value = 0;
    Clock.start();
    expect(Clock.time, value);
    await for (var tick in Clock.ticks.take(3)) expect(tick, value++);
  });

  test('round', () async {
    expect(round(12.345, 0), 12);
    expect(round(12.345, 1), 12.3);
    expect(round(12.345, 2), 12.34);
    expect(round(12.345, 3), 12.345);
    expect(round(12.345, 4), 12.345);
  });

  test('approach point', () async {
    var point = approachPoint(const Point(0, 0), const Point(5, 5));

    expect([point.x, point.y].map((value) => value.toStringAsFixed(3)),
        equals(const ['0.707', '0.707']));

    point = approachPoint(const Point(0, 0), const Point(5, 5), 2);

    expect([point.x, point.y].map((value) => value.toStringAsFixed(3)),
        equals(const ['1.414', '1.414']));

    point = approachPoint(const Point(1, 1), const Point(5, 5));

    expect([point.x, point.y].map((value) => value.toStringAsFixed(3)),
        equals(const ['1.707', '1.707']));

    point = approachPoint(const Point(1, 0), const Point(0, 1));

    expect([point.x, point.y].map((value) => value.toStringAsFixed(3)),
        equals(const ['0.293', '0.707']));

    expect(
        approachPoint(const Point(0, 0), const Point(2, 3))
            .distanceTo(const Point(0, 0)),
        equals(1));
  });

  test('login', () async {
    var session = Session(() => Account(Doll()), manager);
    expect(await session.login(null, 'user', 'pass', true), equals(true));
    expect(await session.logout(), equals(true));
    session = Session(() => Account(Doll()), manager);
    expect(await session.login(null, 'user', 'pass', true), equals(false));
    expect(await session.logout(), equals(false));
    session = Session(() => Account(Doll()), manager);
    expect(await session.login(null, 'userpass', '', false), equals(false));
    expect(await session.login(null, 'user', 'test', false), equals(false));
    expect(await session.login(null, 'user', 'pass', false), equals(true));
  });

  test('logout', () async {
    var session = Session(() => Account(), manager);
    expect(await session.login(null, 'user', 'pass', false), equals(true));
    session.preventLogout = true;
    expect(await session.logout(), equals(false));
    session.preventLogout = false;
    expect(await session.logout(), equals(true));
  });

  test('attack', () async {
    var stage = Stage<Doll>(null, 100, 100),
        session = Session(
            () => Account(Doll(), DollInfo()), newMockResourceManager()),
        target = Doll();

    await session.login(null, 'test', 'test', true);
    stage..addDoll(session.account.doll)..addDoll(target);
  });

  test('walk', () async {
    var session = Session(() => Account(Doll()), newMockResourceManager());

    await session.login(null, 'test', 'test', true);
    expect(session.account.id, equals('test'));

    expect(
        (Stage(null, 100, 100)..addDoll(session.account.doll))
            .search(Rectangle(0, 0, 0, 0)),
        equals([session.account.doll]));

    session.walk(2, 3);
    expect(session.account.doll.targetLocation, equals(const Point(2, 3)));
  });

  test('space', () {
    var space = Space()
      ..add(const Point(0, 0), #a)
      ..add(const Point(0, 0), #b)
      ..add(const Point(1, 1), #c);

    expect(space.search(const Rectangle(0, 0, 0, 0)), equals(const [#a, #b]));
  });

  test('encode and decode', () {
    registerFactory(#ObservableEvent, () => ObservableEvent());

    expect(
        json
            .decode(
                json.encode(ObservableEvent(), toEncodable: mapWrapperEncoder),
                reviver: mapWrapperDecoder)
            .runtimeType,
        equals(ObservableEvent));
  });

  test('resource manager', () async {
    var count = 0,
        completers = [Completer(), Completer(), Completer()],
        manager = ResourceManager(
            exists: (key) => false,
            load: (key) => null,
            save: (key, value, cleanup) {
              count++;
              cleanup();
            });

    expect(
        await manager.getResource(
            () async => const {#a: #b}, null, completers[0].future),
        equals(const {#a: #b}));

    manager.getResource(() => null, null, completers[1].future);
    completers[0].complete();
    completers[1].complete();
    expect(count, equals(1));
  });

  test('rectangle', () {
    expect(rectangleFromCenter(const Point(10, 10), 2, 2),
        equals(const Rectangle(9, 9, 2, 2)));

    expect(rectangleFromCenter(const Point(10, 10), 3, 3),
        equals(const Rectangle(8.5, 8.5, 3, 3)));
  });

  test('warm up and cool down', () async {
    var doll = Doll();
    doll.warmUp(#a, 3);
    expect(doll.warm(#a), equals(true));
    expect(doll.warm(#b), equals(false));
    doll.coolDown(2);
    expect(doll.warm(#a), equals(true));
    doll.coolDown(1);
    expect(doll.warm(#a), equals(false));
    doll.coolDown(1);
    expect(doll.warm(#a), equals(false));
  });

  test('search', () async {
    var dolls = [Doll(), Doll()];
    expect(dolls[0].search(0, 0), equals([dolls[0]]));
    Stage(null, 100, 100)..addDoll(dolls[0])..addDoll(dolls[1]);
    expect(dolls[0].search(0, 0), equals([dolls[0], dolls[1]]));
    expect(dolls[1].search(0, 0), equals([dolls[0], dolls[1]]));
  });

  test('nearby dolls', () async {
    var dolls = [Doll(), Doll()];
    expect(nearbyDolls([dolls[0]], 0, 0), equals([dolls[0]]));

    Stage(null, 100, 100)
      ..addDoll(dolls[0])
      ..addDoll(dolls[1], const Point(2, 3));

    expect(nearbyDolls([dolls[0]], 0, 0), equals([dolls[0]]));
    expect(nearbyDolls([dolls[0]], 2, 2), equals([dolls[0]]));
    expect(nearbyDolls([dolls[0]], 2, 3), equals([dolls[0], dolls[1]]));
  });

  test('grid movement and collision', () async {
    registerDollInfo('test', DollInfo(thisCanPass: Terrain.land));
    var doll = Doll('test');

    Stage(null, 3, 3)
      ..setCollisionMap(null, {
        const Point(0, 0): Terrain.land,
        const Point(0, 1): Terrain.land,
        const Point(0, 2): Terrain.land,
        const Point(1, 0): Terrain.land,
        const Point(1, 1): Terrain.water,
        const Point(1, 2): Terrain.land,
        const Point(2, 0): Terrain.land,
        const Point(2, 1): Terrain.land,
        const Point(2, 2): Terrain.land
      })
      ..addDoll(doll);

    // Doesn't dance.

    doll.gridApproach(const Point(1, 1));
    expect(doll.currentLocation, equals(const Point(0, 0)));

    // Slides right.

    doll.gridApproach(const Point(2, 2));
    expect(doll.currentLocation, equals(const Point(1, 0)));
    doll.gridApproach(const Point(2, 2));
    expect(doll.currentLocation, equals(const Point(2, 0)));

    // Slides left.

    doll.gridApproach(const Point(0, 2));
    expect(doll.currentLocation, equals(const Point(1, 0)));
    doll.gridApproach(const Point(0, 2));
    expect(doll.currentLocation, equals(const Point(0, 0)));

    // Normal walking and collision.

    doll.gridApproach(const Point(0, 2));
    expect(doll.currentLocation, equals(const Point(0, 1)));
    doll.gridApproach(const Point(2, 1));
    expect(doll.currentLocation, equals(const Point(0, 1)));
    doll.gridApproach(const Point(0, 2));
    expect(doll.currentLocation, equals(const Point(0, 2)));

    // Doesn't walk off the stage.

    doll.gridApproach(const Point(0, 3));
    expect(doll.currentLocation, equals(const Point(0, 2)));

    // Doesn't walk through corners.

    doll.gridApproach(const Point(0, 1));
    expect(doll.currentLocation, equals(const Point(0, 1)));
    doll.gridApproach(const Point(0, 2));
    expect(doll.currentLocation, equals(const Point(0, 2)));
  });

  test('stage login and logout', () async {
    var stageManager = newMockResourceManager(),
        user = Session(() => Account(Doll(), DollInfo(), 'test'),
            newMockResourceManager(), newMockResourceManager(), stageManager);

    Stage stage = await stageManager.getResource(
        () => Stage('test', 100, 100), 'test', user.onLogout);

    await user.login(null, 'user', 'test', true);

    Future(() async {
      await user.onLogin;
      expect(user.account.doll.stage, equals(stage));
      user.logout();
      await user.onLogout;
      expect(user.account.doll.stage, equals(null));

      await (user = Session(() => Account(Doll(), DollInfo(), 'test'),
              newMockResourceManager(), newMockResourceManager(), stageManager))
          .onLogin;

      expect(user.account.doll.stage, equals(stage));
    });
  });

  test('public chat', () async {
    var manager = newMockResourceManager(),
        user = Session(() => Account(Doll()), manager);

    await user.login(null, 'user', 'test', true);
    Stage(null, 100, 100).addDoll(user.account.doll);

    user
      ..account.doll.internal.getEvents(type: 'public chat').listen((event) {
        expect(event.data['from'], equals('user'));
        expect(event.data['value'], equals('a'));
      })
      ..messagePublic('a');
  });

  test('channels', () async {
    var accountManager = newMockResourceManager(),
        channelManager = newMockResourceManager(),
        user = Session(
            () => Account(Doll())..items.addItem(Item('stardust', 1000000)),
            accountManager,
            channelManager),
        contact =
            Session(() => Account(Doll()), accountManager, channelManager);

    await user.login(null, 'user', 'test', true);
    await contact.login(null, 'contact', 'test', true);
    expect(await user.createChannel('test'), equals(true));
    expect(await user.joinChannel('test'), equals(true));
    expect(await contact.joinChannel('test'), equals(true));
    user.messageChannel('hello');

    await user.internal
        .getEvents()
        .firstWhere((event) => event.data['value'] == 'hello');

    await contact.internal
        .getEvents()
        .firstWhere((event) => event.data['value'] == 'hello');

    expect(await user.kickChannelUser('contact', 0), equals(true));
    expect(await user.kickChannelUser('contact', 0), equals(false));
    expect(await contact.joinChannel('test'), equals(true));
    expect(await user.kickChannelUser('contact', 2), equals(true));
    expect(await contact.leaveChannel(), equals(true));
    expect(await contact.joinChannel('test'), equals(false));
    await Clock.ticks.first;
    expect(await contact.joinChannel('test'), equals(true));
    expect(await user.leaveChannel(), equals(true));
    expect(await user.allowChannelUser('contact'), equals(false));
    expect(await user.joinChannel('test'), equals(true));
    expect(await user.kickChannelUser('contact', 1), equals(true));
    expect(await user.allowChannelUser('contact'), equals(true));
    expect(await contact.joinChannel('test'), equals(true));
    expect(await contact.joinChannel('contact'), equals(false));
    expect(await contact.leaveChannel(), equals(true));
  });

  test('capitalize', () {
    expect(capitalize('hello world'), equals('Hello world'));
    expect(capitalize('h'), equals('H'));
    expect(capitalize(''), equals(''));
  });

  test('format number', () {
    expect(formatNumber(0), equals('0'));
    expect(formatNumber(500), equals('500'));
    expect(formatNumber(5000), equals('5,000'));
    expect(formatNumber(500000), equals('500,000'));
    expect(formatNumber(5000000), equals('5,000,000'));

    // With precision.

    expect(formatNumberWithPrecision(0), equals('0.00'));
    expect(formatNumberWithPrecision(500), equals('500.00'));
    expect(formatNumberWithPrecision(5000), equals('5,000.00'));
    expect(formatNumberWithPrecision(500000), equals('500,000.00'));
    expect(formatNumberWithPrecision(5000000), equals('5,000,000.00'));
    expect(formatNumberWithPrecision(10), equals('10.00'));
    expect(formatNumberWithPrecision(0.1), equals('0.10'));
    expect(formatNumberWithPrecision(0.01), equals('0.01'));
    expect(formatNumberWithPrecision(0.001), equals('0.00'));
  });

  test('item container', () {
    registerItemInfo('potion', ItemInfo());
    registerItemInfo('sword', ItemInfo());

    var container = ItemContainer(),
        sword = Item('sword'),
        potion = Item('potion', 2);

    container.addItem(potion, 3);
    container.addItem(sword);
    expect(container.count(potion.text), equals(6));
    expect(container.count(sword.text), equals(1));
    container.addItem(Item('sword'));
    expect(container.count(sword.text), equals(2));
    expect(container.removeItem(sword.text), equals(true));
    expect(container.count(sword.text), equals(1));
    container.addItem(Item('potion'));
    expect(container.count(potion.text), equals(7));
  });

  test('item container contains all', () {
    registerItemInfo('potion', ItemInfo());
    var items = ItemContainer(), container = ItemContainer();
    items.addItem(Item('potion'));
    container.addItem(Item('potion'));
    expect(items.containsAll(container), equals(true));
    container.addItem(Item('potion'));
    expect(items.containsAll(container), equals(false));
  });

  test('ballistic resistance', () {
    registerItemInfo('ballistic armor',
        ItemInfo(slot: #body, egos: const [Ego.resistBallistic]));

    registerDollInfo('a', DollInfo(equipped: {'0': Item('ballistic armor')}));

    var doll = Doll('a')..equipped.values.forEach((item) => item.bonus = 0);
    expect(doll.applyDefense(1000, const [Ego.ballistic]), 500);
    expect(doll.applyDefense(999, const [Ego.ballistic]), 499);
  });

  test('defense', () {
    registerWeaponInfo('natural weapon', 0);
    registerItemInfo('armor', ItemInfo(slot: #body));
    registerDollInfo('b', DollInfo(equipped: {'0': Item('armor')}));
    registerDollInfo('c', DollInfo(equipped: {'0': Item('armor')}));
    var doll = Doll('b')..equipped.values.forEach((item) => item.bonus = 500);
    expect(doll.applyDefense(1000), 500);
    doll = Doll('c')..equipped.values.forEach((item) => item.bonus = 999);
    expect(doll.applyDefense(1000), 250);
    doll = Doll('c')..equipped.values.forEach((item) => item.bonus = 2000);
    expect(doll.applyDefense(1000), 125);
    doll = Doll('c')..equipped.values.forEach((item) => item.bonus = 4000);
    expect(doll.applyDefense(1000), 62);
  });

  test('crafting', () {
    Crafting.add('cereal', const ['milk', 'grain']);
    Crafting.add('sushi', const ['fish']);
    expect(Crafting.craftedFrom('milk'), const ['cereal']);
    expect(Crafting.craftedFrom('grain'), const ['cereal']);
    expect(Crafting.craftedTo('cereal'), const ['milk', 'grain']);
  });

  test('crafting with bonuses', () {
    registerItemInfo('dagger', ItemInfo(slot: #weapon));
    registerItemInfo('fire scroll', ItemInfo());
    Crafting.add('fire dagger', const ['dagger', 'fire scroll']);

    expect(Item.fromDisplayText('+3 fire dagger').ingredients,
        equals(const ['+3 dagger', 'fire scroll']));

    var options = Crafting.optionsWithBonuses([
      Item.fromDisplayText('dagger'),
      Item.fromDisplayText('+1 dagger'),
      Item.fromDisplayText('+2 dagger'),
      Item.fromDisplayText('fire scroll')
    ]);

    expect(
        options, equals(['fire dagger', '+1 fire dagger', '+2 fire dagger']));

    options = Crafting.optionsWithBonuses([
      Item.fromDisplayText('+1 dagger'),
      Item.fromDisplayText('fire scroll')
    ]);

    expect(options, equals(['+1 fire dagger']));
  });

  test('wood crafting', () {
    registerItemInfo('wood', ItemInfo());
    Crafting.add('bow', const ['wood']);
    Crafting.add('book', const ['wood']);
    Crafting.add('wooden charm', const ['wood']);
    Crafting.add('guitar', const ['wood']);

    var options = Crafting.optionsWithBonuses([
      Item.fromDisplayText('wood'),
    ]);

    expect(options, equals(['bow', 'book', 'wooden charm', 'guitar']));
  });

  test('exchange', () {
    var exchange = Exchange();
    var sellOffer = exchange.sell('a', 'sword', 100, 3, Item('sword'));
    var buyOffer = exchange.buy('a', 'sword', 120, 2);
    expect(sellOffer.progress, 2);
    expect(buyOffer.progress, 2);
    expect(buyOffer.change, 40);
  });

  test(
      'ego from string',
      () => expect(
          List.from(Ego.parse('fire ice gravity'))..sort(), const [0, 1, 22]));

  test('item from string', () {
    registerItems(const {});
    var item = Item.fromDisplayText('ice gravity smg');
    expect(item.infoName, 'smg');
    expect(List.from(item.egos)..sort(), const [1, 11, 12, 22, 33]);

    // Gravity appears before ice because the egos are sorted.

    expect(item.displayTextWithoutAmount, "gravity ice smg");
  });

  test('invert percent', () {
    expect(invertPercentage(0), 0);
    expect(invertPercentage(25), 25);
    expect(invertPercentage(50), 50);
    expect(invertPercentage(100), 75);
    expect(invertPercentage(200), 87.5);
    expect(invertPercentage(400), 93.75);
  });

  test('set level', () {
    for (var i = 1; i <= Stat.maxLevel; i++) {
      var stat = Stat()..setLevel(i);
      expect(stat.level, i);
    }
  });

  test('experience curve', () {
    var stat = Stat();

    for (int i = 1; i <= Stat.maxLevel; i++) {
      stat.setLevel(i);
      expect(stat.level, i);

      expect(
          (stat..setExperienceWithoutSplat(stat.experience)).level, stat.level);
    }

    stat.setLevel(Stat.maxLevel + 1);
    expect(stat.level, Stat.maxLevel);
    expect(stat.experience, big(Stat.maxLevelExperience));
  });

  test('ascended experience curve', () {
    test(ascensions) {
      var stat = Stat();
      stat.ascensions = ascensions;

      for (int i = ascensions > 100 ? Stat.maxLevel : 1;
          i <= Stat.maxLevel;
          i++) {
        stat.setLevel(i);
        expect(stat.internalLevel, i);

        expect((stat..setExperienceWithoutSplat(stat.experience)).internalLevel,
            stat.internalLevel);
      }

      stat.setLevel(Stat.maxLevel + 1);
      expect(stat.internalLevel, Stat.maxLevel);

      expect(stat.experience,
          big(Stat.maxLevelExperience) * (BigInt.one << stat.ascensions));
    }

    for (int i = 0; i < 1000; i++) test(i);
  });

  test('experience meteorite crown', () {
    Crafting.init();

    expect(Crafting.craftedTo('+1 experience meteorite crown', true),
        equals(['experience meteorite crown']));
  });

  test('potion upgrades', () {
    Crafting.init();

    expect(Item.fromDisplayText('acid potion').canUpgrade, false);
    expect(Item.fromDisplayText('strength potion').canUpgrade, true);
  });

  test('set bonus', () {
    expect(setBonus('dagger', 5), '+5 dagger');
    expect(setBonus('+2 dagger', 7), '+7 dagger');
  });

  test('max floor', () {
    registerItems(const {});

    // There are overflow errors above the max floor. This test verifies that
    // there are no overflow errors on the max floor.

    registerDollInfo('boss', DollInfo(boss: true));

    for (int i = 1; i <= Session.maxFloor; i++) {
      var doll = Doll('boss', null, false, i);
      expect(doll.health > 1, equals(true));

      expect(
          BigInt.from(calculateDamage(doll, Item('wrath'))) * BigInt.from(10) >
              BigInt.from(maxFinite),
          false);
    }
  });

  test('format currency', () {
    expect(formatCurrency(maxFinite), 'Ξ9,223P');
    expect(formatCurrency(big(maxFinite) * big(1000)), 'Ξ9,223E');
    expect(formatCurrency(big(maxFinite) * big(100000)), 'Ξ922,337E');
    expect(formatCurrency(big(maxFinite) * big(million)), 'Ξ9,223,372E');
  });

  test('get bonus', () {
    expect(getBonus('dagger'), 0);
    expect(getBonus('+1 dagger'), 1);
    expect(getBonus('+9999 dagger'), 9999);
  });

  test('overflow', () {
    expect(maxFinite, maxFinite);
    expect(maxFinite + 1, -maxFinite - 1);
    expect(parseInteger('10000P'), maxFinite);
  });

  test('parseInteger', () {
    expect(parseInteger("-1"), -1);
  });

  test('retry', () {
    int count = 0, limit = 1000;

    retryOnError(() {
      if (++count < limit) throw Error();
    });

    expect(count, limit);
  });

  test('deep copy', () {
    registerFactory(#Doll, () => Doll());
    var doll = Doll('test'), copy = deepCopy(doll);
    expect(copy.id, doll.id);
    expect(copy.infoName, doll.infoName);
    expect(copy.runtimeType, doll.runtimeType);
  });

  test('all drops', () {
    registerItems(const {});

    registerDollInfo(
        'cosmic turtle',
        DollInfo(
            boss: true,
            walkingCoolDown: 600,
            abilities: const ['quake'],
            equipped: {
              '0': Item('cosmic turtle shell'),
              '1': Item('rock'),
            },
            difficulty: 30,
            image: 'image/npc/turtle.png',
            loot: DropTable()
              ..addAlways(() => Item('cosmic turtle shell'))
              ..addRandom(() => Item('katana', 1, const [Ego.electric]))
              ..addRandom(() => Item('katana', 1, const [Ego.fire]))
              ..addRandom(() => Item('katana', 1, const [Ego.ice]))));

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

    expect(whatDrops('fire katana'), ['cosmic turtle']);
    expect(whatDrops('+1000 fire katana'), ['cosmic turtle']);
    expect(whatDrops('sleipnirs'), ['stacy']);
  });

  test('big int', () {
    expect(big(-0), BigInt.zero);
    expect(big(0), BigInt.zero);
    expect(big(10), BigInt.from(10));
    expect(big(-10), BigInt.from(-10));
    expect(big('-0'), BigInt.zero);
    expect(big('0'), BigInt.zero);
    expect(big('10'), BigInt.from(10));
    expect(big('-10'), BigInt.from(-10));
    expect(big(0.0), BigInt.zero);
    expect(big(0.99), BigInt.zero);
    expect(big(-0.99), BigInt.from(-1));
    expect(big(5.53), BigInt.from(5));
    expect(big(null), BigInt.zero);
  });

  test('small int', () {
    expect(small(BigInt.from(0)), 0);
    expect(small(BigInt.from(10)), 10);
    expect(small(BigInt.from(-10)), -10);
    expect(small(BigInt.from(maxFinite) + BigInt.one), maxFinite);
  });

  test('take last', () {
    expect(takeLast(['a', 'b', 'c', 'd', 'e'], 3), ['c', 'd', 'e']);
    expect(takeLast(['a', 'b', 'c', 'd', 'e'], 10), ['a', 'b', 'c', 'd', 'e']);
  });
}
