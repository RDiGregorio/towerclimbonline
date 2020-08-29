part of util;

/// A floor tile.

class Tile {
  final int x, y;
  Map<String, dynamic> _properties = {};

  Tile(this.x, this.y, List<dynamic> cell) {
    cell ??= const [null, null, null];
    cell = List<String>.from(cell);

    if (cell[0]?.startsWith('@') == true)
      _properties
        ..['spawn'] = cell[0].replaceFirst('@', '')
        ..['value'] = Terrain.land;
    else if (const [null, ''].contains(cell[0]) && _traversable(cell))
      _properties['value'] = Terrain.land;

    if (cell[2] == 'blue' || cell[2] == 'orange')
      _properties['value'] =
          max<int>(_properties['value'] ?? -1, Terrain.water);
  }

  Map<String, dynamic> get properties => UnmodifiableMapView(_properties);

  bool _traversable(List<String> cell) => const [
        'darkred',
        'brown',
        'green',
        'gray',
        'maroon',
        'white',
        'midnightblue',
        'pink',
        'indigo',
        'darkblue',
        'yellow'
      ].contains(cell[2]);
}
