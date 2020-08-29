import 'dart:convert';
import 'dart:io';

import 'package:towerclimbonline/config.dart';
import 'package:towerclimbonline/server.dart';

void main() {
  WebSocket.connect('ws://${Config.debug ? Config.debugHost : Config.host}' +
          ':${Config.port}')
      .then((socket) async => socket
        ..add(json.encode([
          'adminCommand',
          ['kill', (await secret)['admin password']],
          0
        ]))
        ..close());
}
