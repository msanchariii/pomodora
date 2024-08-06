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
      // home: const Scaffold(
      // body: Center(
      //   child: Column(
      //     mainAxisAlignment: MainAxisAlignment.center,
      //     children: [TimerLabel()],
      //   ),
      // ),

      // appBar: AppBar(),
      // backgroundColor: Color(0xFFFF9494),
      // ),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: "Poppins"),
      home: const Scaffold(
        body: TimerLabel(),
      ),
    );
  }
}
