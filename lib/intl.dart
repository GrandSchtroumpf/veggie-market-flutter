import 'package:flutter/cupertino.dart';
import 'package:flutter_i18n/flutter_i18n.dart';

class Intl {
  final String baseKey;
  const Intl(this.baseKey);

  String string(BuildContext context, String key) {
    return FlutterI18n.translate(context, baseKey + '.' + key);
  }

  I18nText text(String key, [Text child]) {
    return child == null
        ? I18nText(baseKey + '.' + key)
        : I18nText(baseKey + '.' + key, child: child);
  }

  plural() {}

  String key(String key) {
    return baseKey + '.' + key;
  }
}
