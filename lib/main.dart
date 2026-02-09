import 'dart:async';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: PomodoroPage(),
    );
  }
}

class PomodoroPage extends StatefulWidget {
  @override
  State<PomodoroPage> createState() => _PomodoroPageState();
}

class _PomodoroPageState extends State<PomodoroPage> {
  static const int focusTime = 25 * 60;
  static const int breakTime = 5 * 60;

  int remainingTime = focusTime;
  bool isRunning = false;
  bool isFocusMode = true;
  Timer? timer;

  void startTimer() {
    if (timer != null) return;

    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (remainingTime > 0) {
          remainingTime--;
        } else {
          switchMode();
        }
      });
    });

    setState(() => isRunning = true);
  }

  void pauseTimer() {
    timer?.cancel();
    timer = null;
    setState(() => isRunning = false);
  }

  void resetTimer() {
    pauseTimer();
    setState(() {
      isFocusMode = true;
      remainingTime = focusTime;
    });
  }

  void switchMode() {
    setState(() {
      isFocusMode = !isFocusMode;
      remainingTime = isFocusMode ? focusTime : breakTime;
    });
  }

  String formatTime(int seconds) {
    final min = (seconds ~/ 60).toString().padLeft(2, '0');
    final sec = (seconds % 60).toString().padLeft(2, '0');
    return "$min:$sec";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isFocusMode ? Colors.redAccent : Colors.greenAccent,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              isFocusMode ? "Modo Enfoque" : "Modo Descanso",
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              formatTime(remainingTime),
              style: const TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: isRunning ? pauseTimer : startTimer,
                  child: Text(isRunning ? "Pausar" : "Iniciar"),
                ),
                const SizedBox(width: 15),
                ElevatedButton(
                  onPressed: resetTimer,
                  child: const Text("Reset"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
