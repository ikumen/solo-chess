import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:solo_chess/constants.dart';
import 'package:solo_chess/providers/puzzle_provider.dart';
import 'package:solo_chess/providers/settings_provider.dart';
import 'package:solo_chess/providers/theme_provider.dart';
import 'package:solo_chess/screens/puzzle_screen.dart';
import 'package:solo_chess/screens/settings_screen.dart';
import 'package:solo_chess/screens/splash_screen.dart';

void main() async {

  runApp(const SplashScreen());

  PuzzleProvider puzzleProvider = await LocalCsvPuzzleProvider.getInstance();
  SettingsProvider settingsProvider = await SharedPreferencesSettingsProvider.getInstance();
  ThemeProvider themeProvider = await ThemeProvider.getInstance(settingsProvider);
  await Future.delayed(const Duration(milliseconds: 1000), () {});

  runApp(
    MultiProvider(
      providers: [
        Provider(create: (_) => settingsProvider),
        Provider(create: (_) => puzzleProvider),
        ChangeNotifierProvider(create: (_) => themeProvider),
      ],
      child: App(settingsProvider, themeProvider, puzzleProvider),
    )
  );
}


class App extends StatefulWidget {
  final PuzzleProvider _puzzleProvider;
  final SettingsProvider _settingsProvider;
  final ThemeProvider _themeProvider;
  const App(this._settingsProvider, this._themeProvider, this._puzzleProvider, {Key? key}) : super(key: key);

  @override
  State createState() => _AppState();
}

class _AppState extends State<App> {

  @override
  void initState() {
    super.initState();
    widget._themeProvider.addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: appTitle,
      debugShowCheckedModeBanner: false,
      darkTheme: ThemeProvider.darkTheme,
      theme: ThemeProvider.lightTheme,
      themeMode: widget._themeProvider.themeMode,
      home: PuzzleScreen(widget._settingsProvider, widget._puzzleProvider),
    );
  }
}

class TestApp extends StatefulWidget {

  @override
  State createState() => _TestAppState();
}

class _TestAppState extends State<TestApp> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(appTitle),
      ),
      body: Text("hello"),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        onTap: (index) {
          if (index == 1) {
            // Navigator.push(context,
            //     MaterialPageRoute(builder: (context) => PuzzleListScreen(_loadPuzzle)))
            //     .then((puzzleId) {
            //   if (puzzleId != null) _loadPuzzle(_puzzleId);
            // });
          } else if (index == 2) {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const SettingsScreen())
            );
          }
        },
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              label: "Home",
              icon: Icon(Icons.home_rounded)),
          BottomNavigationBarItem(
              label: "Puzzles",
              icon: Icon(Icons.list_alt_rounded)),
          BottomNavigationBarItem(
              label: "Settings",
              icon: Icon(Icons.settings_rounded))
        ],
      ),
    );
  }
}
