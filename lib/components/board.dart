import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:solo_chess/constants.dart';
import 'package:solo_chess/models/game.dart';
import 'package:solo_chess/models/piece.dart';
import 'package:solo_chess/providers/theme_provider.dart';

class Board extends StatefulWidget {
  // Number of rows/cols, board is square
  final int _size;
  // Length of board side
  final int _dimension;
  // Length of cell side
  final double _cellDimension;
  // Game
  final Game _game;
  final Function(Position position) _onSelectSquare;

  Board(this._size, this._dimension, this._game, this._onSelectSquare, {Key? key})
    : _cellDimension = (_dimension / _size).floorToDouble(),
      super(key: key);

  @override
  State createState() => _BoardState();
}

class _BoardState extends State<Board> {

  @override
  Widget build(BuildContext context) {
    final ThemeProvider themeProvider =
      Provider.of<ThemeProvider>(context, listen: false);

    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: themeProvider.customTheme.boardBorder,
              width: 5)),
          child: Column(
            children: _buildSquares(context, themeProvider),
          ),
        )
      ],
    );
  }

  List<Widget> _buildSquares(BuildContext context, ThemeProvider themeProvider) {
    final String assetUrlPrefix =
        "$imagesBasePath${themeProvider.theme.brightness.name}_";
    final gameState = widget._game.state;

    return List.generate(widget._size, (i) {
      return Row(children: List.generate(widget._size, (k) {
        Position position = Position(i, k);
        bool selected = gameState.selectedPosition != null
            && gameState.selectedPosition == position;
        Piece? piece = gameState.pieces[position];
        Widget square = piece == null
            ? _buildEmptySquare(context, themeProvider.customTheme, i, k)
            : _buildSquare(context, themeProvider.customTheme, i, k,
                (assetUrlPrefix + piece.name + ".png"), selected);

        return SizedBox(
          height: widget._cellDimension,
            width: widget._cellDimension,
            child: square
          );
      }));
    });
  }

  Widget _buildEmptySquare(BuildContext context, CustomTheme customTheme, int row, int col) {
    return Container(
      color: customTheme.squareColors[(row + col) % 2],
      child: const FittedBox(fit: BoxFit.contain,)
    );
  }

  Widget _buildSquare(BuildContext context, CustomTheme customTheme, int row, int col, String pieceUrl, bool selected) {
    return InkWell(
      onTap: () => widget._onSelectSquare(Position(row, col)),
      child: Container(
        color: customTheme.squareColors[(row + col) % 2],
        child: Container(
          decoration: BoxDecoration(color: selected ? Colors.yellow : Colors.transparent),
          child: Image(
            fit: BoxFit.contain,
            image: AssetImage(pieceUrl)
          ),
        ),
      )
    );
  }
}