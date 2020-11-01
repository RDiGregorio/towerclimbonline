part of util;

/// Used to change how a player looks.

class DollCustomization extends OnlineObject {
  DollCustomization() {
    internal['_override'] = 'DollCustomization';
    reset();
  }

  CustomizationLayer get back => internal['back'] ??= CustomizationLayer();

  CustomizationLayer get base => internal['base'] ??= CustomizationLayer();

  CustomizationLayer get bottom => internal['bottom'] ??= CustomizationLayer();

  CustomizationLayer get eyes => internal['eyes'] ??= CustomizationLayer();

  CustomizationLayer get face => internal['face'] ??= CustomizationLayer();

  String get gender => internal['gender'] ?? 'male';

  void set gender(String value) {
    if (hairType == '4') hairType = '0';
    if (top.type == '3') top.type = '0';
    internal['gender'] = value;
  }

  CustomizationLayer get hair => internal['hair'] ??= CustomizationLayer();

  int get hairContrast => hair.contrast;

  void set hairContrast(dynamic value) {
    hair.contrast = back.contrast = value;
  }

  String get hairType => hair.type;

  void set hairType(dynamic value) {
    hair.type = back.type = value;
  }

  int get hairHue => hair.hue;

  void set hairHue(dynamic value) {
    hair.hue = back.hue = value;
  }

  int get hairLightness => hair.lightness;

  void set hairLightness(dynamic value) {
    hair.lightness = back.lightness = value;
  }

  int get hairSaturation => hair.saturation;

  void set hairSaturation(dynamic value) {
    hair.saturation = back.saturation = value;
  }

  CustomizationLayer get shoes => internal['shoes'] ??= CustomizationLayer();

  CustomizationLayer get top => internal['top'] ??= CustomizationLayer();

  String getImage(String layer) {
    if (layer == 'back') return back.getImage(gender, layer);
    if (layer == 'base') return base.getImage(gender, layer);
    if (layer == 'bottom') return bottom.getImage(gender, layer);
    if (layer == 'ears') return 'image/player/$gender/ears/0.png';
    if (layer == 'eyes') return eyes.getImage(gender, layer);
    if (layer == 'face') return face.getImage(gender, layer);
    if (layer == 'hair') return hair.getImage(gender, layer);
    if (layer == 'shoes') return shoes.getImage(gender, layer);
    if (layer == 'top') return top.getImage(gender, layer);
    return null;
  }

  void reset() {
    gender = 'male';
    base.reset();

    // Brown hair.

    back.reset(hue: 50);
    hair.reset(hue: 50);

    // Blue bottom.

    bottom.reset(hue: 200);

    // Blue eyes.

    eyes.reset(hue: 200);
    face.reset();
    shoes.reset();
    top.reset();
  }
}
