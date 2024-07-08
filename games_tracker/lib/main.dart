import 'package:flutter/material.dart';
import 'view/home.dart';
import 'view/feed.dart';
import 'view/game_page.dart';
//import 'pages/results.dart';

void main(){
  runApp(
    MaterialApp(
      title: "Games Tracker",
      debugShowCheckedModeBanner: false,
      home: const Home(),
      routes: {
        "/feed": (context) => const Feed(),
        "/game_page": (context) => const GamePage(),
        "/home": (context) => const Home()
      },
    ),
  );
}
