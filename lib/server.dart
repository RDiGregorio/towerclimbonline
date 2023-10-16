library server;

import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'dart:math';
import 'dart:mirrors';

import 'package:image/image.dart' hide Point;
import 'package:logging/logging.dart';
import 'package:path/path.dart';
import 'package:piecemeal/piecemeal.dart';
import 'package:postgresql2/postgresql.dart';
import 'package:towerclimbonline/config.dart';
import 'package:towerclimbonline/util.dart';
import 'package:yaml/yaml.dart';

part 'src/server/dungeon.dart';

part 'src/server/image_generator.dart';

part 'src/server/procedural_generator.dart';

final Map<WebSocket, String> addresses = {};

// [Config] is visible to the client, so [databasePassword] is set here.

HttpServer? httpServer, httpsServer;
Future<Connection>? _postgresConnection;

Future<int?> get availableMemory async => runZoned(
        () async => parseInteger(List.from(RegExp(r'\d+')
            .allMatches((await Process.run('free', const ['-m'])).stdout)
            .map((match) => match.group(0)))[5]), onError: (error, trace) {
      Logger.root.severe('$error');
      Logger.root.severe('$trace');
      return 0;
    });

Future<Connection> get postgresConnection async {
  if (_postgresConnection == null) {
    Logger.root.info('opening database connection');

    _postgresConnection = connect('postgres://' +
        (Config.debug
            ? Config.debugDatabaseUsername
            : Config.databaseUsername) +
        ':' +
        (Config.debug
            ? Config.debugDatabasePassword
            : (await secret)['database password']!) +
        '@' +
        (Config.debug ? Config.debugDatabaseHost : Config.databaseHost) +
        ':5432/postgres');
  }

  var result = (await _postgresConnection)!;

  // Reopens closed connections.

  if (const [ConnectionState.closed].contains(result.state)) {
    _postgresConnection = null;
    return postgresConnection;
  }

  return (await _postgresConnection)!;
}

Future<Map<String?, String?>> get secret async => Map<String?, String?>.from(
    await loadYaml(await File('secret/secret.yaml').readAsString()));

Iterable<FileSystemEntity> files(String path, String ext) =>
    Directory(path).listSync().where((file) => extension(file.path) == ext);

Stream<WebSocket> getSecureWebSockets(
    int port, SecurityContext context) async* {
  httpsServer =
      await HttpServer.bindSecure(InternetAddress.anyIPv6, port, context);
  Logger.root.info('listening on port $port');

  await for (var request in httpsServer!.handleError(_onError)) {
    var socket = await runZoned(
        (() => WebSocketTransformer.isUpgradeRequest(request)
            ? WebSocketTransformer.upgrade(request).catchError((error, trace) {
                Logger.root.severe('$error');
                Logger.root.severe('$trace');
                return null;
              })
            : null) as FutureOr<WebSocket> Function(), onError: (error, trace) {
      Logger.root.severe('$error');
      Logger.root.severe('$trace');
    });

    yield socket;
  }

  if (!ServerGlobals.shuttingDown)
    throw StateError('stopped listening on port $port');
}

Stream<WebSocket> getWebSockets(int port) async* {
  httpServer = await HttpServer.bind(InternetAddress.anyIPv6, port);
  Logger.root.info('listening on port $port');

  await for (var request in httpServer!.handleError(_onError)) {
    var socket = await runZoned(
        (() => WebSocketTransformer.isUpgradeRequest(request)
            ? WebSocketTransformer.upgrade(request).catchError((error, trace) {
                Logger.root.severe('$error');
                Logger.root.severe('$trace');
                return null;
              })
            : null), onError: (error, trace) {
      Logger.root.severe('$error');
      Logger.root.severe('$trace');
    });

    // FIXME: this is a temp crutch
    // don't go to production with this null check!

    yield socket!;
  }

  if (!ServerGlobals.shuttingDown)
    throw StateError('stopped listening on port $port');
}

/// The underlying socket adds "done" events to the [Session]'s [internal] when
/// closed and is closed on "kick" events.

void host(int port, Wrapper<ObservableMap> function(WebSocket socket),
    {void onError(dynamic error, StackTrace trace)?}) {
  Future(() async => retryOnError(() async {
        if (ServerGlobals.shuttingDown) return;

        await for (var socket in getWebSockets(port))
          _host(socket, function, onError);
      }));

  Future(() async => retryOnError(() async {
        if (ServerGlobals.shuttingDown) return;
        var context = SecurityContext.defaultContext,
            path = '/etc/letsencrypt/live/www.towerclimbonline.com';

        try {
          if (!Config.debug)
            context
              ..useCertificateChain('$path/fullchain.pem')
              ..usePrivateKey('$path/privkey.pem');
        } catch (error, trace) {
          Logger.root.severe(error);
          Logger.root.severe(trace);
        }

        await for (var socket in getSecureWebSockets(port + 1, context))
          _host(socket, function, onError);
      }));
}

