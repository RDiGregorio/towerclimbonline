part of util;

/// Text that appears over a [Doll] that represents an effect or damage.

class Splat {
  final int time;
  final String? text, classes, id = uuid();
  final Map<String, String> style = {};

  Splat(this.text, this.time, this.classes);
}
