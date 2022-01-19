import 'package:flutter/material.dart';
import 'package:solo_chess/components/board.dart';
import 'package:solo_chess/components/button.dart';
import 'package:solo_chess/models/game.dart';
import 'package:solo_chess/models/piece.dart';
import 'package:solo_chess/providers/puzzle_provider.dart';
import 'package:solo_chess/providers/settings_provider.dart';
import 'package:solo_chess/screens/puzzle_list_screen.dart';
import 'package:solo_chess/screens/settings_screen.dart';

class PuzzleScreen extends StatefulWidget {
  final PuzzleProvider _puzzleProvider;
  final SettingsProvider _settingsProvider;

  const PuzzleScreen(this._settingsProvider, this._puzzleProvider, {Key? key}) : super(key: key);

  @override
  State createState() => _PuzzleScreenState();
}

class _PuzzleScreenState extends State<PuzzleScreen> {
  late int _puzzleId;
  late Game _game;

  @override
  void initState() {
    super.initState();
    _puzzleId = widget._settingsProvider.currentPuzzleLvl;
    _game = Game(widget._puzzleProvider.puzzle(_puzzleId));
  }

  Future<dynamic> _showPuzzleCompleteDialog() async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Puzzle ${_puzzleId + 1} Complete"),
            content: const Text("Continue to next puzzle or play this puzzle again?"),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context, 'replay'),
                  child: const Text('Replay')
              ),
              TextButton(
                  onPressed: () => Navigator.pop(context, 'next'),
                  child: const Text('Next')
              )
            ],
          );
        });
  }

  void _undo() {
    if (_game.undo()) setState(() {});
  }

  void _nextPuzzle() {
    _loadPuzzle(_puzzleId + 1);
  }

  void _replayPuzzle() {
    _loadPuzzle(_puzzleId);
  }

  void _loadPuzzle(int id) {
    setState(() {
      _game = Game(widget._puzzleProvider.puzzle(id));
      widget._settingsProvider.currentPuzzleLvl = id;
      _puzzleId = id;
    });
  }

  void _onPuzzleComplete() {
    setState(() {
      if (_puzzleId >= widget._settingsProvider.highestPuzzleLvl) {
        widget._settingsProvider.highestPuzzleLvl = _puzzleId + 1;
      }
    });

    _showPuzzleCompleteDialog().then((resp) {
      if (resp == "replay") {
        _replayPuzzle();
      } else {
        _nextPuzzle();
      }
    });
  }

  void _onSelectSquare(Position position) {
    // Initially select a "from" square/piece
    if (_game.state.selectedPosition == null) {
      setState(() => _game.selectPosition(position));
    } else {
      // There was a square/piece already selected, now check
      // 1) if same square selected again, then de-select
      if (_game.state.selectedPosition == position) {
        setState(() => _game.selectPosition(null, force: true));
      } else {
        // 2) different square/piece selected, so try to move
        setState(() {
          // Move was not successful, select the new position instead
          if (!_game.move(position)) {
            setState(() => _game.selectPosition(position, force: true));
          }
          // Move was successful and puzzle complete
          else if (_game.isComplete) {
            _onPuzzleComplete();
          }
        });
      }
    }
  }

  _buildGameNavigation() {
    return SizedBox(
      height: 56,
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Button(Icons.restore_rounded, _replayPuzzle),
            Button(Icons.undo_rounded, _undo)
          ],
        )
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mq = MediaQuery.of(context);
    int dimension = mq.size.shortestSide.floor() - 10;

    return Scaffold(
      appBar: AppBar(
        title: Text("Puzzle ${_puzzleId + 1}"),
      ),
      body: Column(
        children: [
          // Padding(
          //   padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
          //   child: Text("Puzzle ${_puzzleId + 1}", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),)
          // ),
          Board(4, dimension, _game, _onSelectSquare),
          _buildGameNavigation(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        onTap: (index) {
          if (index == 1) {
            Navigator.push(context,
              MaterialPageRoute(builder: (context) =>
                PuzzleListScreen(
                  widget._puzzleProvider,
                  widget._settingsProvider,
              ))
            ).then((puzzleId) {
              if (puzzleId != null && puzzleId >= 0 && puzzleId <= widget._settingsProvider.highestPuzzleLvl) {
                _loadPuzzle(puzzleId);
              }
            });
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
