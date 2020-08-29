part of util;

class CustomizationLayer extends OnlineObject {
  static const _path = 'image/player';

  CustomizationLayer() {
    internal['_override'] = 'CustomizationLayer';
  }

  int get contrast => _value(internal['c']);

  void set contrast(dynamic value) {
    internal['c'] = value is String ? int.parse(value) : value;
  }

  int get hue => _value(internal['h']);

  void set hue(dynamic value) {
    internal['h'] = value is String ? int.parse(value) : value;
  }

  int get lightness => _value(internal['l']);

  void set lightness(dynamic value) {
    internal['l'] = value is String ? int.parse(value) : value;
  }

  int get saturation => _value(internal['s']);

  void set saturation(dynamic value) {
    internal['s'] = value is String ? int.parse(value) : value;
  }

  Map<String, String> get style {
    var result = _filter(hue, saturation, lightness, contrast);
    result['margin-left'] = '-8.5px';
    result['margin-top'] = '-16px';
    return result;
  }

  String get type => internal['type'] ?? '0';

  void set type(String value) {
    internal['type'] = value;
  }

  String getImage(String gender, String layer) =>
      '$_path/$gender/$layer/$type.png';

  void reset(
      {int hue = 0,
      int saturation = 100,
      int lightness = 100,
      int contrast = 100}) {
    this.type = '0';
    this.hue = hue;
    this.saturation = saturation;
    this.lightness = lightness;
    this.contrast = contrast;
  }

  Map<String, String> _filter(int h, int s, int l, int c) {
    var filter =
        'hue-rotate(${h}deg) saturate(${s}%) brightness(${l}%) contrast(${c}%)';

    return {'-webkit-filter': filter, 'filter': filter};
  }

  int _value(int value) => clamp(value ?? 0, 0, 360).floor();
}
