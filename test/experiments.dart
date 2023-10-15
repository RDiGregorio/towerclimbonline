import 'dart:math';

void main() {
  var input = [
    [0, 1, 2],
    [0, 1, 2],
    [0, 1, 2],
    [0, 1, 2]
  ];

  // The goal is to take a unique integer from each.

  var finder = CertificateFinder(input, (i, j) => i == j);

  print(finder.certificate);
}

class CertificateFinder {
  late Product _product;
  Function _collision;
  int _key = 0, _max = 0;

  CertificateFinder(List<List<int>> list, bool this._collision(int i, int j)) {
    _product = Product(list);
    print('length: ${_product.length}');
  }

  List<int?>? get certificate {
    for (int i = 0; i < 100; i++) {
      print('key: $_key, max: $_max');
      print(_key.toRadixString(3).padLeft(10, '0'));

      var certificate = _product[_key], collision = _findCollision(certificate);
      if (collision == null) return certificate;

      print(collision);

      if (_key < _max) {
        print('<');
        _key = _product.flip(_key, collision[1]);
        _max = max<int>(_max, _key);
        continue;
      }

      print('>=');
      _key = _product.flip(_key, collision[0]);
      _max = max<int>(_max, _key);
    }

    return null;
  }

  List<int>? _findCollision(List<int?> certificate) {
    print('cert: $certificate');

    for (int i = certificate.length - 1; i >= 0; i--)
      for (int j = i - 1; j >= 0; j--)
        if (_collision(certificate[i], certificate[j]))
          return [certificate.length - (i + 1), certificate.length - (j + 1)];

    return null;
  }
}

class Product {
  List<List<int>> _list;
  int? _base, _length;

  Product(List<List<int>> this._list) {
    _base = _list.fold(0, ((result, list) => max<int>(result, list.length)) as int? Function(int?, List<int>));
    _length = pow(_base!, _list.length).floor();
  }

  int? get length => _length;

  List<int?> operator [](int key) {
    var keys = _keys(key), result = List<int?>(_list.length);
    for (int i = 0; i < keys.length; i++) result[i] = _list[i][keys[i]];
    return result;
  }

  int flip(int key, int bit) {
    var keys = _keys(key), index = keys.length - (bit + 1);
    keys[index] = (keys[index] + 1) % _base!;
    return int.parse(keys.join(''), radix: _base);
  }

  List<int> _keys(int key) => List<int>.from(key
      .toRadixString(_base!)
      .padLeft(_list.length, '0')
      .split('')
      .map(int.parse));
}
