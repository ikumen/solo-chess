import 'package:flutter/material.dart';
import 'package:solo_chess/constants.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: appTitle,
        home: Container(
            decoration: const BoxDecoration(color: Colors.black87),
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const <Widget>[
                  Image(image: AssetImage("$imagesBasePath/dark_knight.png"), height: 100,),
                  Text(appTitle, style: TextStyle(decoration: TextDecoration.none, color: Colors.white70)),
                ]
            )
        )
    );
  }
}
