import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum TimerState { paused, stopped, playing }

enum PomodoroState { workstate, breakstate }

// ignore: constant_identifier_names
const int WORKTIME = 1 * 60;
// ignore: constant_identifier_names
const int BREAKTIME = 5 * 60;

class TimerLabel extends StatefulWidget {
  const TimerLabel({super.key});

  @override
  State<TimerLabel> createState() => _TimerLabelState();
}

class _TimerLabelState extends State<TimerLabel> {
  TimerState timerState = TimerState.stopped;
  Duration timeLeft = const Duration(seconds: WORKTIME);
  Timer _t = Timer(const Duration(seconds: 1), () {});
  PomodoroState pomodoroState = PomodoroState.workstate;

  decreaseTimer(Timer timer) {
    setState(() {
      if (timeLeft.inSeconds == 0) {
        switch (pomodoroState) {
          case PomodoroState.workstate:
            pomodoroState = PomodoroState.breakstate;
            timeLeft = const Duration(seconds: BREAKTIME);
            break;
          case PomodoroState.breakstate:
            pomodoroState = PomodoroState.workstate;
            timeLeft = const Duration(seconds: WORKTIME);

            break;
          // default:
        }
      }
      timeLeft = Duration(seconds: timeLeft.inSeconds - 1);
    });
  }

  playTimer() {
    // print("playing");
    HapticFeedback.lightImpact();
    setState(() {
      _t = Timer.periodic(const Duration(seconds: 1), decreaseTimer);
      timerState = TimerState.playing;
    });
  }

  pauseTimer() {
    HapticFeedback.lightImpact();
    setState(() {
      timerState = TimerState.paused;
      _t.cancel();
    });
  }

  stopTimer() {
    HapticFeedback.heavyImpact();
    setState(() {
      pomodoroState = PomodoroState.workstate;
      timerState = TimerState.stopped;
      _t.cancel();
      timeLeft = const Duration(seconds: WORKTIME);
    });
  }

  computeIcon() {
    if (timerState == TimerState.playing) {
      return const Icon(Icons.pause, color: Color(0xFFFFF5E4));
    } else {
      return const Icon(Icons.play_arrow, color: Color(0xFFFFF5E4));
    }
  }

  computeButtonCallback() {
    if (timerState == TimerState.paused || timerState == TimerState.stopped) {
      return playTimer;
    } else {
      return pauseTimer;
    }
  }

  computePomodoroText() {
    // if (pomodoroState == PomodoroState.breakTime) {
    //   return "Take a break";
    // } else {
    //     if (timerState == TimerState.playing) {
    //       return "Focus";
    //     } else{
    //         return "";
    //     }
    // }
    switch (timerState) {
      case TimerState.playing:
        if (pomodoroState == PomodoroState.breakstate) {
          return "Take a break";
        } else {
          return "Focus";
        }
      case TimerState.paused:
        if (pomodoroState == PomodoroState.breakstate) {
          return "Paused : BreakTime";
        } else {
          return "Paused : FocusTime";
        }
      case TimerState.stopped:
        return "Start the timer";
      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          margin: const EdgeInsets.fromLTRB(0, 0, 0, 20),
          // color: Colors.blue[200],
          child: Text(
            "${timeLeft.inMinutes.remainder(60)}:${(timeLeft.inSeconds.remainder(60).toString().padLeft(2, '0'))}",
            style: const TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Color(0xFFFFF5E4)),
          ),
        ),
        Stack(
          children: [
            Center(
              child: SizedBox(
                // backgroundColor: Colors.blue[200],

                width: 250,
                height: 250,
                child: CircularProgressIndicator(
                  strokeCap: StrokeCap.round,
                  strokeWidth: 10,
                  color: const Color(0xFFFFF5E4),
                  value: timeLeft.inSeconds.toDouble() /
                      (pomodoroState == PomodoroState.workstate
                          ? WORKTIME.toDouble()
                          : BREAKTIME.toDouble()),
                ),
              ),
            ),
            Center(
              child: SizedBox(
                width: 250,
                height: 250,
                child: IconButton(
                  onPressed: computeButtonCallback(),
                  icon: computeIcon(),
                  iconSize: 180,
                ),
              ),
            ),
          ],
        ),
        Container(
          // color: Colors.blue[200],
          margin: const EdgeInsets.fromLTRB(0, 50, 0, 20),
          child: Text(
            computePomodoroText(),
            style: const TextStyle(
                fontSize: 36,
                color: Color(0xFFFFF5E4),
                fontWeight: FontWeight.bold),
          ),
        ),
        timerState != TimerState.stopped
            ? SizedBox(
                height: 100,
                width: 100,
                child: IconButton(
                  onPressed: stopTimer,
                  icon: const Icon(Icons.stop_circle_outlined),
                  iconSize: 50,
                  color: const Color(0xFFFFF5E4),
                ),
              )
            : const SizedBox(
                height: 100,
                width: 100,
              )
      ],
    );
  }
}
