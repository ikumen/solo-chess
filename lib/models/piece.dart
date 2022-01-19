/// Game piece
enum Piece {
  pawn, rook, bishop, knight, queen, king
}

/// Coordinates on board, top-left 0,0
class Position {
  final int row;
  final int col;

  Position(this.row, this.col);

  @override
  bool operator ==(Object other) =>
      other is Position && row == other.row && col == other.col;

  @override
  int get hashCode => row.hashCode ^ col.hashCode;
}


