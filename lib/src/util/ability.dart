part of util;

class Ability {
  final int range;
  final bool combat;
  final Function use;

  Ability({this.range = 1, this.combat = true, bool this.use(Doll source)});
}
