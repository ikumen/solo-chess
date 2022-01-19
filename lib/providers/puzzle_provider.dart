import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:solo_chess/models/piece.dart';
import 'package:solo_chess/models/puzzle.dart';

abstract class PuzzleProvider {
  int count();
  Puzzle puzzle(int i);
}

abstract class PuzzleSource {
  Future<List<Puzzle>> loadPuzzles();
}

class LocalCsvPuzzleProvider extends PuzzleProvider {
  final List<Puzzle> _puzzles;

  LocalCsvPuzzleProvider(this._puzzles) {
    if (_puzzles.isEmpty) throw ArgumentError("Puzzles are empty!");
  }

  @override
  int count() => _puzzles.length;

  @override
  Puzzle puzzle(int i) {
    if (i >= _puzzles.length) throw "Invalid puzzle id $i";
    return _puzzles[i];
  }

  static Future<PuzzleProvider> getInstance() async {
    CsvPuzzleSource puzzleSource = CsvPuzzleSource(rootBundle);
    return LocalCsvPuzzleProvider(await puzzleSource.loadPuzzles());
  }
}

class CsvPuzzleSource extends PuzzleSource {

  static final Map<String, int> _rankRow =
  Map.unmodifiable({"1": 3, "2": 2, "3": 1, "4": 0});

  static final Map<String, int> _fileCol =
  Map.unmodifiable({"a": 0, "b": 1, "c": 2, "d": 3});

  static final Map<String, Piece> _pieceCodes =
  Map.unmodifiable({
    "p": Piece.pawn,
    "r": Piece.rook,
    "b": Piece.bishop,
    "n": Piece.knight,
    "k": Piece.king,
    "q": Piece.queen
  });

  static Position _parsePositionData(String data, int c, int r) {
    int row = _rankRow[data[r]] ?? (throw ArgumentError("Not a valid rank"));
    int col = _fileCol[data[c]] ?? (throw ArgumentError("Not a valid file"));
    return Position(row, col);
  }

  static Piece _parsePieceData(String data, int i) {
    return _pieceCodes[data[i]] ?? (throw ArgumentError("Not a valid piece"));
  }

  // TODO: validate solution
  static List<SolutionStep> _parseSolution(String data) {
    if (data.length % 4 != 0) throw ArgumentError("Invalid solution");
    List<SolutionStep> solution = [];
    for (int i = 0; i < data.length; i += 4) {
      Position from = _parsePositionData(data, i, i+1);
      Position to = _parsePositionData(data, i+2, i+3);
      solution.add(SolutionStep(from, to));
    }
    return solution;
  }

  static Puzzle? _parsePuzzle(String data) {
    List<String> parts = data.split(",");
    // parse for the puzzle piece positions
    Map<Position, Piece> pieces = {};
    for (var i = 0; i < parts[0].length; i += 3) {
      try {
        Position position = _parsePositionData(parts[0], i, i + 1);
        Piece piece = _parsePieceData(parts[0], i + 2);
        pieces[position] = piece;
      } catch (e) {
        print(e);
        return null;
      }
    }
    // parse for the solutions
    List<SolutionStep> solution = _parseSolution(parts[1]);

    return Puzzle(pieces, solution);
  }

  final AssetBundle assetBundle;

  CsvPuzzleSource(this.assetBundle);

  @override
  Future<List<Puzzle>> loadPuzzles() async {
    return await assetBundle.loadString("assets/puzzles/default.txt")
      .then((data) {
        return data.split("\n")
          .where((s) => s.trim() != "")
          .map((s) => s.toLowerCase())
          .map((s) => CsvPuzzleSource._parsePuzzle(s))
          .where((puzzle) => puzzle != null)
          .map((puzzle) => puzzle!)
          .toList();
      });
  }
}

