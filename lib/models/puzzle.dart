import 'package:solo_chess/models/piece.dart';

class SolutionStep {
  final Position from;
  final Position to;

  SolutionStep(this.from, this.to);
}

class Puzzle {
  final Map<Position, Piece> pieces;
  final List<SolutionStep> solution;

  Puzzle(this.pieces, this.solution);
}
