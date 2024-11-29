import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      home: Home(),
    ),
  );
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  static const String defaultInfoText = 'Informe seus dados';

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController weightController = TextEditingController();
  TextEditingController heightController = TextEditingController();
  String infoText = defaultInfoText;

  void resetField() {
    weightController.clear();
    heightController.clear();
    formKey.currentState!.reset();
    setState(() {
      infoText = defaultInfoText;
    });
  }

  void calculateImc() {
    double weight = double.parse(weightController.text);
    double height = double.parse(heightController.text) / 100;
    double imc = weight / (height * height);
    setState(() {
      if (imc < 18.6) {
        infoText = "Abaixo do Peso (${imc.toStringAsPrecision(4)})";
      } else if (imc >= 18.6 && imc < 24.9) {
        infoText = "Peso Ideal (${imc.toStringAsPrecision(4)})";
      } else if (imc >= 24.9 && imc < 29.9) {
        infoText = "Levemente Acima do Peso (${imc.toStringAsPrecision(4)})";
      } else if (imc >= 29.9 && imc < 34.9) {
        infoText = "Obesidade Grau I (${imc.toStringAsPrecision(4)})";
      } else if (imc >= 34.9 && imc < 39.9) {
        infoText = "Obesidade Grau II (${imc.toStringAsPrecision(4)})";
      } else if (imc >= 40) {
        infoText = "Obesidade Grau III (${imc.toStringAsPrecision(4)})";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Calculadora de IMC',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.green,
        actions: <Widget>[
          IconButton(
            onPressed: resetField,
            icon: const Icon(
              Icons.refresh,
              color: Colors.white,
            ),
          )
        ],
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
        child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const Icon(
                  Icons.person_outline,
                  size: 120,
                  color: Colors.green,
                ),
                TextFormField(
                  controller: weightController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Insira seu peso";
                    }
                    return null;
                  },
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                      labelText: 'Peso (Kg)',
                      labelStyle: TextStyle(
                        color: Colors.green,
                      )),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.green,
                    fontSize: 25.0,
                  ),
                ),
                TextFormField(
                  controller: heightController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Insira sua altura";
                    }
                    return null;
                  },
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                      labelText: 'Altura (Cm)',
                      labelStyle: TextStyle(
                        color: Colors.green,
                      )),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.green,
                    fontSize: 25.0,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 15.0,
                    bottom: 15.0,
                  ),
                  child: Container(
                    height: 50.0,
                    child: ElevatedButton(
                      onPressed: () {
                        if (formKey.currentState!.validate ()
                        ) {
                        calculateImc();
                        }
                      },
                      style: const ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(Colors.green),
                      ),
                      child: const Text(
                        'Calcular',
                        style: TextStyle(color: Colors.white, fontSize: 25.0),
                      ),
                    ),
                  ),
                ),
                Text(
                  infoText,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.green,
                    fontSize: 25.0,
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
