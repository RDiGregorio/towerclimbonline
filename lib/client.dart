library client;

import 'dart:async';
import 'dart:html';
import 'package:towerclimbonline/util.dart';

part 'src/client/client_globals.dart';

Function? _handleInputModalSubmit;

void animationLoop(void function()) {
  function();

  Future(() async {
    // [now] is set so that Angular doesn't throw errors when things based on
    // the time change between state checks.

    now = DateTime.now().millisecondsSinceEpoch;
    await window.animationFrame;
    animationLoop(function);
  });
}

void clearCookies() => List.from(window.localStorage.keys)
    .where((key) => key.startsWith('towerclimbonline/'))
    .forEach(window.localStorage.remove);

Future<WebSocket?> getSecureSocket(String host, int port) async {
  var socket = WebSocket('wss://$host:$port');
  await until(() => socket.readyState != WebSocket.CONNECTING);
  return socket.readyState == WebSocket.OPEN ? socket : null;
}

/// Returns null if the connection fails.

Future<WebSocket?> getSocket(String host, int port) async {
  var socket = WebSocket('ws://$host:$port');
  await until(() => socket.readyState != WebSocket.CONNECTING);
  return socket.readyState == WebSocket.OPEN ? socket : null;
}

void handleInputModalSubmit(String? input) {
  if (_handleInputModalSubmit != null) _handleInputModalSubmit!(input);
}

void hideModal() => querySelector('button.close')?.click();

/// Fixes routing issues with Firefox.

void navigate(String url) {
  window.open(url, '');
}

void reload() {
  // The "session ended" view should always be manually reloaded.

  if (ClientGlobals.currentView != 'end') window.location.reload();
}

/// You still need to use [data-toggle] and [data-target] in the template or the
/// modal won't appear.

void showInputModal(String title, String modal, [void onSubmit(String input)?]) {
  ClientGlobals.inputModals.forEach((inputModal) => inputModal.input = null);
  ClientGlobals.currentInputModalTitle = title;
  ClientGlobals.currentInputModal = modal;
  _handleInputModalSubmit = onSubmit;
}

void showModal(String title, String modal) {
  ClientGlobals.currentModalTitle = title;
  ClientGlobals.currentModal = modal;
}
