part of server;

class ImageGenerator {
  static int _size = 16, _sourceSize = 16;

  Image _image = Image(_size * 100, _size * 100),
      _foreground = Image(_size * 100, _size * 100);

  final Map<String, dynamic>? _data;
  Map<String, Image> _images = {};

  ImageGenerator(this._data);

  Future<dynamic> generate(String? path, String? copyRoot) async {
    _images.clear();
    var cells = _data!['cells'];

    for (var x = 0; x < cells.length; x++)
      for (var y = 0; y < cells.length; y++) {
        String? cellColor(Point<int> point) {
          var color;

          try {
            color = cells[point.x][point.y][2];
          } catch (error) {
            return 'black';
          }

          return color;
        }

        int? color = _color(cellColor(Point(x, y)));

        String? cornerType() {
          var point = Point(x, y),
              top = Point(0, -1),
              bottom = Point(0, 1),
              left = Point(-1, 0),
              right = Point(1, 0);

          List<String> colors = ['blue'];
          if (colors.contains(cellColor(point))) return null;

          bool isCorner(String color, Point<int> x, Point<int> y) =>
              cellColor(point + x) == color && cellColor(point + y) == color;

          for (int i = 0; i < colors.length; i++) {
            if (isCorner(colors[i], left, top))
              return 'web/image/block/corner/${colors[i]}/leftTop.png';

            if (isCorner(colors[i], right, top))
              return 'web/image/block/corner/${colors[i]}/rightTop.png';

            if (isCorner(colors[i], left, bottom))
              return 'web/image/block/corner/${colors[i]}/leftBottom.png';

            if (isCorner(colors[i], right, bottom))
              return 'web/image/block/corner/${colors[i]}/rightBottom.png';
          }

          return null;
        }

        if (color != null)
          fillRect(_image, x * _size, y * _size, (x + 1) * _size,
              (y + 1) * _size, color);

        // [roundCorners] can be set to true when the code is finished for it.

        bool roundCorners = false;

        if (roundCorners && cornerType() != null)
          drawImage(_image, (await _decode(cornerType()!))!,
              dstX: x * _size,
              dstY: y * _size,
              srcX: 0,
              srcY: 0,
              srcW: _sourceSize,
              srcH: _sourceSize,
              blend: true);
      }

    // Draws the blocks.

    for (var x = 0; x < cells.length; x++)
      for (var y = 0; y < cells.length; y++) {
        var cell = cells[x][y], value = await _createImage(cell);

        if (value != null) {
          if (cell[0] == '#')
            drawImage(_foreground, (await _createImage(cell, '_foreground'))!,
                dstX: x * _size,
                dstY: y * _size,
                srcX: 0,
                srcY: 0,
                srcW: _sourceSize,
                srcH: _sourceSize,
                blend: true);

          drawImage(_image, value,
              dstX: x * _size,
              dstY: y * _size,
              srcX: 0,
              srcY: 0,
              srcW: _sourceSize,
              srcH: _sourceSize,
              blend: true);
        }
      }

    var filePath = 'image/terrain/$path.png', file = File('web/$filePath');
    await file.writeAsBytes(encodePng(_image));

    var foregroundFilePath = 'image/terrain/${path}_foreground.png',
        foregroundFile = File('web/$foregroundFilePath');

    await foregroundFile.writeAsBytes(encodePng(_foreground));

    // Needed so that players can see the image in the live game.

    if (!Config.debug && copyRoot != null) {
      try {
        file.copySync('$copyRoot/$filePath');
        foregroundFile.copySync('$copyRoot/$foregroundFilePath');
      } catch (error) {
        // The logger isn't visible from isolated memory.

        output(error);
      }
    }

    return null;
  }

  int? _color(String? color) {
    color ??= 'black';

    // Colors are modified for style.

    switch (color ?? '') {
      case '':
        return getColor(0, 0, 0);
      case 'darkred':
        return getColor(139, 0, 0);
      case 'red':
        return getColor(255, 0, 0);
      case 'blue':
        return getColor(135, 206, 250);
      case 'green':
        return getColor(0, 128, 0);
      case 'brown':
        return getColor(139, 69, 19);
      case 'maroon':
        return getColor(128, 0, 0);
      case 'black':
        return getColor(0, 0, 0);
      case 'white':
        return getColor(255, 255, 255);
      case 'gray':
        return getColor(211, 211, 211);
      case 'orange':
        return getColor(255, 140, 0);
      case 'darkblue':
        return getColor(0, 0, 160);
      case 'midnightblue':
        return getColor(25, 25, 112);
      case 'pink':
        return null;
      case 'indigo':
        return null;
      case 'yellow':
        return getColor(255, 255, 0);
      case 'darkred':
        return getColor(139, 0, 0);
      default:
        throw ArgumentError(color);
    }
  }

  Future<Image?> _createImage(List<dynamic>? cell, [modifier = '']) async {
    if (cell == null) return null;

    if (cell[2] == 'pink')
      return _images['clear_floor'] ??=
          (await _decode('web/image/block/clear_floor.png'))!;

    if (cell[2] == 'indigo')
      return _images['clear_black_floor'] ??=
          (await _decode('web/image/block/clear_black_floor.png'))!;

    if (cell == null ||
        cell[0] == null ||
        cell[0] == '' ||
        cell[0].startsWith('@') ||
        cell[1] == null) return null;

    var result;

    if (cell[0] == '#') if (cell[1] == 'brown')
      result = 'rock_wall';
    else if (cell[1] == 'gray')
      result = 'stone_wall';
    else if (cell[1] == 'blue')
      result = 'blue_wall';
    else if (cell[1] == 'yellow')
      result = 'yellow_wall';
    else if (cell[1] == 'red')
      result = 'red_wall';
    else if (cell[1] == 'darkblue')
      result = 'dark_blue_wall';
    else if (cell[1] == 'green') result = 'green_wall';

    return _images['$result$modifier'] ??=
        (await _decode('web/image/block/${result ?? 'missing'}$modifier.png'))!;
  }

  Future<Image?> _decode(String path) async =>
      decodeImage(await File(path).readAsBytes());
}
