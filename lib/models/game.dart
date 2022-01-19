import 'package:solo_chess/models/piece.dart';
import 'package:solo_chess/models/puzzle.dart';

/// Immutable class representing the current state of game.
class GameState {
  final Map<Position, Piece> pieces;
  final Position? selectedPosition;

  GameState(this.pieces, this.selectedPosition);

  GameState.initial(this.pieces) : selectedPosition = null;

  withPosition(Position? position) =>
      GameState(Map.from(pieces), position);
}

class Game {
  final Puzzle _puzzle;
  final List<GameState> _states = [];

  Game(this._puzzle) {
    _states.add(GameState.initial(_puzzle.pieces));
  }

  void selectPosition(Position? position, {bool force = false}) {
    if (_states.last.selectedPosition == null || force) {
      _states.add(_states.last.withPosition(position));
    }
  }

  /// Remove the last state
  bool undo() {
    if (_states.length > 1) {
      _states.removeLast();
      return true;
    } else {
      return false;
    }
  }

  /// Return the current state of Game
  GameState get state => _states.last;

  /// Return true if game is complete (e.g, only 1 piece remains)
  bool get isComplete => _states.last.pieces.length == 1;

  /// Play the piece at "from" and capture the piece at "to"
  bool move(Position to) {
    final from = state.selectedPosition!;
    final pieces = state.pieces;
    if (!pieces.containsKey(to) || !isLegalMove(pieces, from, to)) return false;

    _states.add(
      GameState(
        Map.from(pieces)
          ..remove(from)
          ..update(to, (value) => pieces[from]!),
        to)
      );

    return true;
  }

  static bool isLegalRookMove(Map<Position, Piece> pieces, Position from, Position to) {
    final int diffY = to.row - from.row;
    final int diffX = to.col - from.col;
    if (diffY == 0 && diffX != 0) {
      int dir = diffX > 0 ? 1 : -1;
      int i = from.col + dir;
      while (i != to.col) {
        if (pieces.containsKey(Position(to.row, i))) break;
        i += dir;
      }
      return i == to.col;
    }
    else if (diffX == 0 && diffY != 0) {
      int dir = diffY > 0 ? 1 : -1;
      int i = from.row + dir;
      while (i != to.row) {
        if (pieces.containsKey(Position(i, to.col))) break;
        i += dir;
      }
      return i == to.row;
    }
    return false;
  }

  static bool isLegalBishopMove(Map<Position, Piece> pieces, Position from, Position to) {
    if (from.row == to.row || from.col == to.col) return false;
    if (((from.row - to.row) / (from.col - to.col)).abs() != 1) return false;

    int dirY = to.row > from.row ? 1 : -1;
    int dirX = to.col > from.col ? 1 : -1;
    for (var i = 1; i < ((to.col + dirX - from.col).abs() - 1); i++ ) {
      if (pieces.containsKey(Position(from.row + i * dirY, from.col + i * dirX))) return false;
    }
    return true;
  }

  static bool isLegalMove(Map<Position, Piece> pieces, Position from, Position to) {
    switch (pieces[from]!) {
      case Piece.pawn:
        return (to.row == from.row - 1) && ((to.col == from.col - 1) || (to.col == from.col + 1));
      case Piece.rook:
        return isLegalRookMove(pieces, from, to);
      case Piece.bishop:
        return isLegalBishopMove(pieces, from, to);
      case Piece.knight:
        final row = (from.row - to.row).abs();
        final col = (from.col - to.col).abs();
        return (row == 1 && col == 2) || (row == 2 && col == 1);
      case Piece.queen:
        return isLegalRookMove(pieces, from, to) || isLegalBishopMove(pieces, from, to);
      case Piece.king:
        final row = (from.row - to.row).abs();
        final col = (from.col - to.col).abs();
        return row <= 1 && col <= 1;
      default:
        return false;
    }
  }
}


