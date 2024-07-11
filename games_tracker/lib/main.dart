import 'package:flutter/material.dart';
import 'view/home.dart';
import 'view/feed.dart';
import 'view/game_page.dart';
import 'view/reviews_page.dart';
import 'view/visitante_feed.dart';
import 'view/visitante_game_page.dart';
import 'view/visitante_reviews_page.dart';

void main() {
  runApp(
    MaterialApp(
      title: "Games Tracker",
      debugShowCheckedModeBanner: false,
      home: const Home(),
      routes: {
        "/home": (context) => const Home(),
        "/feed": (context) => const Feed(),
        "/game_page": (context) => const GamePage(),
        "/reviews_page": (context) => const ReviewPage(),
        "/feed_visitante": (context) => const FeedVisitante(),
        "/game_page_visitante": (context) => const GamePageVisitante(),
        "/reviews_page_visitante": (context) => const ReviewPageVisitante(),
      },
    ),
  );
}
