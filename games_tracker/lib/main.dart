import 'package:flutter/material.dart';
import 'view/home.dart';
import 'view/feed_v.dart';
import 'view/game_page_v.dart';
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
        "/feed_visitante": (context) => const FeedV(),
        "/game_page_visitante": (context) => const GamePageV(),
        "/home": (context) => const Home()
      },
    ),
  );
}
