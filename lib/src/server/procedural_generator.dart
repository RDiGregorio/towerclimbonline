part of server;

Future<dynamic> _isolate(SendPort sendPort) async {
  ProceduralGenerator._placeholderData ??=
      json.decode(await File('dat/placeholder.json').readAsString());

  var receivePort = ReceivePort();
  sendPort.send(receivePort.sendPort);

  var message = await receivePort.first,
      data = ProceduralGenerator.dungeon(message[0]);

  await File('dat/procgen${message[0]}_0_0.json')
      .writeAsString(json.encode(data));

  // FIXME: should use $CATALINA_HOME

  await ImageGenerator(data)
      .generate('procgen${message[0]}_0_0', '/var/lib/tomcat8/webapps/ROOT');

  message[1].send(null);
  receivePort.close();
}

class ProceduralGenerator {
  static Map<String, dynamic> _placeholderData;

  Future<dynamic> generate(int floor) async {
    // Floor x (as displayed in the game) has a [floor] of x - 1.

    var receivePort = ReceivePort();

    // This takes a while, so it's done in a thread.

    await Isolate.spawn(_isolate, receivePort.sendPort);
    await _send(await receivePort.first, floor);
  }

  Future<dynamic> _send(SendPort sendPort, int floor) {
    var receivePort = ReceivePort();
    sendPort.send([floor, receivePort.sendPort]);
    return receivePort.first;
  }

  static Map<String, dynamic> dungeon(int floor) {
    var data = <String, dynamic>{
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      'flags': ['procgen'],
      'cells': []
    };

    for (int i = 0; i < 100; i++) data['cells'].add(List(100));
    var traversable = [], theme = Theme.random(floor);

    Dungeon().tiles.forEach((point, value) {
      switch (value) {
        case Dungeon.TILE_FLOOR:
          traversable.add(point);
          data['cells'][point.x][point.y] = [null, null, theme.floor];
          break;
        case Dungeon.TILE_WALL:
          data['cells'][point.x][point.y] = ['#', theme.wall, null];
          break;
      }
    });

    // Prevents dolls from being placed adjacent to walls.

    var set = Set.from(traversable);
    traversable.retainWhere((point) => adjacent(point).every(set.contains));

    for (int i = 0; i < 100; i++) {
      var doll;

      if (i == 0) {
        // high floors have a 1/3 chance gods or ascended enemies as a boss.

        if (floor + 1 >= Session.maxFloor) {
          doll = 'enryu';
        } else if (floor >= 50 && random(3) == 0)
          doll = randomValue([
            // Gods.

            'elyvilon',
            'makhleb',
            'lugonu',
            'trog',
            'dithmenos',

            // Ascended.

            'ascended hero',
            'ascended gunslinger',
            'ascended wizard',
            'ascended harambe',
            'popped collar chad',
            'stacy'
          ]);
        else
          doll = randomValue(theme.bosses);
      }

      // 5 chests, 1 altar, and 10 resources per stage.

      else if (i <= 5)
        doll = 'chest';
      else if (i <= 6)
        doll = randomValue(const [
          'makhleb altar',
          'elyvilon altar',
          'dithmenos altar',
          'trog altar',
          'lugonu altar',
          'gozag altar',
          'fedhas altar',
          'xom altar',
          'ashenzari altar',
          'okawaru altar',
          'qazlal altar'
        ]);
      else if (i <= 16 && theme.resources.isNotEmpty)
        doll = randomValue(theme.resources);
      else
        // A special doll appears about once every 12 floors.

        doll = random(1000) == 0
            ? randomValue(['wanderer'])
            : randomValue(theme.dolls);

      if (traversable.isEmpty) continue;
      Point<int> point = traversable.removeAt(random(traversable.length));

      if (const ['fish', 'shellfish', 'shark', 'stardust fish']
          .contains(doll)) {
        var water = List.from(adjacent(point));
        water.retainWhere(traversable.contains);
        water.add(point);

        // FIXME: water can be placed next to a wall, blocking a path or causing
        //  unreachable fish.

        if (water.every((point) => adjacent(point).every(set.contains))) {
          water.forEach((point) {
            traversable.remove(point);
            data['cells'][point.x][point.y][2] = theme.water;
          });

          point = randomValue(List.from(water)..remove(point));
        } else

          // If water can't be placed, the resource becomes a doll.

          doll = randomValue(theme.dolls);
      }

      data['cells'][point.x][point.y][0] = '@$doll';
    }

    return data;
  }
}
