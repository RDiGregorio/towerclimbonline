part of util;

class DollInfo extends OnlineObject {
  final Function? interaction, passive;
  final DropTable? loot;
  final Map<String, dynamic> equipped = {};
  final Symbol? source;
  final int attackRange, difficulty;

  final bool aggro,
      moves,
      repeatInteraction,
      boss,
      hidden,
      preventsPvP,
      resource;

  final String? image, tappedImage, overheadText;

  final List<String> abilities, killFlags;

  DollInfo(
      {int walkingCoolDown = 400,
      this.difficulty = 1,
      this.attackRange = 1,
      this.source,
      this.resource = false,
      int thisCanPass = Terrain.land,
      int canPassThis = Terrain.doll,
      this.boss = false,
      this.hidden = false,
      this.aggro = true,
      this.moves = true,
      this.preventsPvP = false,
      this.repeatInteraction = false,
      this.image,
      this.tappedImage,
      this.loot,
      this.overheadText,
      Map<String, dynamic>? equipped,
      this.abilities = const [],
      this.killFlags = const [],
      void this.passive(Account account, Doll doll)?,
      void this.interaction(Account account, Doll doll)?}) {
    assert(difficulty > 0);
    equipped ??= {};
    this.equipped.addAll(equipped);

    // Only the values used by players need to be internal. The passing values
    // are needed because they're set on account creation.

    internal.addAll({
      'speed': walkingCoolDown,
      'this can pass': thisCanPass,
      'can pass this': canPassThis,
    });
  }

  int get agility => _points ~/ 5;

  int? get canPassThis => internal['can pass this'];

  int get dexterity => _points ~/ 5;

  int get intelligence => _points ~/ 5;

  int get level => dollLevel(difficulty, boss);

  int get strength => _points ~/ 5;

  int? get thisCanPass => internal['this can pass'];

  int get vitality => _points ~/ 5;

  int? get walkingCoolDown => internal['speed'];

  int get _points => 50 + triangleNumber(level);

  int adjustedAttribute(int difficulty) =>
      (50 + triangleNumber(dollLevel(difficulty, boss))) ~/ 5;
}
