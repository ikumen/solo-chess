import 'package:flutter/material.dart';
import 'package:solo_chess/constants.dart';
import 'package:solo_chess/providers/settings_provider.dart';

class ThemeProvider with ChangeNotifier {
  static final ThemeData lightTheme = ThemeData(
      brightness: Brightness.light,
      appBarTheme: const AppBarTheme(
        foregroundColor: Colors.black,
        backgroundColor: lightBackgroundColor,
      ),
    );

  static final ThemeData darkTheme = ThemeData(
      brightness: Brightness.dark,
      appBarTheme: AppBarTheme(
        foregroundColor: Colors.white,
        backgroundColor: Colors.grey[900],
      ),
    );

  static final CustomTheme _darkCustomTheme = CustomTheme();
  static final CustomTheme _lightCustomTheme = CustomTheme(boardBorder: Colors.blueGrey);

  bool _isDarkMode;

  ThemeProvider({bool isDarkMode = true})
    : _isDarkMode = isDarkMode ;

  /// Return the current theme mode
  ThemeMode get themeMode => _isDarkMode ? ThemeMode.dark : ThemeMode.light;

  /// Return the CustomTheme associated with current theme mode
  CustomTheme get customTheme => _isDarkMode ? _darkCustomTheme : _lightCustomTheme;
  ThemeData get theme => _isDarkMode ? darkTheme : lightTheme;

  /// Return true if dark mode
  bool get isDarkMode => _isDarkMode;

  /// Enable/disable dark mode
  set isDarkMode(bool enable) {
    if (_isDarkMode != enable) {
      _isDarkMode = enable;
      notifyListeners();
    }
  }

  static Future<ThemeProvider> getInstance(SettingsProvider settings) async {
    return ThemeProvider(isDarkMode: settings.darkMode);
  }
}

class CustomTheme {
  final Color boardBorder;
  final Color selectedSpace;
  final Color buttonBorder;
  final List<Color> squareColors;

  CustomTheme({
    this.boardBorder = Colors.black54,
    this.buttonBorder = Colors.grey,
    this.selectedSpace = Colors.yellow,
    this.squareColors = const [
        Colors.white70,
        Colors.black38
      ]
  });
}

