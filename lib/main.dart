import 'dart:async';
import 'package:flutter/material.dart';

void main() {
  runApp(const PomodoroApp());
}

class PomodoroApp extends StatelessWidget {
  const PomodoroApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: PomodoroHome(),
    );
  }
}

class PomodoroHome extends StatefulWidget {
  const PomodoroHome({super.key});

  @override
  State<PomodoroHome> createState() => _PomodoroHomeState();
}

class _PomodoroHomeState extends State<PomodoroHome> {
  static const int focusTime = 25 * 60;
  static const int breakTime = 5 * 60;

  int remainingTime = focusTime;
  bool isRunning = false;
  bool isFocusMode = true;

  Timer? timer;

  void startTimer() {
    if (isRunning) return;

    setState(() {
      isRunning = true;
    });

    timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      if (remainingTime > 0) {
        setState(() {
          remainingTime--;
        });
      } else {
        switchMode();
      }
    });
  }

  void pauseTimer() {
    timer?.cancel();
    setState(() {
      isRunning = false;
    });
  }

  void resetTimer() {
    pauseTimer();
    setState(() {
      remainingTime = isFocusMode ? focusTime : breakTime;
    });
  }

  void switchMode() {
    pauseTimer();
    setState(() {
      isFocusMode = !isFocusMode;
      remainingTime = isFocusMode ? focusTime : breakTime;
    });
  }

  // 🔹 Cambio manual de modo (clave para la demo)
  void changeModeManually() {
    pauseTimer();
    setState(() {
      isFocusMode = !isFocusMode;
      remainingTime = isFocusMode ? focusTime : breakTime;
    });
  }

  String formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isFocusMode ? Colors.red[400] : Colors.green[400],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              isFocusMode ? 'MODO ENFOQUE 🍅' : 'MODO DESCANSO 😴',
              style: const TextStyle(
                fontSize: 28,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              formatTime(remainingTime),
              style: const TextStyle(
                fontSize: 64,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: isRunning ? pauseTimer : startTimer,
                  child: Text(isRunning ? 'Pausar' : 'Iniciar'),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: resetTimer,
                  child: const Text('Reset'),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: changeModeManually,
                  child: const Text('Cambiar modo'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'Modo manual para pruebas y demostración',
              style: TextStyle(color: Colors.white70),
            )
          ],
        ),
      ),
    );
  }
}
