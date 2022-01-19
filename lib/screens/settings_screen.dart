import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:solo_chess/constants.dart';
import 'package:solo_chess/providers/settings_provider.dart';
import 'package:solo_chess/providers/theme_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          title: const Text(settingsSubtitle),
        ),
        body: Consumer<ThemeProvider>(
          builder: (context, themeProvider, child) {
            SettingsProvider settings = Provider.of<SettingsProvider>(context, listen: false);
            return ListView(
              children: [
                ListTile(
                  title: const Text("Dark Mode"),
                  trailing: Switch(
                    onChanged: (enabled) {
                      settings.darkMode = themeProvider.isDarkMode = enabled;
                    },
                    value: settings.darkMode,
                  )
                ),
                ListTile(
                  title: const Text("Puzzles"),
                  subtitle: Text("Highest level unlocked: ${settings.highestPuzzleLvl}"),
                ),
                const ListTile(
                  title: Text("About"),
                  minVerticalPadding: 50,
                  subtitle: Text("Chess puzzles, heavily inspired by the physical Solitaire " +
                    "Chess by Thinkfun, built as a side project while learning Flutter.\n\n" +
                    "Credits:\n" +
                    "  - Thinkfun Solitaire Chess\n" +
                    "  - chess icons from Wikimedia Commons\n\n" +
                    "Source code:\n" +
                    "https://github.com/ikumen/solo-chess"
                  ),
                ),
              ],
            );
          }
        )
    );
  }
}