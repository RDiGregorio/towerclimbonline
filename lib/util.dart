library util;

import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:intl/intl.dart';
import 'package:logging/logging.dart';
import 'package:pathfinding/core/heap.dart';
import 'package:pathfinding/core/heuristic.dart';
import 'package:pathfinding/core/node.dart';
import 'package:pathfinding/core/util.dart';
import 'package:quiver/async.dart';
import 'package:quiver/collection.dart';
import 'package:r_tree/r_tree.dart' hide Node;
import 'package:towerclimbonline/config.dart';

part 'src/util/ability.dart';
part 'src/util/account.dart';
part 'src/util/async_order.dart';
part 'src/util/big_int_util.dart';
part 'src/util/buff.dart';
part 'src/util/character_sheet.dart';
part 'src/util/clock.dart';
part 'src/util/cool_down.dart';
part 'src/util/crafting.dart';
part 'src/util/crafting_option.dart';
part 'src/util/customization_layer.dart';
part 'src/util/doll.dart';
part 'src/util/doll_customization.dart';
part 'src/util/doll_info.dart';
part 'src/util/drop_table.dart';
part 'src/util/effect.dart';
part 'src/util/ego.dart';
part 'src/util/exchange.dart';
part 'src/util/exchange_offer.dart';
part 'src/util/experience_curve.dart';
part 'src/util/experience_rate.dart';
part 'src/util/idler.dart';
part 'src/util/item.dart';
part 'src/util/item_container.dart';
part 'src/util/item_info.dart';
part 'src/util/missile.dart';
part 'src/util/observable_event.dart';
part 'src/util/observable_map.dart';
part 'src/util/online_object.dart';
part 'src/util/path_finder.dart';
part 'src/util/random_shop.dart';
part 'src/util/recovery_attempt.dart';
part 'src/util/resource_manager.dart';
part 'src/util/scores.dart';
part 'src/util/server_globals.dart';
part 'src/util/session.dart';
part 'src/util/space.dart';
part 'src/util/splat.dart';
part 'src/util/sprite.dart';
part 'src/util/stage.dart';
part 'src/util/stat.dart';
part 'src/util/terrain.dart';
part 'src/util/theme.dart';
part 'src/util/tile.dart';
part 'src/util/wrapper.dart';

const int millisecondsPerDay = 86400000,
    millisecondsPerQuarterDay = 21600000,
    millisecondsPerHour = 3600000,
    million = 1000 * 1000,
    billion = 1000 * million,
    trillion = 1000 * billion,
    quadrillion = 1000 * trillion,
    quintillion = 1000 * quadrillion,

    // 2 ^ 32

    maxInt = 4294967296;

Map<Symbol, String> alerts = {
  #no: 'You can\'t do that right now.',
  #noCombat: 'You can\'t do that while fighting.',
  #noPlayerCombat: 'You can\'t do that while fighting a player.',
  #noTrade: 'You can\'t trade that.',
  #noUse: 'You can\'t use that right now.',
  #noEat: 'You can\'t eat that right now.',
  #nothingHappens: 'Nothing happens.',
  #capped: 'You\'ve reached your daily resource limit.',
  #tooPoor: 'You can\'t afford that.',
  #tooManyOffers: 'You can only have ' +
      '${Account.maxExchangeOffers} exchange offers at a time.',
  #notUnlocked: 'You haven\'t unlocked that floor yet.',
  #tradeComplete: 'You finish trading.',
  #updateApp: 'Please update your app.'
};

final int maxFinite = double.maxFinite.floor();
final BigInt maxInput = big(100000) * big('1X') - BigInt.one;
final String missingItemName = '????',

    // Thin spaces are the international standard for digit grouping.

    separator = '\u{202F}';

RegExp numberPattern = RegExp(r'^\d+[kmgtpezyx]?$'),
    _nonAlphaNumeric = RegExp(r'[^a-zA-Z0-9]+'),
    _upgradePattern = RegExp(r'^\+\d+'),
    _splitDigits = RegExp(r'\d{3}'),
    _trailingSeparator = RegExp('$separator\$');

List<int> performanceCheckpoints = [];
int timeOffset = 0, _count = 0;
Map<String, Ability> _abilities = {};
Map<String, DollInfo> _dollInfo = {};
Map<Symbol, Function> _factories = {};
Map<String, ItemInfo> _itemInfo = {};
int _now, _performanceCheckpoint;
NumberFormat _precisionNumberFormat = NumberFormat('#,##0.00');
Random _random = Random();

int get daysSinceEpoch => now ~/ millisecondsPerDay;

int get hoursSinceEpoch => now ~/ millisecondsPerHour;

/// Returns the current time. Increased by [timeOffset]. Can be set to a
/// different value if needed but doing so will stop automatic updates.

int get now => (_now ?? DateTime.now().millisecondsSinceEpoch) + timeOffset;

void set now(int value) {
  _now = value;
}

int get quarterDaysSinceEpoch => now ~/ millisecondsPerQuarterDay;

int get quarterHoursSinceEpoch => 4 * now ~/ millisecondsPerHour;

bool get randomBool => _random.nextBool();

num get randomDouble => _random.nextDouble();

