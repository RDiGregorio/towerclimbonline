part of util;

class Effect {
  final Doll source;
  final int damage, accuracy;
  final List<int> egos;
  Map<int, int> sourceNonWeaponEgos = {};
  int delay;

  Effect(this.source,
      {this.delay = 0, this.damage, this.accuracy, this.egos = const []}) {
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

    if (doll.info?.moves == false) {
      // todo: this is where stuck is needed
    }

    return true;
  }
}
