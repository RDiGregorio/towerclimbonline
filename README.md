**This project was originally written for Dart 1. I'm currently in the process of porting it to Dart 3.**

Some components have been commented out to get this to compile. However, there are too many runtime type errors to
reasonably port this. Just sticking with Dart 2 should be fine.

~~This project requires a PostgreSQL database.~~

I need to update database drivers. The current code is using a mock database.

**Setup**

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