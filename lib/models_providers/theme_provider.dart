import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';

import '../constants/app_colors.dart';

class ThemeProvider with ChangeNotifier {
  ThemeProvider(this._themeMode) {}

  ThemeMode _themeMode;
  ThemeMode get themeMode => _themeMode;

  set themeMode(ThemeMode tm) {
    _themeMode = tm;
    Themes.setThemeModeHive(tm);
    notifyListeners();
  }
}

class Themes {
  static ThemeData light() => _baseTheme(ThemeData.light());
  static ThemeData dark() => _baseTheme(ThemeData.dark());

  static ThemeData _baseTheme(ThemeData themeData) {
    bool isLightTheme = themeData.brightness == Brightness.light;
    BorderRadius borderRadius = BorderRadius.circular(3);

    Color scaffoldBackgroundColor = isLightTheme ? Color(0xFFFAFAFC) : Color(0xFF181A20);
    Color textColor = isLightTheme ? Colors.black : Colors.white;

    Color disabledBorderColor = isLightTheme ? Color(0xFFE6E7EA) : Colors.black12;
    Color enabledBorderColor = isLightTheme ? Color(0xFFE8EBF7) : Colors.white38;
    Color errorBorderColor = isLightTheme ? Color(0xFFE20000) : Color(0xFFE20000);
    Color focusedBorderColor = isLightTheme ? Color(0xFF5A7EFF) : Colors.white;
    Color focusedErrorBorderColor = isLightTheme ? Color(0xFF5C00E4) : Color(0xFFE20000);

    return ThemeData(
      brightness: isLightTheme ? Brightness.light : Brightness.dark,
      scaffoldBackgroundColor: scaffoldBackgroundColor,
      colorScheme: themeData.colorScheme.copyWith(secondary: Colors.orange),
      indicatorColor: isLightTheme ? Colors.blue : Colors.white,
      tabBarTheme: TabBarTheme(labelColor: textColor, unselectedLabelColor: textColor.withOpacity(0.5)),
      textTheme: GoogleFonts.nunitoTextTheme(
        themeData.textTheme.copyWith(bodyMedium: themeData.textTheme.bodyMedium?.copyWith(fontSize: 14)),
      ).apply(bodyColor: textColor, displayColor: textColor),
      appBarTheme: AppBarTheme(
          elevation: 0,
          centerTitle: false,
          backgroundColor: scaffoldBackgroundColor,
          actionsIconTheme: IconThemeData(color: textColor),
          iconTheme: IconThemeData(color: textColor),
          scrolledUnderElevation: 0,
          titleTextStyle: TextStyle(color: textColor, fontSize: 20, fontWeight: FontWeight.w600)),
      inputDecorationTheme: InputDecorationTheme(
        fillColor: isLightTheme ? Colors.grey.shade100 : Colors.white10,
        suffixStyle: TextStyle(color: isLightTheme ? Colors.black54 : Colors.white54),
        labelStyle: TextStyle(color: isLightTheme ? Colors.black54 : Colors.white54),
        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: enabledBorderColor, width: 1), borderRadius: borderRadius),
        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: focusedBorderColor, width: 1), borderRadius: borderRadius),
        errorBorder: OutlineInputBorder(borderSide: BorderSide(color: errorBorderColor, width: 1), borderRadius: borderRadius),
        focusedErrorBorder: OutlineInputBorder(borderSide: BorderSide(color: focusedErrorBorderColor, width: 1), borderRadius: borderRadius),
        disabledBorder: OutlineInputBorder(borderSide: BorderSide(color: disabledBorderColor, width: 1), borderRadius: borderRadius),
        isDense: true,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(backgroundColor: scaffoldBackgroundColor),
      cardColor: isLightTheme ? appColorCardLight : appColorCardDark,
    );
  }

  static setThemeModeHive(ThemeMode tm) async {
    final settings = await Hive.openBox('settings');
    if (tm == ThemeMode.system) settings.put('themeMode', 'system');
    if (tm == ThemeMode.light) settings.put('themeMode', 'light');
    if (tm == ThemeMode.dark) settings.put('themeMode', 'dark');
    setStatusNavigationBarColor();
  }

  static Future<ThemeMode> getThemeModeHive() async {
    final settings = await Hive.openBox('settings');
    String? themeModeStr = settings.get('themeMode');
    if (themeModeStr == 'light') return ThemeMode.light;
    if (themeModeStr == 'dark') return ThemeMode.dark;
    return ThemeMode.dark;
  }

  static void setStatusNavigationBarColor() async {
    final brightness = WidgetsBinding.instance.platformDispatcher.platformBrightness;

    bool isThemeModeSystem = await getThemeModeHive() == ThemeMode.system;
    bool isThemeModeLight = await getThemeModeHive() == ThemeMode.light;
    bool isThemeModeDark = await getThemeModeHive() == ThemeMode.dark;

    Color systemNavigationBarColorDark = Color(0xFF181A20);
    Color systemNavigationBarColorLight = Color(0xFFFAFAFC);
    // Color systemNavigationBarColorDark = Color(0xFF2A2C32);
    // Color systemNavigationBarColorLight = Colors.grey.shade300;

    if (isThemeModeLight) {
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: systemNavigationBarColorLight,
        systemNavigationBarIconBrightness: Brightness.dark,
        systemNavigationBarDividerColor: Colors.transparent,
      ));
    }

    if (isThemeModeDark) {
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: systemNavigationBarColorDark,
        systemNavigationBarIconBrightness: Brightness.light,
        systemNavigationBarDividerColor: Colors.transparent,
      ));
    }

    if (isThemeModeSystem) {
      if (brightness == Brightness.light) {
        SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarBrightness: Brightness.light,
          statusBarIconBrightness: Brightness.dark,
          systemNavigationBarColor: systemNavigationBarColorLight,
          systemNavigationBarIconBrightness: Brightness.dark,
          systemNavigationBarDividerColor: Colors.transparent,
        ));
      }

      if (brightness == Brightness.dark) {
        SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarBrightness: Brightness.dark,
          statusBarIconBrightness: Brightness.light,
          systemNavigationBarColor: systemNavigationBarColorDark,
          systemNavigationBarIconBrightness: Brightness.light,
          systemNavigationBarDividerColor: Colors.transparent,
        ));
      }
    }
  }
}
