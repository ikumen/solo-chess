import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:solo_chess/providers/theme_provider.dart';

class Button extends StatelessWidget {
  final IconData _iconData;
  final Function _onPressed;

  const Button(this._iconData, this._onPressed, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeProvider themeProvider = Provider.of(context, listen: false);
    return FittedBox(
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(color: themeProvider.customTheme.buttonBorder, width: 2),
            borderRadius: const BorderRadius.all(Radius.circular(6.0))),
        margin: const EdgeInsets.fromLTRB(10, 20, 10, 0),
        padding: const EdgeInsets.fromLTRB(30, 2, 30, 2),
        child: IconButton(
            onPressed: () => _onPressed(),
            iconSize: 56,
            icon: Icon(_iconData))
      )
    );
  }
}