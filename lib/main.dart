import 'package:flutter/material.dart';
// import 'package:blearn/home.dart';
import 'package:blearn/chome.dart';

void main() {
  runApp(
    MaterialApp(
      home: Chome(),
      debugShowCheckedModeBanner: false,  
      darkTheme: ThemeData.dark(),
    ),
  );
}
