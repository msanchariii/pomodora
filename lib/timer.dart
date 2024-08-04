import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum TimerState { paused, stopped, playing }

enum PomodoroState { workingTime, breakTime }

// ignore: constant_identifier_names
const int WORKTIME = 1 * 60;
// ignore: constant_identifier_names
const int BREAKTIME = 5 * 60;

class TimerLabel extends StatefulWidget {
  TimerLabel({super.key});
  TimerState timerState = TimerState.stopped;
  Duration timeLeft = const Duration(seconds: WORKTIME);
  Timer _t = Timer(const Duration(seconds: 1), () {});
  PomodoroState pomodoroState = PomodoroState.workingTime;

  @override
  State<TimerLabel> createState() => _TimerLabelState();
}

class _TimerLabelState extends State<TimerLabel> {
  decreaseTimer(Timer timer) {
    setState(() {
      if (widget.timeLeft.inSeconds == 0) {
        switch (widget.pomodoroState) {
          case PomodoroState.workingTime:
            widget.pomodoroState = PomodoroState.breakTime;
            widget.timeLeft = const Duration(seconds: BREAKTIME);
            break;
          case PomodoroState.breakTime:
            widget.pomodoroState = PomodoroState.workingTime;
            widget.timeLeft = const Duration(seconds: WORKTIME);

            break;
          // default:
        }
      }
      widget.timeLeft = Duration(seconds: widget.timeLeft.inSeconds - 1);
    });
  }

  playTimer() {
    // print("playing");
    HapticFeedback.lightImpact();
    setState(() {
      widget._t = Timer.periodic(const Duration(seconds: 1), decreaseTimer);
      widget.timerState = TimerState.playing;
    });
  }

  pauseTimer() {
    HapticFeedback.lightImpact();
    setState(() {
      widget.timerState = TimerState.paused;
      widget._t.cancel();
    });
  }

  stopTimer() {
    // print("stopTimer");
    setState(() {
      widget.timerState = TimerState.stopped;
      widget._t.cancel();
      if (widget.pomodoroState == PomodoroState.workingTime) {
        widget.timeLeft = const Duration(minutes: 25);
      } else {
        widget.timeLeft = const Duration(minutes: 5);
      }
    });
    // print(widget.timerState);
  }

  computeIcon() {
    if (widget.timerState == TimerState.playing) {
      return const Icon(Icons.pause, color: Color(0xFFFFF5E4));
    } else {
      return const Icon(Icons.play_arrow, color: Color(0xFFFFF5E4));
    }
  }

  computeButtonCallback() {
    if (widget.timerState == TimerState.paused ||
        widget.timerState == TimerState.stopped) {
      return playTimer;
    } else {
      return pauseTimer;
    }
  }

  computePomodoroText() {
    if (widget.pomodoroState == PomodoroState.breakTime) {
      return "Take a break";
    } else {
      return "Hop on";
    }
  }

  @override
  Widget build(BuildContext context) {
    // print("widget is building");
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          margin: const EdgeInsets.fromLTRB(0, 0, 0, 20),
          // color: Colors.blue[200],
          child: Text(
            "${widget.timeLeft.inMinutes.remainder(60)}:${(widget.timeLeft.inSeconds.remainder(60).toString().padLeft(2, '0'))}",
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
                  value: widget.timeLeft.inSeconds.toDouble() /
                      (widget.pomodoroState == PomodoroState.workingTime
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
          margin: const EdgeInsets.all(20),
          child: Text(
            computePomodoroText(),
            style: const TextStyle(fontSize: 24, color: Color(0xFFFFF5E4)),
          ),
        ),
        widget.timerState != TimerState.stopped
            ? Container(
                height: 100,
                // color: Colors.blue[200],
                width: 100,
                child: IconButton(
                    onPressed: stopTimer,
                    icon: const Icon(Icons.stop_circle_outlined),
                    iconSize: 50,
                    color: const Color(0xFFFFF5E4)))
            : const SizedBox(
                height: 100,
                width: 100,
              )
      ],
    );
  }
}
