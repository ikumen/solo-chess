import 'package:shared_preferences/shared_preferences.dart';

abstract class SettingsProvider {
  /// Return true if dark theme is enabled
  bool get darkMode;
  /// enabled/disable the dark theme
  set darkMode(bool enabled);

  /// Return the users current puzzle level
  int get currentPuzzleLvl;
  /// Set the user's current puzzle level
  set currentPuzzleLvl(int lvl);

  /// Return the highest playable puzzle
  int get highestPuzzleLvl;
  /// Set the highest playable puzzle
  set highestPuzzleLvl(int lvl);
}

class SharedPreferencesSettingsProvider extends SettingsProvider {
  final SharedPreferences _prefs;

  SharedPreferencesSettingsProvider(this._prefs);

  @override
  bool get darkMode => _prefs.getBool("dark_mode") ?? true;

  @override
  set darkMode(bool enabled) {
    if (darkMode != enabled) {
      _prefs.setBool("dark_mode", enabled);
    }
  }

  @override
  int get currentPuzzleLvl => _prefs.getInt("curr_puzzle") ?? 0;

  @override
  set currentPuzzleLvl(int lvl) {
    _prefs.setInt("curr_puzzle", lvl);
  }

  @override
  int get highestPuzzleLvl => _prefs.getInt("high_puzzle") ?? 0;

  @override
  set highestPuzzleLvl(int lvl) {
    print(lvl);
    _prefs.setInt("high_puzzle", lvl);
  }

  static Future<SharedPreferencesSettingsProvider> getInstance() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return SharedPreferencesSettingsProvider(prefs);
  }
}