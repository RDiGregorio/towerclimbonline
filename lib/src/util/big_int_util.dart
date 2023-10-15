part of util;

class BigIntUtil {
  static BigInt clamp(BigInt value, BigInt minValue, BigInt maxValue) =>
      min(max(value, minValue), maxValue);

  static BigInt max(BigInt first, BigInt second) =>
      first < second ? second : first;

  static BigInt min(BigInt first, BigInt second) =>
      second < first ? second : first;

  static BigInt multiplyByDouble(BigInt first, num second) =>
      first * big(second * maxInt)! ~/ big(maxInt)!;

  static BigInt percent(BigInt value, num percent) =>
      multiplyByDouble(value, percent) ~/ big(100)!;

  static BigInt? random(BigInt max) => max > big(maxInt)!
      ? random(max ~/ BigInt.two)! * BigInt.two + big(_random.nextInt(2))!
      : big(_random.nextInt(max.toInt()));

  static BigInt triangleNumber(BigInt value) {
    assert(value >= BigInt.zero);
    return (value * value + value) ~/ BigInt.two;
  }
}
