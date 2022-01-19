import 'package:flutter/material.dart';
import 'package:solo_chess/constants.dart';
import 'package:solo_chess/providers/puzzle_provider.dart';
import 'package:solo_chess/providers/settings_provider.dart';

void noOp(){}

class PuzzleListScreen extends StatelessWidget {
  final PuzzleProvider _puzzleProvider;
  final SettingsProvider _settingsProvider;

  const PuzzleListScreen(this._puzzleProvider, this._settingsProvider, {Key? key}) : super(key: key);

  _buildPuzzleListTile(BuildContext context, int puzzleId) {
    return ListTile(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildTitle(puzzleId, color: Colors.black45),
          const Icon(Icons.check_box_outline_blank_rounded,
            color: Colors.transparent,)
        ]
      )
    );
  }

  _buildCompletedPuzzleListTile(BuildContext context, int puzzleId) {
    return ListTile(
      onTap: () => Navigator.pop(context, puzzleId),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildTitle(puzzleId, color: Colors.black87),
          Icon(Icons.done_rounded,
            color: puzzleId < _settingsProvider.highestPuzzleLvl
                ? Colors.green
                : Colors.transparent,)
        ]
      )
    );
  }

  _buildTitle(int puzzleId, {Color color = Colors.grey}) {
    return Text("Puzzle ${puzzleId + 1}", style: TextStyle(color: color, fontSize: 32));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(puzzlesSubtitle),
      ),
      body: ListView.builder(
        itemCount: _puzzleProvider.count(),
        itemBuilder: (context, puzzleId) {
          return puzzleId <= _settingsProvider.highestPuzzleLvl
              ? _buildCompletedPuzzleListTile(context, puzzleId)
              : _buildPuzzleListTile(context, puzzleId);
        }
      ),
    );
  }
}