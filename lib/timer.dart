import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pomodoro/audio/audiocontroller.dart';

enum TimerState { paused, stopped, playing }

enum PomodoroState { workstate, breakstate }

// ignore: constant_identifier_names
const int WORKTIME = 10;
// ignore: constant_identifier_names
const int BREAKTIME = 5;

class TimerLabel extends StatefulWidget {
  const TimerLabel({super.key});

  @override
  State<TimerLabel> createState() => _TimerLabelState();
}

class _TimerLabelState extends State<TimerLabel> {
  // TODO: implement animation
  // late AnimationController _controller;
  // late Animation<double> _animation;

  AudioController soundManager = AudioController();

  TimerState timerState = TimerState.stopped;
  Duration timeLeft = const Duration(seconds: WORKTIME);
  Timer _t = Timer(const Duration(seconds: 1), () {});
  PomodoroState pomodoroState = PomodoroState.workstate;

<<<<<<< Updated upstream
=======
  @override
  void dispose() {
    // _controller.dispose();
    super.dispose();
    soundManager.dispose();
  }

  @override
  void initState() {
    super.initState();
    soundManager.initialize();
    // _controller =
    //     AnimationController(duration: const Duration(seconds: 1), vsync: this);
    // _animation = Tween<double>(begin: 0, end: 1).animate(_controller);

    // _controller.forward();
  }

>>>>>>> Stashed changes
  // decreases the timer count for each second
  decreaseTimer(Timer timer) {
    setState(() {
      if (timeLeft.inSeconds == 0) {
        switch (pomodoroState) {
          case PomodoroState.workstate:
            soundManager.playSound(
                "assets/audio/mixkit-kids-cartoon-close-bells-2256.wav");
            pomodoroState = PomodoroState.breakstate;
            timeLeft = const Duration(seconds: BREAKTIME);
            break;
          case PomodoroState.breakstate:
            soundManager
                .playSound("assets/audio/mixkit-alert-bells-echo-765.wav");
            pomodoroState = PomodoroState.workstate;
            timeLeft = const Duration(seconds: WORKTIME);
            break;
        }
      }
      timeLeft = Duration(seconds: timeLeft.inSeconds - 1);
    });
  }

  // starts the timer if timer is stopper or paused
  playTimer() {
    HapticFeedback.lightImpact();
    setState(() {
      _t = Timer.periodic(const Duration(seconds: 1), decreaseTimer);
      timerState = TimerState.playing;
    });
  }

  // pauses the timer
  pauseTimer() {
    HapticFeedback.lightImpact();
    setState(() {
      timerState = TimerState.paused;
      _t.cancel();
    });
  }

  // stops and resets the timer
  stopTimer() {
    HapticFeedback.heavyImpact();
    soundManager.playSound("./assets/audio/mixkit-alert-bells-echo-765.wav");
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

  computeColor() {
    if (pomodoroState == PomodoroState.workstate) {
      return const Color(0xff68a691);
    } else {
      return const Color(0xFFFF9494);
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

  computeProgressValue() {
    final denom = (pomodoroState == PomodoroState.workstate
        ? WORKTIME.toDouble()
        : BREAKTIME.toDouble());

    final value = timeLeft.inSeconds.toDouble() / denom;
    print(value);
    return value;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: computeColor(),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.fromLTRB(0, 0, 0, 20),
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
                    width: 250,
                    height: 250,
                    child: CircularProgressIndicator(
                      strokeCap: StrokeCap.round,
                      strokeWidth: 10,
                      color: const Color(0xFFFFF5E4),
<<<<<<< Updated upstream
                      value: timeLeft.inSeconds.toDouble() /
                          (pomodoroState == PomodoroState.workstate
                              ? WORKTIME.toDouble()
                              : BREAKTIME.toDouble()),
=======
                      value: computeProgressValue(),
>>>>>>> Stashed changes
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
        ));
  }
}

// #68a691
