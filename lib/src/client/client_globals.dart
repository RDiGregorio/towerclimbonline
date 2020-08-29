part of client;

/// Holds variables used by multiple components.

class ClientGlobals {
  static int clickedActionIndex, fps = 0, start = now;

  static String currentView = '',
      currentModal,
      currentModalTitle,
      currentInputModal,
      currentInputModalTitle,
      currentModalMessage,
      preventLoginCookie = 'tower climb online prevent login',
      username;

  /// Keeps track of the input modals for cleanup.

  static final List<dynamic> inputModals = [];
  static final List<Item> craftingOptions = [];
  static Session session;
  static bool tradeAccepted = false;
  static String loginMessage = '';

  static Future<num> _zoomThrottle;

  static num get zoom => _options['zoom'] ?? 3;

  static void set zoom(dynamic value) {
    if (value is String) value = double.parse(value);
    if (value == zoom) return;
    if (session?.options != null) session.options['zoom'] = value;

    // Messages to the server are throttled because some players like to play
    // with the zoom and that can cause spam.

    if (_zoomThrottle == null) {
      _zoomThrottle = Future.delayed(const Duration(milliseconds: 100), () {
        session?.remote(#setOption, ['zoom', zoom]);
        return null;
      });
    }
  }

  static Map<String, dynamic> get _options => session?.options ?? const {};
}
