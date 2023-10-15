~~This project requires a PostgreSQL database.~~

I need to update database drivers. The current code is using a mock database.

**Setup**

To get the correct version of Dart and Webdev (use an admin terminal):
1. Run `choco install dart-sdk --version 2.10.5 --allow-downgrade --force`
2. Run `dart pub global activate webdev`

To build and run the application:
1. Set `debug = true` in lib/config.dart when running locally.
2. Run `webdev build` to build the project.
3. Run `dart bin/main.dart` to start the server.

Be sure to set the correct host in config.dart and secrets in secret/secret.yaml!

**Debugging**

If you have any issues, possible solutions are:

1. Make sure port forwarding is set up on your router.
2. Make sure your firewall isn't blocking any connections.
3. Make sure Tomcat can access outside connections.

You can debug the client using WebStorm by right-clicking and running web/index.html.

**Tools**

1. Dart (https://www.dartlang.org/)

**Resources**

1. https://opengameart.org/
2. https://certbot.eff.org/