Item get secretRare {
  // God items are not included as possible secret rare types.

  String info = randomValue(randomValue([
    // Weapons:

    [
      'smg',
      'katana',
      'wrath',
      'rainbow undecimber',
      'annihilation book',
      'supernova book'
    ],

    // Helmets.

    [
      'super resist hat',
      'meteorite crown',
      'dream crown',
      'distortion hat',
      'umbra'
    ],

    // Armor.

    [
      'aegis armor',
      'stardust dragon armor',
      'shadow dragon armor',
      'distortion robe'
    ],

    // Cloaks.

    ['stardust dragon cloak', 'shadow dragon cloak', 'distortion cloak'],

    // Boots.

    ['evasion boots', 'power boots', 'accuracy boots', 'invisibility boots'],

    // Gloves.

    [
      'evasion gloves',
      'power gloves',
      'accuracy gloves',
      'crystal thieving gloves'
    ],

    // Shields.

    ['aegis shield', 'spirit shield'],

    // Amulets.

    [
      'wooden charm',
      'golden charm',
      'power amulet',
      'accuracy amulet',
      'evasion amulet',
      'defense amulet',
      'invisibility amulet',
      'life amulet',
      'reflection amulet'
    ],

    // Rings.

    ['meteorite ring', 'super resist ring', 'burst ring', 'berserk ring']
  ]));

  List<int> egos = [];
  int egoCount;
  Item item = Item.fromDisplayText(info);

  if (item.info.slot == #weapon) {
    egoCount = 3;

    egos.addAll([
      // Elements.

      Ego.blood,
      Ego.energy,

      // Combat effects.

      Ego.burst,
      Ego.berserk,
      Ego.demon,

      // Other effects.

      Ego.crystal,
      Ego.lucky
    ].where((ego) => !item.egos.contains(ego)));
  } else if (item.info.slot == #shield)
    egos.addAll([
      // Universal armor egos (crystal is used instead of experience).

      Ego.crystal, Ego.reflection, Ego.regen, Ego.arcane, Ego.spirit
    ].where((ego) => !item.egos.contains(ego)));
  else if ([#helmet, #body, #cloak, #gloves].contains(item.info.slot))
    egos.addAll([
      // Universal armor egos.

      Ego.experience, Ego.reflection, Ego.regen, Ego.arcane, Ego.spirit
    ].where((ego) => !item.egos.contains(ego)));
  else if (item.info.slot == #boots)
    egos.addAll([
      Ego.fast,

      // Universal armor egos.

      Ego.experience, Ego.reflection, Ego.regen, Ego.arcane, Ego.spirit
    ].where((ego) => !item.egos.contains(ego)));
  else if (item.info.slot == #ring)
    egos.addAll([
      Ego.berserk,
      Ego.burst,

      // Universal armor egos.

      Ego.experience,
      Ego.regen,
      Ego.reflection,
      Ego.arcane,
      Ego.spirit
    ].where((ego) => !item.egos.contains(ego)));
  else if (item.info.slot == #amulet)
    egos.addAll([
      Ego.shield,
      Ego.lucky,

      // Universal armor egos.

      Ego.experience,
      Ego.regen,
      Ego.reflection,
      Ego.arcane,
      Ego.spirit
    ].where((ego) => !item.egos.contains(ego)));

  if (egos.isNotEmpty)
    return item.copyWithEgos(List.from((egos..shuffle()).take(egoCount ?? 1)));

  return item;
}

String abilityDisplayImage(String ability) {
  if (ability == null) return 'image/transparent.png';
  return 'image/missing.png';
}

/// Useful if any abilities are renamed.

String abilityDisplayName(String ability) => ability;

String addEllipsis(String value, [int max = 10]) =>
    value.length <= max ? value : value.substring(0, max).trim() + '…';

void addPerformanceCheckpoint() {
  var now = DateTime.now().millisecondsSinceEpoch;
  performanceCheckpoints.add(now - (_performanceCheckpoint ??= now));
  _performanceCheckpoint = now;
}

Set<Point<int>> adjacent(Point<int> point) {
  var result = Set<Point<int>>();

  for (var i = -1; i <= 1; i++)
    for (var j = -1; j <= 1; j++)
      result.add(Point<int>(point.x + i, point.y + j));

  return result..remove(point);
}

/// Returns every [Point] contained by [rectangle].

Set<Point<int>> allPoints(Rectangle<int> rectangle) {
  var result = Set();

  for (int x = 0; x < rectangle.width; x++)
    for (int y = 0; y < rectangle.height; y++) result.add(Point(x, y));

  return result;
}

Point<num> approachPoint(Point<num> location, Point<num> target,
    [num distance = 1]) {
  var distanceTo = location.distanceTo(target);
  if (distanceTo <= distance) return target;

  return Point(location.x + (target.x - location.x) / distanceTo * distance,
      location.y + (target.y - location.y) / distanceTo * distance);
}

/// Converts [value] from a [BigInt], [String], or [num] to a [BigInt]. If
/// [value] is a [num], it is floored. If [value] is null, [BigInt.zero] is
/// returned.

BigInt big(dynamic value) {
  if (value == null) return BigInt.zero;
  if (value is BigInt) return value;

  if (value is String)
    try {
      return parseBigInteger(value);
    } catch (error) {
      throw ArgumentError(value);
    }

  if (value is num && value.isFinite) return BigInt.from(value.floor());
  throw ArgumentError(value);
}

BigInt calculateAccuracy(Doll doll, [Item weapon]) {
  // FIXME BIG HP: This doesn't look safe! The double could become too large!

  var result = doll.dexterity +
      doll.dexterity *
          calculateAccuracyPercentBonus(weapon, doll.nonWeaponEquipment) /
          100;

  return big(result) + big(result) * big(doll.accuracyItems) ~/ big(4);
}

int calculateAccuracyPercentBonus(
    Item weapon, Iterable<dynamic> nonWeaponEquipment) {
  var increasePercent = damageIncreasePercent(nonWeaponEquipment.fold(
          weapon?.bonus ?? 0, (accuracy, item) => accuracy + item.accuracy)),
      weaponAccuracy = weapon?.accuracy ?? 0;

  var result = increasePercent + weaponAccuracy;
  return result + increasePercent * weaponAccuracy ~/ 100;
}

int calculateCharmAttribute(Doll doll, Item weapon) {
  // Presumes all points are put into the charming attribute, so the result is
  // not divided by 5 like as with similar calculations.

  num result = 50 + triangleNumber(doll.modifiedSummoningLevel);
  return (result + result * weapon.bonus / 100).floor();
}

int calculateCoolDown(Doll doll, [Item weapon]) =>
    weapon == null ? CoolDown.average : weapon.info.coolDown;

BigInt calculateDamage(Doll doll, [Item weapon]) {
  BigInt damage = BigInt.zero;
  int bonus = 0;

  if (weapon != null) {
    damage = big(weapon.damage);
    bonus = weapon.bonus;
  }

  // Each +1 on a weapon increases damage (including from attributes like
  // strength).

  var charm = weapon?.egos?.contains(Ego.charm) == true;

  BigInt attribute = charm
      ? big(calculateCharmAttribute(doll, weapon))
      : big(doll._weaponAttribute(weapon));

  BigInt result = BigIntUtil.percent(
      doll.nonWeaponEquipment.fold(
          attribute + damage, (damage, item) => damage + big(item.damage)),
      100 + damageIncreasePercent(bonus));

  if (doll?.account?.god == 'trog') result *= BigInt.two;

  // Power items are done last because of the division.

  BigInt sourcePowerItems = big(doll?.powerItems ?? 0);
  result += result * sourcePowerItems ~/ big(4);

  if (doll?.account == null) {
    // Non-players deal extra damage to compensate for the damage reduction from
    // player equipment. Note that damage reduction can't be symmetrical because
    // that would make acid attacks disproportionally powerful.

    BigInt level = big(doll?.level ?? 0);
    result += result * level ~/ big(100);
  }

  return result;
}

int calculateDropBonus(int level, dynamic amount) {
  amount = big(amount);
  if (amount < BigInt.two) return 0;
  var bonusPerUpgrade = level ~/ 20 + 1;
  return bonusPerUpgrade * (amount.bitLength - 1);
}

int calculateEvasion(Doll doll) =>

// FIXME BIG HP: This may not be safe with large numbers.

    (doll.agility +
            doll.agility *
                calculateEvasionPercentBonus(doll.equipped.values) /
                100)
        .floor();

int calculateEvasionPercentBonus(Iterable<dynamic> equipment) {
  var base = 100;

  var increasePercent = damageIncreasePercent(equipment.fold(0, (result, item) {
    base += item.evasion;
    if (item.upgradesIncreaseEvasion) return result + item.bonus;
    return result;
  }));

  return base + base * increasePercent ~/ 100 - 100;
}

/// Calculates if an attack hits or not.

bool calculateHit(Doll doll, num accuracy, num evasion,
    [num rateMultiplier = 1]) {
  var rate = invertPercentage(accuracy * 50 / evasion) * rateMultiplier,
      result = rate > randomDouble * 100;

  if (!result) doll?.splat('${rate.floor()}%', 'effect-text');
  return result;
}

int calculateLevel(Doll doll) {
  if (doll?.info == null) return 0;

  var points = doll.agility +
      doll.vitality +
      doll.dexterity +
      doll.strength +
      doll.intelligence;

  var level = 1, result = 50 + triangleNumber(level);
  while (result < points) result = 50 + triangleNumber(++level);
  return level;
}

BigInt calculateReflectedDamage(Doll doll) {
  if (doll == null) return BigInt.zero;

  // Non-player's don't have items with upgrades, so their level is used
  // instead.

  int upgrades(Item item) => doll.account != null ? item.bonus : doll.level;

  // The average bonus of the reflect items is treated like a weapon bonus.

  var equipped = List<Item>.from(doll.equipped.values
          .where((item) => item.egos.contains(Ego.reflection))),
      bonus = equipped.fold(0, (result, item) => result + upgrades(item)) ~/
          equipped.length;

  // Reflection uses vitality for damage.

  BigInt attribute = big(doll.vitality),
      result = attribute + attribute * big(bonus) ~/ big(100);

  // Reflection deals 25% damage.

  return result * big(equipped.length) ~/ big(4);
}

/// Capitalizes the first letter of [string].

String capitalize(String string) => string == null
    ? null
    : string.length == 0
        ? string
        : string[0].toUpperCase() + string.substring(1);

Set<Point<int>> cardinalAdjacent(Point<int> point) {
  var result = Set<Point<int>>();
  result.add(point + Point(-1, 0));
  result.add(point + Point(0, -1));
  result.add(point + Point(1, 0));
  result.add(point + Point(0, 1));
  return result;
}

num clamp(num value, num minValue, num maxValue) =>
    max(min(value, maxValue), minValue);

int coinFlips(int coinFlips) {
  num heads = 0, speed = 1;

  // Prevents the server from hanging on a large amount.

  if (coinFlips > 10000) speed = coinFlips / 1000;
  for (num i = 0; i < coinFlips; i += speed) if (randomBool) heads++;
  return (heads * speed).floor();
}

String compactFormatInteger(dynamic amount) => formatCurrency(amount, false);

int compareItemNames(String first, String second) {
  var firstWithoutBonus = first.replaceFirst(_upgradePattern, '').trim(),
      secondWithoutBonus = second.replaceFirst(_upgradePattern, '').trim();

  if (firstWithoutBonus == secondWithoutBonus)
    return _upgradePattern
            .firstMatch(first)
            ?.group(0)
            ?.compareTo(_upgradePattern.firstMatch(second)?.group(0) ?? '') ??
        0;

  return firstWithoutBonus.compareTo(secondWithoutBonus);
}

int compareItems(dynamic first, dynamic second) {
  if (first.comparisonText == second.comparisonText)
    return first.bonus.compareTo(second.bonus);

  return first.comparisonText.compareTo(second.comparisonText);
}

int count() => _count++;

Map<String, String> currencyStyle(int amount) => const {};

int damageIncreasePercent(int bonus) => bonus;

num damageReductionPercent(num bonus) => invertPercentage(bonus);

dynamic deepCopy(dynamic value) =>
    json.decode(json.encode(value, toEncodable: mapWrapperEncoder),
        reviver: mapWrapperDecoder);

/// Digests [string] using SHA-256. The returned string encoded is in base 64.

String digest(String string) =>
    base64.encode(sha256.convert(string.codeUnits).bytes);

int dollLevel(int difficulty, bool boss) {
  num result = max(1, difficulty);
  result *= boss ? 6 : 5;

  // The first few floors are easy to help new players.

  result *= min(1 + difficulty / 5, 2) * pow(1.01, difficulty / 2);
  return result.floor();
}

bool equalElements(Iterable<dynamic> first, Iterable<dynamic> second) =>
    first.every(Set.from(second).contains) &&
    second.every(Set.from(first).contains);

bool examine(Doll source, Doll target, bool showLocation) {
  if (target != null) {
    if (target.resource) {
      var messages = [], item = target?.sanitizedName;

      if (item == 'rock')
        item = 'iron';
      else if (item == 'tree')
        item = 'wood';
      else if (item == 'magic tree')
        item = 'magic wood';
      else if (item == 'stardust rock')
        item = ['sapphire', 'ruby', 'emerald', 'diamond', 'onyx'].join(', ');
      else if (item == 'stardust fish')
        item = 'rainbow fish';
      else if (item == 'stardust tree')
        item = 'yggdrasil fruit';
      else if (item == 'tentacles')
        item = ['tentacle', 'blood potion'].join(', ');
      else if (item == 'chest')
        item = 'chest';
      else if (item == 'dummy') item = 'punching bag';

      messages.add('item: $item');

      if (item.contains('fish') || item.contains('shark')) {
        var hats =
            ['fishing hat', 'lumberjack hat', 'mining helmet'].join(', ');

        messages.add('rare: $hats');
      }

      source.informationPrompt(messages.join('<br>'));
      return false;
    }

    var id = target.infoName ?? target.internal['display'] ?? '',
        level = compactFormatInteger(target.level),
        agi = compactFormatInteger(target.agility),
        dex = compactFormatInteger(target.dexterity),
        intel = compactFormatInteger(target.intelligence),
        str = compactFormatInteger(target.strength),
        vit = compactFormatInteger(target.vitality);

    var gear =
        '${List.from(target.equipped.values.map((item) => item.displayTextWithoutAmount))}';

    gear = gear.substring(1, gear.length - 1);

    var abilityList = List.from(((target?.abilities ?? const []) as dynamic))
          ..remove(null),
        abilityDisplay = '$abilityList';

    Account targetAccount = target.account;
    abilityDisplay = abilityDisplay.substring(1, abilityDisplay.length - 1);
    var health = target?.maxHealth ?? 0, messages = [];

    String formatWalkingCoolDown(int walkingCoolDown) {
      if (walkingCoolDown == 200) return 'fast';
      if (walkingCoolDown == 400) return 'normal';
      if (walkingCoolDown == 600) return 'slow';
      return null;
    }

    messages
      ..add('name: $id')
      ..add('level: $level')
      ..add('health: ${compactFormatInteger(health)}')
      ..add('speed: ${formatWalkingCoolDown(target.walkingCoolDown)}');

    if (targetAccount == null) messages.add('+$level% damage');

    messages
      ..add('attributes: $agi agi, $dex dex, $intel int, $str str, $vit vit');

    if (targetAccount != null) {
      messages.add('skills: ${compactFormatInteger(targetAccount.sheet.combat.level)} combat, ' +
          '${compactFormatInteger(targetAccount.sheet.summoning.level)} summoning, ' +
          '${compactFormatInteger(targetAccount.sheet.slaying.level)} luck, ' +
          '${compactFormatInteger(targetAccount.sheet.fishing.level)} fishing, ' +
          '${compactFormatInteger(targetAccount.sheet.mining.level)} mining, ' +
          '${compactFormatInteger(targetAccount.sheet.woodcutting.level)} gathering, ' +
          '${compactFormatInteger(targetAccount.sheet.cooking.level)} cooking, ' +
          '${compactFormatInteger(targetAccount.sheet.metalworking.level)} metalworking, ' +
          '${compactFormatInteger(targetAccount.sheet.crafting.level)} crafting, ' +
          '${compactFormatInteger(targetAccount.sheet.crime.level)} stealth');

      messages.add('god: ${godName(targetAccount?.god)}');
    }

    if (abilityDisplay.isNotEmpty) messages.add('abilities: $abilityDisplay');

    if (gear.isNotEmpty) messages.add('equipment: $gear');

    if (targetAccount == null) {
      var drops = target?.info?.loot?.text ?? '';

      if (target.dropsSecretRare) {
        if (drops != '') drops += ', ';
        drops += 'puzzle box (1.00%)';
      }

      if (drops != '' && !target.summoned) messages.add('drops: $drops');
    }

    if (showLocation)
      messages.add('location: floor ${targetAccount?.currentFloor} ' +
          '(${targetAccount?.doll?.currentLocation?.x}, ${targetAccount?.doll?.currentLocation?.y})');

    source.informationPrompt(messages.join('<br>'));
  }

  return false;
}

BigInt extraResources(int level, int amount) {
  return big(max(1, amount)) * big(triangleNumber(level)) ~/ big(1000);
}

Map<dynamic, dynamic> filterMap(
    Map<dynamic, dynamic> map, bool filter(dynamic key, dynamic value)) {
  var result = {};

  map.forEach((key, value) {
    if (filter(key, value)) result[key] = value;
  });

  return result;
}

/// Returns the boss level of the current floor.

int floorToLevel(int floor) => Doll(null, null, false, floor ?? 1).level;

String formatBigInt(BigInt value) => reverseString(reverseString('$value')
    .replaceAllMapped(_splitDigits, (match) => '${match.group(0)}$separator')
    .replaceFirst(_trailingSeparator, ''));

String formatCurrency(dynamic amount, [bool prefix = true]) {
  var suffix = '';
  amount = big(amount);

  if (amount >= big(quintillion) * big(trillion)) {
    amount ~/= big(quintillion) * big(billion);

    // An unofficial continuation of the pattern.

    suffix = 'X';
  } else if (amount >= big(quintillion) * big(billion)) {
    amount ~/= big(quintillion) * big(million);

    // Yotta.

    suffix = 'Y';
  } else if (amount >= big(quintillion) * big(million)) {
    amount ~/= big(quintillion) * big(1000);

    // Zetta.

    suffix = 'Z';
  } else if (amount >= big(quintillion) * big(1000)) {
    amount ~/= big(quintillion);

    // Exa.

    suffix = 'E';
  } else if (amount >= big(quintillion)) {
    amount ~/= big(quadrillion);

    // Peta.

    suffix = 'P';
  } else if (amount >= big(quadrillion)) {
    amount ~/= big(trillion);

    // Tera.

    suffix = 'T';
  } else if (amount >= big(trillion)) {
    amount ~/= big(billion);

    // Giga.

    suffix = 'G';
  } else if (amount >= big(billion)) {
    amount ~/= big(million);

    // Mega.

    suffix = 'M';
  } else if (amount >= big(million)) {
    amount ~/= big(1000);

    // Kilo.

    suffix = 'K';
  }

  return (prefix ? 'Ξ' : '') + '${formatNumber(amount)}$suffix';
}

/// Adds commas.

String formatNumber(dynamic value) => formatBigInt(big(value));

String formatNumberWithPrecision(num value) =>
    _precisionNumberFormat.format(value);

int getBonus(String text) => text.startsWith(_upgradePattern)
    ? parseInteger(_upgradePattern.firstMatch(text).group(0).substring(1))
    : 0;

String getName(Symbol symbol) {
  var string = '$symbol';
  return string.substring(8, string.length - 2);
}

String godName(String value) => value == null ? 'none' : capitalize(value);

/// Moves like a king in chess.

Point<num> gridApproachPoint(Point<num> location, Point<num> target,
    [num speed = 1]) {
  var xDist = (target.x - location.x), yDist = (target.y - location.y);

  return Point(xDist.abs() > speed ? location.x + xDist.sign * speed : target.x,
      yDist.abs() > speed ? location.y + yDist.sign * speed : target.y);
}

/// Helps avoid errors.

num increase(Map<dynamic, dynamic> map, num key, [num amount = 1]) =>
    (map..[key] ??= 0)[key] += amount;

num invertPercentage(num percent) =>
    percent > 50 ? 100 - 2500 / percent : percent;

bool itemExists(String value) {
  value = value.trim().toLowerCase();
  if (_itemInfo.keys.contains(value)) return true;
  return Item.fromDisplayText(value).displayTextWithoutAmount == value;
}

String itemInfoName(String itemName) {
  if (_itemInfo.containsKey(itemName)) return itemName;
  var matches = _itemInfo.keys.where((key) => ' $itemName'.endsWith(' $key'));

  return matches.isEmpty
      ? null
      : matches.reduce(
          (first, second) => second.length > first.length ? second : first);
}

void kick(dynamic session) {
  session
    ..internal.addEvent(ObservableEvent(type: 'kick'))
    ..preventLogout = false
    ..logout(true);
}

Map<Point<int>, int> listKeyMapToPointKeyMap(Map<List<int>, int> map) {
  var result = {};
  map.forEach((list, value) => result[Point(list[0], list[1])] = value);
  return result;
}

num log2(num value) => log(value) / ln2;

Map<String, bool> mapFromList(List<String> list) {
  var result = <String, bool>{};
  list.forEach((key) => result[key] = true);
  return result;
}

dynamic mapWrapperDecoder(dynamic key, dynamic value,
    {dynamic safety(dynamic key, dynamic value)}) {
  dynamic instance(String type) {
    try {
      return newInstanceFromFactory(Symbol(type));
    } catch (error) {
      // Needed to log errors with minified classes.

      Logger.root.severe('failed to decode $type');
      rethrow;
    }
  }

  if (value is Map && value.containsKey('_t')) {
    var type = value.remove('_t');

    // Overrides minified types.
    // FIXME: think of a better way to do this

    if (value.containsKey('_override')) type = value.remove('_override');
    return (instance(type)..internal.addAll(value));
  } else {
    return safety == null ? value : safety(key, value);
  }
}

dynamic mapWrapperEncoder(dynamic value) {
  if (value is Wrapper) {
    var map = unwrap(value);
    assert(!map.containsKey('_t'));
    return <dynamic, dynamic>{'_t': '${value.runtimeType}'}..addAll(map);
  } else
    return value;
}

/// Returns every [Doll] nearby a [Doll] in [dolls]. [Doll]s can only be nearby
/// each other if they're in the same [Stage].

Set<Doll> nearbyDolls(Iterable<dynamic> dolls, int horizontalDistance,
        int verticalDistance) =>
    dolls.fold(
        Set(),
        (set, doll) => set
          ..addAll(doll.search(horizontalDistance * 2, verticalDistance * 2)));

/// Used with [registerFactory].

dynamic newInstanceFromFactory(Symbol symbol) => _factories.containsKey(symbol)
    ? _factories[symbol]()
    : throw StateError('You haven\'t registered ' + getName(symbol) + ' yet!');

/// The underlying resource is a map.

ResourceManager newMockResourceManager([Map<dynamic, dynamic> map]) {
  map ??= {};

  return ResourceManager(
      exists: map.containsKey,
      save: (key, value, cleanup) {
        map[key] = value;
        cleanup();
      },
      load: (key) => map[key]);
}

/// Parses [integer]. Can handle values like 1K, 1M, 1G, 1T, 1P, and 1E.

BigInt parseBigInteger(String integer) {
  if (integer == null) return null;
  integer = integer.trim().toLowerCase().replaceAll(_nonAlphaNumeric, '');
  var negative = integer.startsWith('-');
  if (negative) integer = integer.substring(1);
  if (!integer.contains(numberPattern)) return null;
  integer = integer.replaceFirst('x', '000y');
  integer = integer.replaceFirst('y', '000z');
  integer = integer.replaceFirst('z', '000e');
  integer = integer.replaceFirst('e', '000p');
  integer = integer.replaceFirst('p', '000t');
  integer = integer.replaceFirst('t', '000g');
  integer = integer.replaceFirst('g', '000m');
  integer = integer.replaceFirst('m', '000k');
  integer = integer.replaceFirst('k', '000');
  return negative ? -BigInt.parse(integer) : BigInt.parse(integer);
}

BigInt parseFormattedBigInt(String text) =>
    BigInt.parse(text.replaceAll(_nonAlphaNumeric, ''));

/// Parses [integer]. Can handle values like 1K, 1M, 1G, 1T, 1P, and 1E.

int parseInteger(String integer) => parseBigInteger(integer)?.toInt();

int percent(num value, num percent) => value * percent ~/ 100;

String plural(String singular, String plural, int amount) {
  return amount == 1 ? singular : plural;
}

Map<List<int>, int> pointKeyMapToListKeyMap(Map<Point<int>, int> map) {
  var result = {};
  map.forEach((point, value) => result[[point.x, point.y]] = value);
  return result;
}

/// Used to create portals.

DollInfo portal(String image) => DollInfo(
    image: image,
    preventsPvP: true,

    // Prevents players from moving over a portal and preventing another
    // player from using it.

    canPassThis: Terrain.obstacles,
    interaction: (Account account, Doll doll) {
      var up = doll?.isStairsUp ?? false;

      if (account.adjustedHighestFloor <= stageToFloor(doll?.stage?.id) && up) {
        account.alert('Defeating a boss on this floor unlocks the next floor.');
        if (!Config.debug) return;
      }

      var offset = up ? 1 : -1;

      if (account.sessions.isNotEmpty)
        account.sessions.first
            .teleport(account.currentFloor + offset, false, up);

      //var targetDoll = up ? targetStage.stairsDown : targetStage.stairsUp;
      //account.doll.jump(targetStage, targetDoll?.currentLocation);
    });

bool primitive(dynamic value) =>
    value == null || value is bool || value is num || value is String;

bool primitiveList(dynamic value) => value is List && value.every(primitive);

/// Returns a random number between 0 (inclusive) and [max] or 4,294,967,296
/// (exclusive). Some precision is lost if [max] is greater than 4,294,967,296.

int random([int max = maxInt]) => max > maxInt
    ? random(max ~/ 2) * 2 + _random.nextInt(2)
    : _random.nextInt(max);

BigInt randomBigDivideByTwo(BigInt value) {
  if (value.isEven || randomBool) return value >> 1;
  return (value >> 1) + BigInt.one;
}

/// Returns [count] random digits.

String randomDigits(int count) {
  var result = '';
  for (var i = 0; i < count; i++) result += '${random(10)}';
  return result;
}

String randomHumanJson(String id) {
  // The JSON can be created in debug mode using the customization modal.

  var variations = [
    // Males.

    '{"_t":"DollCustomization","id":"2da4-171cd4de4d4-6c3c1410","_override":"DollCustomization","gender":"male","base":{"_t":"CustomizationLayer","id":"2da5-171cd4de4d4-d1c0ea6e","_override":"CustomizationLayer","type":"0","h":0,"s":100,"l":100,"c":100},"back":{"_t":"CustomizationLayer","id":"2da6-171cd4de4d4-438883d6","_override":"CustomizationLayer","type":"1","h":50,"s":0,"l":100,"c":100},"hair":{"_t":"CustomizationLayer","id":"2da7-171cd4de4d4-24e8fbb1","_override":"CustomizationLayer","type":"1","h":50,"s":0,"l":100,"c":100},"bottom":{"_t":"CustomizationLayer","id":"2da8-171cd4de4d4-aa7391fb","_override":"CustomizationLayer","type":"0","h":200,"s":100,"l":100,"c":100},"eyes":{"_t":"CustomizationLayer","id":"2da9-171cd4de4d4-9308045f","_override":"CustomizationLayer","type":"0","h":200,"s":100,"l":100,"c":100},"face":{"_t":"CustomizationLayer","id":"2daa-171cd4de4d4-2fd706ed","_override":"CustomizationLayer","type":"0","h":0,"s":100,"l":100,"c":100},"shoes":{"_t":"CustomizationLayer","id":"2dab-171cd4de4d4-c87a6091","_override":"CustomizationLayer","type":"0","h":0,"s":100,"l":100,"c":100},"top":{"_t":"CustomizationLayer","id":"2dac-171cd4de4d4-fbe010d6","_override":"CustomizationLayer","type":"1","h":55,"s":0,"l":201,"c":110}}',
    '{"_t":"DollCustomization","id":"2da4-171cd4de4d4-6c3c1410","_override":"DollCustomization","gender":"male","base":{"_t":"CustomizationLayer","id":"2da5-171cd4de4d4-d1c0ea6e","_override":"CustomizationLayer","type":"0","h":0,"s":100,"l":100,"c":100},"back":{"_t":"CustomizationLayer","id":"2da6-171cd4de4d4-438883d6","_override":"CustomizationLayer","type":"0","h":69,"s":238,"l":360,"c":178},"hair":{"_t":"CustomizationLayer","id":"2da7-171cd4de4d4-24e8fbb1","_override":"CustomizationLayer","type":"0","h":69,"s":238,"l":360,"c":178},"bottom":{"_t":"CustomizationLayer","id":"2da8-171cd4de4d4-aa7391fb","_override":"CustomizationLayer","type":"1","h":208,"s":100,"l":133,"c":100},"eyes":{"_t":"CustomizationLayer","id":"2da9-171cd4de4d4-9308045f","_override":"CustomizationLayer","type":"2","h":200,"s":100,"l":100,"c":100},"face":{"_t":"CustomizationLayer","id":"2daa-171cd4de4d4-2fd706ed","_override":"CustomizationLayer","type":"2","h":0,"s":100,"l":100,"c":100},"shoes":{"_t":"CustomizationLayer","id":"2dab-171cd4de4d4-c87a6091","_override":"CustomizationLayer","type":"0","h":0,"s":0,"l":78,"c":97},"top":{"_t":"CustomizationLayer","id":"2dac-171cd4de4d4-fbe010d6","_override":"CustomizationLayer","type":"0","h":143,"s":100,"l":0,"c":100}}',
    '{"_t":"DollCustomization","id":"2da4-171cd4de4d4-6c3c1410","_override":"DollCustomization","gender":"male","base":{"_t":"CustomizationLayer","id":"2da5-171cd4de4d4-d1c0ea6e","_override":"CustomizationLayer","type":"0","h":0,"s":100,"l":100,"c":100},"back":{"_t":"CustomizationLayer","id":"2da6-171cd4de4d4-438883d6","_override":"CustomizationLayer","type":"2","h":50,"s":100,"l":100,"c":100},"hair":{"_t":"CustomizationLayer","id":"2da7-171cd4de4d4-24e8fbb1","_override":"CustomizationLayer","type":"2","h":50,"s":100,"l":100,"c":100},"bottom":{"_t":"CustomizationLayer","id":"2da8-171cd4de4d4-aa7391fb","_override":"CustomizationLayer","type":"0","h":200,"s":100,"l":0,"c":100},"eyes":{"_t":"CustomizationLayer","id":"2da9-171cd4de4d4-9308045f","_override":"CustomizationLayer","type":"1","h":133,"s":100,"l":107,"c":101},"face":{"_t":"CustomizationLayer","id":"2daa-171cd4de4d4-2fd706ed","_override":"CustomizationLayer","type":"1","h":0,"s":100,"l":100,"c":100},"shoes":{"_t":"CustomizationLayer","id":"2dab-171cd4de4d4-c87a6091","_override":"CustomizationLayer","type":"2","h":0,"s":217,"l":0,"c":360},"top":{"_t":"CustomizationLayer","id":"2dac-171cd4de4d4-fbe010d6","_override":"CustomizationLayer","type":"1","h":0,"s":100,"l":55,"c":240}}',

    // Females.

    '{"_t":"DollCustomization","id":"2da4-171cd4de4d4-6c3c1410","_override":"DollCustomization","gender":"female","base":{"_t":"CustomizationLayer","id":"2da5-171cd4de4d4-d1c0ea6e","_override":"CustomizationLayer","type":"0","h":0,"s":100,"l":100,"c":100},"back":{"_t":"CustomizationLayer","id":"2da6-171cd4de4d4-438883d6","_override":"CustomizationLayer","type":"0","h":204,"s":201,"l":101,"c":120},"hair":{"_t":"CustomizationLayer","id":"2da7-171cd4de4d4-24e8fbb1","_override":"CustomizationLayer","type":"0","h":204,"s":201,"l":101,"c":120},"bottom":{"_t":"CustomizationLayer","id":"2da8-171cd4de4d4-aa7391fb","_override":"CustomizationLayer","type":"0","h":350,"s":0,"l":100,"c":100},"eyes":{"_t":"CustomizationLayer","id":"2da9-171cd4de4d4-9308045f","_override":"CustomizationLayer","type":"2","h":200,"s":100,"l":100,"c":100},"face":{"_t":"CustomizationLayer","id":"2daa-171cd4de4d4-2fd706ed","_override":"CustomizationLayer","type":"1","h":0,"s":100,"l":100,"c":100},"shoes":{"_t":"CustomizationLayer","id":"2dab-171cd4de4d4-c87a6091","_override":"CustomizationLayer","type":"0","h":0,"s":0,"l":100,"c":100},"top":{"_t":"CustomizationLayer","id":"2dac-171cd4de4d4-fbe010d6","_override":"CustomizationLayer","type":"0","h":165,"s":0,"l":195,"c":100}}',
    '{"_t":"DollCustomization","id":"2da4-171cd4de4d4-6c3c1410","_override":"DollCustomization","gender":"female","base":{"_t":"CustomizationLayer","id":"2da5-171cd4de4d4-d1c0ea6e","_override":"CustomizationLayer","type":"0","h":0,"s":100,"l":100,"c":100},"back":{"_t":"CustomizationLayer","id":"2da6-171cd4de4d4-438883d6","_override":"CustomizationLayer","type":"1","h":50,"s":100,"l":100,"c":100},"hair":{"_t":"CustomizationLayer","id":"2da7-171cd4de4d4-24e8fbb1","_override":"CustomizationLayer","type":"1","h":50,"s":100,"l":100,"c":100},"bottom":{"_t":"CustomizationLayer","id":"2da8-171cd4de4d4-aa7391fb","_override":"CustomizationLayer","type":"1","h":200,"s":100,"l":100,"c":100},"eyes":{"_t":"CustomizationLayer","id":"2da9-171cd4de4d4-9308045f","_override":"CustomizationLayer","type":"0","h":200,"s":100,"l":100,"c":100},"face":{"_t":"CustomizationLayer","id":"2daa-171cd4de4d4-2fd706ed","_override":"CustomizationLayer","type":"0","h":0,"s":100,"l":100,"c":100},"shoes":{"_t":"CustomizationLayer","id":"2dab-171cd4de4d4-c87a6091","_override":"CustomizationLayer","type":"0","h":0,"s":0,"l":100,"c":91},"top":{"_t":"CustomizationLayer","id":"2dac-171cd4de4d4-fbe010d6","_override":"CustomizationLayer","type":"1","h":303,"s":83,"l":240,"c":100}}',
    '{"_t":"DollCustomization","id":"2da4-171cd4de4d4-6c3c1410","_override":"DollCustomization","gender":"female","base":{"_t":"CustomizationLayer","id":"2da5-171cd4de4d4-d1c0ea6e","_override":"CustomizationLayer","type":"0","h":0,"s":100,"l":100,"c":100},"back":{"_t":"CustomizationLayer","id":"2da6-171cd4de4d4-438883d6","_override":"CustomizationLayer","type":"2","h":123,"s":104,"l":269,"c":100},"hair":{"_t":"CustomizationLayer","id":"2da7-171cd4de4d4-24e8fbb1","_override":"CustomizationLayer","type":"2","h":123,"s":104,"l":269,"c":100},"bottom":{"_t":"CustomizationLayer","id":"2da8-171cd4de4d4-aa7391fb","_override":"CustomizationLayer","type":"2","h":139,"s":139,"l":201,"c":136},"eyes":{"_t":"CustomizationLayer","id":"2da9-171cd4de4d4-9308045f","_override":"CustomizationLayer","type":"1","h":200,"s":100,"l":100,"c":100},"face":{"_t":"CustomizationLayer","id":"2daa-171cd4de4d4-2fd706ed","_override":"CustomizationLayer","type":"2","h":0,"s":100,"l":100,"c":100},"shoes":{"_t":"CustomizationLayer","id":"2dab-171cd4de4d4-c87a6091","_override":"CustomizationLayer","type":"1","h":256,"s":285,"l":0,"c":101},"top":{"_t":"CustomizationLayer","id":"2dac-171cd4de4d4-fbe010d6","_override":"CustomizationLayer","type":"2","h":0,"s":0,"l":100,"c":100}}'
  ];

  return variations[id.hashCode % variations.length];
}

/// Returns a random [Point] contained by [rectangle].

Point<int> randomPoint(Rectangle<int> rectangle) {
  var result = rectangle.topLeft +
      Point(random(max(1, rectangle.width)), random(max(1, rectangle.height)));

  assert(rectangle.containsPoint(result));
  return result;
}

dynamic randomValue(List<dynamic> list) =>
    list == null || list.isEmpty ? null : list[random(list.length)];

List<Point<int>> ray(Point<int> start, Point<int> end) {
  // Points are sorted so rays from [start] to [end] are identical to rays from
  // [end] to [start].

  var sortedPoints = sortPoints([start, end]);
  start = sortedPoints[0];
  end = sortedPoints[1];

  // todo: might be able to use getLine from path-finding library

  var dx = (end.x - start.x).abs(),
      sx = start.x < end.x ? 1 : -1,
      dy = (end.y - start.y).abs(),
      sy = start.y < end.y ? 1 : -1,
      error = (dx > dy ? dx : -dy) / 2;

  var result = <Point<int>>[];

  while (true) {
    result.add(start);
    if (start == end) break;
    var temp = error;

    if (temp > -dx) {
      error -= dy;
      start = Point<int>(start.x + sx, start.y);
    }

    if (temp < dy) {
      error += dx;
      start = Point<int>(start.x, start.y + sy);
    }
  }

  return result;
}

Rectangle<num> rectangleFromCenter(Point<num> center, num width, num height) {
  var point = Point<num>(width / 2, height / 2);
  center = Point<num>(center.x, center.y);
  return Rectangle.fromPoints(center - point, center + point);
}

void registerAbility(String name, Ability ability) {
  _abilities[name] = ability;
}

void registerArmorInfo(String key, String image, Symbol slot, int defense,
        [int evasion = 0, List<int> egos = const []]) =>
    registerItemInfo(
        key,
        ItemInfo(
            image: image,
            slot: slot,
            evasion: evasion,
            defense: defense,
            egos: egos));

/// [key] should not contain "-" to avoid confusion with ids.

void registerDollInfo(String key, DollInfo info) {
  assert(!key.contains('-'));
  _dollInfo[key] = info;
}

void registerFactory(Symbol symbol, dynamic function()) {
  _factories[symbol] = function;
}

/// [key] should not contain "-" to avoid confusion with ids.

void registerItemInfo(String key, ItemInfo info) {
  assert(!key.contains('-'));
  _itemInfo[key] = info;
}

void registerItemSource(String type, String image,
        [int canPassThis = Terrain.obstacles, repeatInteraction = true]) =>
    registerDollInfo(
        type,
        DollInfo(
            moves: false,
            image: image,
            resource: true,
            canPassThis: canPassThis,
            repeatInteraction: repeatInteraction,
            interaction: (Account account, Doll doll) {
              if (!account.tappedItemSources.containsKey(doll.id) &&
                  !account.doll.warm(#left) &&
                  account.collectFromItemSource(doll, type)) {
                account.doll.warmUp(#left, CoolDown.average);

                // Rewards nearby players. Chests are not shared because they
                // are not repeatable.

                if (type != 'chest')
                  doll.playersInRange
                      .where((looter) =>
                          looter.id != account.id && looter.canLoot(doll))
                      .forEach(
                          (looter) => looter.collectFromItemSource(doll, type));
              }
            }));

void registerWeaponInfo(String key, int damage,
        [String missile, List<int> egos]) =>
    registerItemInfo(
        key,
        ItemInfo(
            damage: damage,
            missile: missile,
            coolDown: CoolDown.average,
            egos: egos ?? const [],
            slot: #weapon));

void removeAllBut(Map<dynamic, dynamic> map, Iterable<dynamic> keys) {
  if (map.isNotEmpty)
    List.from(map.keys.where((key) => !keys.contains(key))).forEach(map.remove);
}

String removeLast(String string, Pattern pattern) =>
    string.substring(0, string.lastIndexOf(pattern));

/// Replaces the contents of [map] with the contents of [other] with as few
/// assignments as possible.

void replaceMap(Map<dynamic, dynamic> map, Map<dynamic, dynamic> other) {
  List.from(map.keys.where((key) => !other.containsKey(key)))
      .forEach(map.remove);

  other.forEach((key, value) {
    if (map[key] != value) map[key] = value;
  });
}

void retryOnError(dynamic function()) {
  runZoned(function, onError: (error, trace) {
    Logger.root.severe(error);
    Logger.root.severe(trace);
    retryOnError(function);
  });
}

String reverseString(String text) => text.split('').reversed.join();

num round(num value, int precision) {
  var factor = pow(10, precision);
  return (value * factor).floor() / factor;
}

int roundDistance(Point<int> start, Point<int> end) =>
    start.distanceTo(end).round();

num safeLog(num value) {
  if (value == 0) return 0;
  return log(value);
}

/// Converts non-word characters to underscores. Leading and trailing
/// underscores are then stripped. The result is converted to lower case and
/// has a max length of [maxLength]. If [maxLength] is less than 0 then it is
/// treated as infinite.

String sanitizeName(String string, [int maxLength = 20]) {
  var result = strip(string.replaceAll(RegExp('\\W'), '_'), '_').toLowerCase();

  return maxLength < 0
      ? result
      : result.substring(0, min(maxLength, result.length));
}

String setBonus(String text, int bonus) {
  var replacement = bonus > 0 ? '+$bonus' : '';

  return text.startsWith(_upgradePattern)
      ? text.replaceFirst(_upgradePattern, '$replacement').trim()
      : '$replacement $text'.trim();
}

/// Converts [value] from a [BigInt], [String], or [num] to an [int]. If
/// [value] is a [num], it is floored. If [value] is null, 0 is returned.

int small(dynamic value) => big(value).toInt();

Map<dynamic, dynamic> sortMap(Map<dynamic, dynamic> map,
    [int compare(dynamic first, dynamic second)]) {
  var result = {};

  List.from(map.keys)
    ..sort(compare)
    ..forEach((key) => result[key] = map[key]);

  return result;
}

List<Point<int>> sortPoints(List<Point<int>> points) =>
    List<Point<int>>.from(points)
      ..sort((first, second) => first.x == second.x
          ? first.y.compareTo(second.y)
          : first.x.compareTo(second.x));

int stageToFloor(String stage) {
  if (stage == null ||
      stage.startsWith('tutorial') ||
      stage.startsWith('bonus')) return 0;

  return parseInteger(RegExp(r'\d+').firstMatch(stage).group(0)) + 1;
}

/// Converts an arbitrary string to an arbitrary HTML color.

String stringColor(String string) =>
    '#' +
    [
      (string.hashCode >> 16) & 255,
      (string.hashCode >> 8) & 255,
      string.hashCode & 255
    ].map((value) => value.toRadixString(16)).join();

/// Removes [chars] from the start and end of [string].

String strip(String string, String chars) {
  if (string.startsWith(chars)) string = string.substring(chars.length);

  if (string.endsWith(chars))
    string = string.substring(0, string.lastIndexOf(chars));

  return string;
}

List<dynamic> takeLast(List<dynamic> list, int amount) =>
    List.from(List.from(list.reversed.take(amount)).reversed);

/// Returns true if [timestamp] is in the current month.

bool thisMonth(int timestamp) {
  var date = DateTime.fromMillisecondsSinceEpoch(timestamp),
      currentDate = DateTime.now();

  return date.year == currentDate.year && date.month == currentDate.month;
}

int triangleNumber(int value) {
  assert(value >= 0);
  return (value * value + value) ~/ 2;
}

Future<dynamic> until(bool function(), [int delay]) async {
  await Future.doWhile(() => Future.delayed(
      Duration(milliseconds: delay ?? ServerGlobals.tickDelay),
      () => !function()));

  return null;
}

/// Returns a [Wrapper]'s [internal] value.

dynamic unwrap(dynamic value) => value is Wrapper ? value.internal : value;

/// Returns a string that's always unique.

String uuid() =>
    [count(), now, random()].map((value) => value.toRadixString(16)).join('-');

dynamic valueAt(List<dynamic> list, int index) =>
    list != null && index < list.length ? list[index] : null;

List<String> whatDrops(String comparisonText) {
  var result = <String>[];

  _dollInfo.forEach((key, info) {
    if (info?.loot?.all?.any((Item item) =>
            item.comparisonText ==
            Item.fromDisplayText(comparisonText).comparisonText) ==
        true) result.add(key);
  });

  return result;
}
