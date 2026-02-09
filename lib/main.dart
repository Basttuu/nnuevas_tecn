import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(home: EcoLog()));
}

class EcoLog extends StatefulWidget {
  @override
  _EcoLogState createState() => _EcoLogState();
}

class _EcoLogState extends State<EcoLog> {
  final List<String> _data = [];
  final TextEditingController _input = TextEditingController();

  Color _backgroundColor = Colors.white;
  String _colorSeleccionado = "Blanco";

  void _cambiarColor(Color color, String nombre) {
    setState(() {
      _backgroundColor = color;
      _colorSeleccionado = nombre;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: AppBar(
        title: Text("EcoTracker PoC"),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              "Color seleccionado: $_colorSeleccionado",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),

          // Botones de color
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                onPressed: () =>
                    _cambiarColor(Colors.green.shade100, "Verde"),
                child: Text("Verde"),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                onPressed: () =>
                    _cambiarColor(Colors.blue.shade100, "Azul"),
                child: Text("Azul"),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                onPressed: () =>
                    _cambiarColor(Colors.grey.shade300, "Gris"),
                child: Text("Gris"),
              ),
            ],
          ),

          SizedBox(height: 20),

          Padding(
            padding: EdgeInsets.all(16),
            child: TextField(
              controller: _input,
              decoration: InputDecoration(
                labelText: "Nombre del Punto",
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _data.add(_input.text);
                _input.clear();
              });
            },
            child: Text("Registrar Punto"),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _data.length,
              itemBuilder: (c, i) => ListTile(
                title: Text(_data[i]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
