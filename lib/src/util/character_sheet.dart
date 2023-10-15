part of util;

class CharacterSheet extends OnlineObject {
  CharacterSheet() {
    internal['combat'] = Stat();
    internal['fishing'] = Stat();
    internal['mining'] = Stat();
    internal['woodcutting'] = Stat();
    internal['cooking'] = Stat();
    internal['crafting'] = Stat();
    internal['metalworking'] = Stat();
    internal['crime'] = Stat();
    internal['summoning'] = Stat();
    internal['slay'] = Stat();

    // Attributes.

    resetAttributes(10);
  }

  int? get agility => internal['agi'];

  int get agilityBuffs => max<int>(0, internal['agi buff'] ?? 0);

  void set agilityBuffs(int value) {
    internal['agi buff'] = value;
  }

  Iterable<int?> get attributes =>
      [agility, strength, dexterity, intelligence, vitality];

  Stat? get combat => internal['combat'];

  Stat? get cooking => internal['cooking'];

  Stat? get crafting => internal['crafting'];

  Stat? get crime => internal['crime'];

  int? get dexterity => internal['dex'];

  int get dexterityBuffs => max<int>(0, internal['dex buff'] ?? 0);

  void set dexterityBuffs(int value) {
    internal['dex buff'] = value;
  }

  Stat? get fishing => internal['fishing'];

  int get healthBuffs => max<int>(0, internal['hp buff'] ?? 0);

  void set healthBuffs(int value) {
    internal['hp buff'] = value;
  }

  int? get intelligence => internal['int'];

  int get intelligenceBuffs => max<int>(0, internal['int buff'] ?? 0);

  void set intelligenceBuffs(int value) {
    internal['int buff'] = value;
  }

  Stat? get metalworking => internal['metalworking'];

  Stat? get mining => internal['mining'];

  Stat? get slaying => internal['slay'];

  int get spentPoints =>
      attributes.fold(0, (result, attribute) => result + attribute!);

  Iterable<dynamic> get stats =>
      internal.values.where((value) => value is Stat);

  int? get strength => internal['str'];

  int get strengthBuffs => max<int>(0, internal['str buff'] ?? 0);

  void set strengthBuffs(int value) {
    internal['str buff'] = value;
  }

  Stat? get summoning => internal['summoning'];

  BigInt get totalExperience => stats.fold<BigInt>(BigInt.zero,
      (result, stat) => result + parseFormattedBigInt(stat.experienceText));

  String get totalExperienceText => formatBigInt(totalExperience);

  int get totalLevel => stats.fold(0, (result, stat) => result + stat.level as int);

  int get totalPoints => 50 + triangleNumber(combat!.level);

  int get unspentPoints => max(0, totalPoints - spentPoints);

  int? get vitality => internal['vit'];

  Stat? get woodcutting => internal['woodcutting'];

  void gainStat(String stat, [int amount = 1]) {
    amount = min(amount, unspentPoints);

    switch (stat) {
      case 'strength':
        internal['str'] = max<int>(1, internal['str'] + amount);
        return;
      case 'agility':
        internal['agi'] = max<int>(1, internal['agi'] + amount);
        return;
      case 'vitality':
        internal['vit'] = max<int>(1, internal['vit'] + amount);
        return;
      case 'intelligence':
        internal['int'] = max<int>(1, internal['int'] + amount);
        return;
      case 'dexterity':
        internal['dex'] = max<int>(1, internal['dex'] + amount);
        return;
    }

    throw ArgumentError(stat);
  }

  void resetAttributes([int value = 1]) {
    internal
      ..['agi'] = value
      ..['dex'] = value
      ..['int'] = value
      ..['str'] = value
      ..['vit'] = value;
  }
}
