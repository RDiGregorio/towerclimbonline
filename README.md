This project requires a PostgreSQL database.

**Setup**

1. Set `debug = true` in lib/config.dart when running locally.
2. Run `webdev build` to build the project.
3. Run `dart bin/main.dart` to start the server.

Be sure to set the correct host in config.dart and secrets in secret.yaml!

If you have any issues, possible solutions are:

1. Make sure port forwarding is set up on your router.
2. Make sure your firewall isn't blocking any connections.
3. Make sure Tomcat can access outside connections.

**Tools**

1. Dart (https://www.dartlang.org/)

**Resources**

1. https://opengameart.org/
2. https://certbot.eff.org/

**Observatory**

For Google Compute Engine:

1. Generate private keys (locally, not on the VM)
2. Add them under https://console.cloud.google.com/compute/metadata
3. Run `sudo ssh -i ./observe -L8181:127.0.0.1:8181 username@towerclimbonline.com` with your username
3. Open your browser to http://localhost:8181