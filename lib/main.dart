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

    setState(() => isRunning = true);

    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingTime > 0) {
        setState(() => remainingTime--);
      } else {
        switchMode();
      }
    });
  }

  void pauseTimer() {
    timer?.cancel();
    setState(() => isRunning = false);
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
    final min = seconds ~/ 60;
    final sec = seconds % 60;
    return '${min.toString().padLeft(2, '0')}:${sec.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final List<Color> backgroundGradient = isFocusMode
        ? [Colors.red.shade400, Colors.red.shade700]
        : [Colors.green.shade400, Colors.green.shade700];

    final Color panelColor = Colors.white.withOpacity(0.15);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: backgroundGradient,
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
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

                // Botones
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
                      onPressed: switchMode,
                      child: const Text('Cambiar modo'),
                    ),
                  ],
                ),

                const SizedBox(height: 30),

                // Panel estético de configuración
                Container(
                  width: 300,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: panelColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'Configuración de tiempos',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Enfoque',
                              style: TextStyle(color: Colors.white)),
                          DropdownButton<int>(
                            value: focusMinutes,
                            dropdownColor:
                                isFocusMode ? Colors.red[600] : Colors.green[600],
                            style: const TextStyle(color: Colors.white),
                            underline: Container(),
                            iconEnabledColor: Colors.white,
                            items: [15, 25, 30, 45, 60]
                                .map(
                                  (e) => DropdownMenuItem(
                                    value: e,
                                    child: Text('$e min'),
                                  ),
                                )
                                .toList(),
                            onChanged:
                                isRunning ? null : (v) => updateFocusMinutes(v!),
                          ),
                        ],
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Descanso',
                              style: TextStyle(color: Colors.white)),
                          DropdownButton<int>(
                            value: breakMinutes,
                            dropdownColor:
                                isFocusMode ? Colors.red[600] : Colors.green[600],
                            style: const TextStyle(color: Colors.white),
                            underline: Container(),
                            iconEnabledColor: Colors.white,
                            items: [5, 10, 15, 20]
                                .map(
                                  (e) => DropdownMenuItem(
                                    value: e,
                                    child: Text('$e min'),
                                  ),
                                )
                                .toList(),
                            onChanged:
                                isRunning ? null : (v) => updateBreakMinutes(v!),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
