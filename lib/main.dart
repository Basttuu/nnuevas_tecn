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
  int focusMinutes = 25;
  int breakMinutes = 5;

  int remainingTime = 25 * 60;
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
      remainingTime =
          isFocusMode ? focusMinutes * 60 : breakMinutes * 60;
    });
  }

  void switchMode() {
    pauseTimer();
    setState(() {
      isFocusMode = !isFocusMode;
      remainingTime =
          isFocusMode ? focusMinutes * 60 : breakMinutes * 60;
    });
  }

  void changeModeManually() {
    switchMode();
  }

  void updateFocusMinutes(int value) {
    setState(() {
      focusMinutes = value;
      if (isFocusMode && !isRunning) {
        remainingTime = focusMinutes * 60;
      }
    });
  }

  void updateBreakMinutes(int value) {
    setState(() {
      breakMinutes = value;
      if (!isFocusMode && !isRunning) {
        remainingTime = breakMinutes * 60;
      }
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
        child: SingleChildScrollView(
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

              // Controles del temporizador
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

              const SizedBox(height: 30),

              // Configuración de tiempos
              Card(
                margin: const EdgeInsets.symmetric(horizontal: 24),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      const Text(
                        'Configuración de tiempos (minutos)',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Enfoque'),
                          DropdownButton<int>(
                            value: focusMinutes,
                            items: [15, 25, 30, 45, 60]
                                .map((e) => DropdownMenuItem(
                                      value: e,
                                      child: Text('$e'),
                                    ))
                                .toList(),
                            onChanged: isRunning
                                ? null
                                : (value) =>
                                    updateFocusMinutes(value!),
                          ),
                        ],
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Descanso'),
                          DropdownButton<int>(
                            value: breakMinutes,
                            items: [5, 10, 15, 20]
                                .map((e) => DropdownMenuItem(
                                      value: e,
                                      child: Text('$e'),
                                    ))
                                .toList(),
                            onChanged: isRunning
                                ? null
                                : (value) =>
                                    updateBreakMinutes(value!),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
