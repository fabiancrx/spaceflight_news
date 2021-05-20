import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';

///Used to trigger auto import and avoid
///[dart limitation of not importing extensions](https://github.com/dart-lang/sdk/issues/38894)

mixin ExtensionsMixin {}

extension AppLocalizationX on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this)!;
}

extension DateTimeX on DateTime {
  String formatYmmmmd() {
    return DateFormat.yMMMMd('en_US').format(this);
  }
}

extension BrightnessX on Brightness {
  Brightness invert() {
    switch (this) {
      case Brightness.dark:
        return Brightness.light;
      case Brightness.light:
        return Brightness.dark;
    }
  }
}
