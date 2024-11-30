import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

final Uri request =
    Uri.https('api.hgbrasil.com', '/finance', {'key': 'bf62a926'});

void main() async {
  runApp(MaterialApp(
    home: const Home(),
    theme: ThemeData(
        hintColor: Colors.amber,
        primaryColor: Colors.white,
        inputDecorationTheme: const InputDecorationTheme(
          enabledBorder:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.amber)),
          focusedBorder:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.amber)),
          hintStyle: TextStyle(color: Colors.amber),
        )),
  ));
}

Future<Map> getData() async {
  http.Response response = await http.get(request);
  return json.decode(response.body);
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late double _dolar;
  late double _euro;

  final TextEditingController _realController = TextEditingController();
  final TextEditingController _dolarController = TextEditingController();
  final TextEditingController _euroController = TextEditingController();

  void clearAllTexts() {
    _realController.clear();
    _dolarController.clear();
    _euroController.clear();
  }

  void _realChanged(String text) {
    if (text.isEmpty) {
      clearAllTexts();
      return;
    }

    double real = double.parse(text);
    _dolarController.text = (real * _dolar).toStringAsFixed(2);
    _euroController.text = (real * _euro).toStringAsFixed(2);
  }

  void _dolarChanged(String text) {
    if (text.isEmpty) {
      clearAllTexts();
      return;
    }

    double dolar = double.parse(text);
    _realController.text = (dolar * _dolar).toStringAsFixed(2);
    _euroController.text = ((dolar * dolar) / _euro).toStringAsFixed(2);
  }

  void _euroChanged(String text) {
    if (text.isEmpty) {
      clearAllTexts();
      return;
    }

    double euro = double.parse(text);
    _realController.text = (euro * _euro).toStringAsFixed(2);
    _dolarController.text = ((euro * _euro) / _dolar).toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('\$ Conversor \$'),
        backgroundColor: Colors.amber,
        centerTitle: true,
      ),
      body: FutureBuilder<Map>(
        future: getData(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return const Center(
                child: Text(
                  'Carregando dados',
                  style: TextStyle(color: Colors.amber, fontSize: 25),
                  textAlign: TextAlign.center,
                ),
              );
            default:
              if (snapshot.hasError) {
                return const Center(
                    child: Text(
                  'Falha ao carregar Dados',
                  style: TextStyle(color: Colors.amber, fontSize: 25),
                  textAlign: TextAlign.center,
                ));
              } else {
                _dolar = snapshot.data!["results"]["currencies"]["USD"]["buy"];
                _euro = snapshot.data!["results"]["currencies"]["EUR"]["buy"];
                return SingleChildScrollView(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Icon(
                        Icons.monetization_on,
                        size: 150.0,
                        color: Colors.amber,
                      ),
                      const Divider(
                        color: Colors.black,
                      ),
                      _buildTextField(
                        labelText: "Reais",
                        prefixText: "R\$",
                        textEditingController: _realController,
                        onChanged: _realChanged,
                      ),
                      const Divider(
                        color: Colors.black,
                      ),
                      _buildTextField(
                        labelText: "Dólares",
                        prefixText: "US\$",
                        textEditingController: _dolarController,
                        onChanged: _dolarChanged,
                      ),
                      const Divider(
                        color: Colors.black,
                      ),
                      _buildTextField(
                        labelText: "Euros",
                        prefixText: "€",
                        textEditingController: _euroController,
                        onChanged: _euroChanged,
                      ),
                    ],
                  ),
                );
              }
          }
        },
      ),
    );
  }
}

Widget _buildTextField(
    {required String labelText,
    required String prefixText,
    required TextEditingController textEditingController,
    required void Function(String text) onChanged}) {
  return TextField(
    controller: textEditingController,
    onChanged: onChanged,
    keyboardType: const TextInputType.numberWithOptions(
      decimal: true,
    ),
    decoration: InputDecoration(
      labelText: labelText,
      labelStyle: const TextStyle(
        color: Colors.amber,
      ),
      border: const OutlineInputBorder(),
      prefixText: prefixText,
    ),
    style: const TextStyle(
      color: Colors.amber,
      fontSize: 25.0,
    ),
  );
}
