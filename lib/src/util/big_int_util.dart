part of util;

class BigIntUtil {
  static BigInt clamp(BigInt value, BigInt minValue, BigInt maxValue) =>
      min(max(value, minValue), maxValue);

  static BigInt max(BigInt first, BigInt second) =>
      first < second ? second : first;

  static BigInt min(BigInt first, BigInt second) =>
      second < first ? second : first;

  static BigInt multiplyByDouble(BigInt first, num second,
          [int precision = 1000]) =>
      first * big(second * precision) ~/ big(precision);

  static BigInt randomDivide(BigInt value, BigInt divideBy) {
    BigInt result = value ~/ divideBy;

    // FIXME: instead of a coin flip, something like 2.25 should round down 75%
    // of the time and round up 25% of the time.

    if (value % divideBy == BigInt.zero || randomBool) return result;
    return result + BigInt.one;
  }
}
