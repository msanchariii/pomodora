import 'package:flutter/material.dart';
import 'package:pomodoro/timer.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [TimerLabel()],
          ),
        ),
        // appBar: AppBar(),
        backgroundColor: const Color(0xFFFF9494),
      ),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: "Poppins"),
    );
  }
}

// Poppins
// Lato
// Raleway
// Nunito Sans
// Fira Sans
// Barlow
// Josefin Sans
// Jost