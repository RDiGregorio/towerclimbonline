library config;

// [Config] is visible to the client, so secrets are not set here.

class Config {
  static const bool debug = true, app = false, hidePlayers = false;
  static const Duration emailResetDelay = Duration(days: 7);

  static const String

      // Production configuration.

      host = '35.188.224.75',
      databaseUsername = 'postgres',
      databaseHost = '35.190.187.232',

      // Debug configuration.

      debugHost = 'localhost',
      debugDatabaseUsername = 'postgres',
      debugDatabaseHost = 'localhost',
      debugDatabasePassword = 'password';

  static const int port = 9999;
}
