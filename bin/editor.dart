import 'dart:convert';
import 'dart:io';

import 'package:towerclimbonline/server.dart';

// TODO: make this reusable for generating instances

void main() {
  getWebSockets(9998).listen((socket) {
    socket.listen((value) {
      try {
        var list = json.decode(value);

        if (list[0] == 'load') {
          print('loading...');
          socket.add(File('dat/${list[1]}.json').readAsStringSync());
          print('done!');
        } else if (list[0] == 'save') {
          print('saving...');

          var objectCount = List<dynamic>.from(list[2]['cells'])
              .expand((list) => list)
              .where((list) => list != null && list[0]?.startsWith('@') == true)
              .length;

          print('found $objectCount objects...');

          // Writes the data.

          File('dat/${list[1]}.json').writeAsStringSync(json.encode(list[2]));

          // Writes the image.

          ImageGenerator(list[2]).generate(list[1], null);
          print('done!');
        } else if (list[0] == 'gen') {
          Directory('dat').listSync().forEach((file) {
            var path = file.path.replaceAll('.json', '').split('\\').last;

            // Handles a file system issue on some operating systems.

            if (path.startsWith('dat/')) path = path.replaceFirst('dat/', '');

            // Procedurally generated floors are ignored by the editor.

            if (path.startsWith('procgen')) return;
            print('generating $path...');

            ImageGenerator(json.decode((file as File).readAsStringSync()))
                .generate(path, null);
          });

          print('done!');
        }
      } catch (error, stackTrace) {
        print(error);
        print(stackTrace);
      }
    });
  });
}
