part of util;

class Effect {
  final Doll source;
  final int damage, accuracy;
  List<int> egos;
  Map<int, int> sourceNonWeaponEgos = {};
  int delay;

  Effect(this.source,
      {this.delay = 0, this.damage, this.accuracy, this.egos = const []}) {
    if (source?.account?.god == 'qazlal' &&
        this.damage != null &&
        !egos.contains(Ego.healing) &&
        !egos.contains(Ego.charm))
      egos = List<int>.from(
          Set<int>.from(egos)..addAll([Ego.fire, Ego.ice, Ego.electric]));

    if (source != null)
      source.nonWeaponEquipment.forEach((item) => item.egos.forEach((ego) {
            sourceNonWeaponEgos[ego] ??= 0;
            sourceNonWeaponEgos[ego]++;
          }));
  }

  bool causesPvP(Doll doll) {
    if (source?.player == true && doll.player) return true;
    return false;
  }

  bool causesRetaliation(Doll doll) {
    // Healing doesn't cause retaliation.

    if (source == null || egos.contains(Ego.healing)) return false;
    return true;
  }
}