Future<Map<Point<int>, int>> newCollisionMap(
    Stage stage, String? name, Point<int> offset) async {
  // FIXME: this is poorly named, as it adds dolls, sets a timestamp, etc.

  var dolls = 0, chests = 0, procedural = false as bool?;

  List<dynamic> tilesFromEditor(String string) {
    var data = json.decode(string), cells = data['cells'], result = [];
    stage.timestamp = data['timestamp'] ?? 0;

    if (data['flags'] is List) {
      procedural = data['flags'].contains('procgen');

      stage.internal['flags'] =
          ObservableMap(mapFromList(List<String>.from(data['flags'])));
    }

    for (var x = 0; x < cells.length; x++) {
      result.add([]);

      for (var y = 0; y < cells.length; y++)
        result[x].add(Tile(x, y, cells[x][y]));
    }

    return result;
  }

  var result = tilesFromEditor((await File('dat/$name.json').readAsString()))
      .expand((tiles) => tiles)
      .fold({}, (dynamic section, tile) {
    var point = Point<int>(tile.x, tile.y),
        value = tile.properties['value'] ?? -1,
        spawn = tile.properties['spawn'];

    if (spawn != null) {
      // Names must be deterministic and unique.

      var id = '_' +
          sanitizeName(name!, -1) +
          '_${tile.x}_${tile.y}_' +
          sanitizeName(spawn, -1);

      // Fixes portals from older stages.

      spawn = _fixPortals(spawn);
      var doll =
          Doll(spawn, id, false, procedural! ? stageToFloor(name) : null);

      dolls++;
      if (spawn == 'chest') chests++;
      stage.addDoll(doll, Point<int>(point.x + offset.x, point.y + offset.y));
    }

    if (value >= 0) section[point] = value;
    return section;
  });

  if (!stage.flags.containsKey('procgen')) {
    // Each terrain section should have the same number of non-player dolls for
    // smooth dungeon progression.

    var ignore = const ['tutorial0_0_0', 'bonus2_0_0'];

    if (dolls != 100 && dolls != 0 && !ignore.contains(name))
      Logger.root.info('warning: $name has an invalid object count of $dolls');

    if (chests != 5 && chests != 0 && !ignore.contains(name))
      Logger.root.info('warning: $name has an invalid chest count of $chests');
  }

  return Map<Point<int>, int>.from(result);
}

Future<ResourceManager> newPostgresResourceManager(String table) async {
  // FIXME: I need to use a new database library. This is a temporary hack just
  // to get the project running again locally.
  return newMockResourceManager();

  await (await postgresConnection)
      .execute('CREATE SCHEMA IF NOT EXISTS tables');

  await (await postgresConnection).execute('CREATE TABLE IF NOT EXISTS ' +
      'tables.$table (id text PRIMARY KEY, data text)');

  return ResourceManager(
      exists: (key) async => (await (await postgresConnection).query(
          'SELECT EXISTS (SELECT 1 FROM tables.$table WHERE id = @id)',
          {'id': key}).toList())[0][0],
      save: (key, value, cleanup) async {
        var query = 'INSERT INTO tables.$table (id, data) SELECT @id, @data ' +
            'WHERE NOT EXISTS (SELECT 1 FROM tables.$table WHERE id = @id); ' +
            'UPDATE tables.$table SET data = @data WHERE id = @id';

        await (await postgresConnection).execute(query, {
          'id': key,
          'data': json.encode(value, toEncodable: mapWrapperEncoder)
        });

        cleanup();
      },
      load: (key) async => json.decode(
          (await (await postgresConnection).query(
              'SELECT data FROM tables.$table WHERE id = @id',
              {'id': key}).toList())[0][0],
          reviver: (key, value) =>
              mapWrapperDecoder(key, value, safety: (key, value) => value is Map ? ObservableMap(value as Map<String?, dynamic>) : value)));
}

void output(dynamic message) {
  if (Config.debug) {
    print(message);
    //return;
  }

  Future(() async {
    (await File('output/log.txt').create(recursive: true))
        .writeAsStringSync('$message\n', mode: FileMode.append);
  });
}

Future<Stream<Row>> query(String query) async =>
    (await postgresConnection).query(query);

String _fixPortals(String infoName) {
  if (infoName.startsWith('portal')) {
    int index = int.parse(infoName.replaceFirst('portal', ''));
    return index.isEven ? 'up stairs' : 'down stairs';
  }

  return infoName;
}

void _host(WebSocket socket, Wrapper<ObservableMap> function(WebSocket socket),
    void onError(dynamic error, StackTrace trace)?) {
  runZoned(() {
    if (socket == null) return;
    ServerGlobals.sockets.add(socket);
    var done = false;

    close() {
      done = true;
      socket.close();
    }

    ready() => !done && socket.readyState == WebSocket.open;

    send(value) {
      if (ready())
        value is ObservableEvent && value.type == 'done'
            ? close()
            : socket.add(json.encode(value, toEncodable: mapWrapperEncoder));
    }

    var instance = function(socket);

    Future(() async {
      await socket.done;
      ServerGlobals.sockets.remove(socket);
      unwrap(instance).addEvent(ObservableEvent(type: 'done'));
    });

    Future(() async {
      await for (String value in socket)
        runZoned(() async {
          var list = json.decode(value);

          try {
            send([
              await Function.apply(
                  reflect(instance).getField(Symbol(list[0])).reflectee,
                  list[1]),
              list[2]
            ]);
          } catch (error) {
            Logger.root.severe(value);
            rethrow;
          }
        }, onError: onError);
    });

    Future(() async {
      await for (var event in unwrap(instance).getEvents())
        event.type == 'kick' ? close() : send(event);
    });

    send(ObservableEvent(type: 'change', data: {'value': instance}));
  }, onError: onError);
}

void _onError(Object error, StackTrace stackTrace) {
  if (error is SocketException && error.osError != null) {
    // So far, these errors have been logged, and have been harmless:
    // Connection reset by peer (error code 104).
    // Broken pipe (error code 32).

    Logger.root.info(error.osError!.message);
    return;
  }

  throw error;
}
