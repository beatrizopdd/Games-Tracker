import 'package:flutter/material.dart';
import 'view/home.dart';
//import 'pages/results.dart';

void main(){

  runApp(
    const MaterialApp(
      title: "Games Tracker",
      debugShowCheckedModeBanner: false,
      home: Home(),
    ),
  );
}
