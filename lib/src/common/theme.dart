import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FontSizes {
  /// Provides the ability to change the font scaling app wise
  static double get scale => 1;

  static double get s10 => 10 * scale;

  static double get s11 => 11 * scale;

  static double get s12 => 12 * scale;

  static double get s14 => 14 * scale;

  static double get s16 => 16 * scale;

  static double get s18 => 18 * scale;

  static double get s24 => 24 * scale;

  static double get s48 => 48 * scale;
}

class TextStyles {
  // Base style
  static TextStyle ibm = GoogleFonts.ibmPlexSans();

  // top title
  static TextStyle get h1 => ibm.copyWith(fontWeight: FontWeight.w600, fontSize: FontSizes.s18, height: 1.33);

  // subtitle
  static TextStyle get h2 => h1.copyWith(
        fontSize: FontSizes.s24,
        height: 1.3,
        fontWeight: FontWeight.w700,
        color: OnePlaceColor.gray800,
      );

  //card text
  static TextStyle get caption1 => ibm.copyWith(
        fontWeight: FontWeight.w500,
        fontSize: FontSizes.s16,
        height: 1.375,
        color: OnePlaceColor.gray800,
      );

  //not found subtitle
  static TextStyle get caption2 => body2.copyWith(fontWeight: FontWeight.w500, color: OnePlaceColor.gray800,);

  //card date
  static TextStyle get body2 => ibm.copyWith(
        fontWeight: FontWeight.w400,
        fontSize: FontSizes.s14,
        height: 1.286,
        color: OnePlaceColor.gray500,
      );
  //card detail text
  static TextStyle get body1 => ibm.copyWith(
    fontWeight: FontWeight.w400,
    fontSize: FontSizes.s16,
    height: 1.375,
    color: OnePlaceColor.gray700,
  );
  //tabs
  static TextStyle get tab3Active => ibm.copyWith(
        fontWeight: FontWeight.w600,
        fontSize: FontSizes.s12,
        height: 1.3,
        color: OnePlaceColor.gray900,
      );

  static TextStyle get tab3Inactive => tab3Active.copyWith(
        fontWeight: FontWeight.w400,
        color: OnePlaceColor.gray700,
      );
}

class OnePlaceColor {
  static const accent = Color(0xff0C39AC); // primary color
  static const gray900 = Color(0xff111827); // activeTab Text, detail appBar
  static const gray800 = Color(0xff1F2937); // fonts in not found screens, card title
  static const gray700 = Color(0xff374151); // restingTab Text
  static const gray500 = Color(0xff6B7280); // icon color
  static const gray400 = Color(0xff9CA3AF); // resting tab
  static const gray50 = Color(0xffF9FAFB); // background color
  static const tabBackground = Colors.white;
  static const cardBlur = Color(0x1A000000);
  static const blur = Color(0x40000000);
  static const error = Color(0xffB91C1C);
}

class AppTheme {
  bool isDark;
  Color gray50 = OnePlaceColor.gray50;

  Color tabBackground = OnePlaceColor.tabBackground;
  Color accent = OnePlaceColor.accent;
  Color gray400 = OnePlaceColor.gray400;
  Color gray700 = OnePlaceColor.gray700;
  Color gray800 = OnePlaceColor.gray800;
  Color gray900 = OnePlaceColor.gray900;
  Color focus = OnePlaceColor.error;

  /// Darkness adjusted text color. Will be Black in light mode, and White in dark
  Color mainTextColor;
  Color inverseTextColor;

  /// Default constructor
  AppTheme({required this.isDark})
      : this.mainTextColor = isDark ? Colors.white : OnePlaceColor.gray800,
        inverseTextColor = isDark ? OnePlaceColor.gray800 : Colors.white;

  ThemeData get themeData {
    var t = ThemeData.from(
      //textTheme: (isDark ? ThemeData.dark() : ThemeData.light()).textTheme,
      textTheme: GoogleFonts.ibmPlexSansTextTheme(),
      colorScheme: ColorScheme(
          brightness: isDark ? Brightness.dark : Brightness.light,
          primary: accent,
          primaryVariant: shift(accent, .1),
          secondary: accent,
          secondaryVariant: shift(accent, .1),
          background: gray50,
          surface: tabBackground,
          onBackground: mainTextColor,
          onSurface: mainTextColor,
          onError: mainTextColor,
          onPrimary: inverseTextColor,
          onSecondary: inverseTextColor,
          error: focus),
    );
    // Apply additional styling that is missed by ColorScheme
    t.copyWith(
        visualDensity: VisualDensity.compact,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: tabBackground,
          selectionHandleColor: Colors.transparent,
          selectionColor: tabBackground,
        ),
        buttonColor: accent,
        highlightColor: shift(accent, .1),
        iconTheme: IconThemeData(color: OnePlaceColor.gray500, size: 24),
        toggleableActiveColor: accent);

    return t;
  }

  Color shift(Color c, double amt) {
    amt *= (isDark ? -1 : 1);
    var hslc = HSLColor.fromColor(c); // Convert to HSL
    double lightness = (hslc.lightness + amt).clamp(0, 1.0) as double; // Add/Remove lightness
    return hslc.withLightness(lightness).toColor(); // Convert back to Color
  }
}
