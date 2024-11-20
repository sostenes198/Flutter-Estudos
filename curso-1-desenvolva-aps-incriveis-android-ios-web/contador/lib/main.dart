import 'package:flutter/material.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int countPerson = 0;

  void decrement() {
    setState(() {
      countPerson--;
    });
    print('Decrement: ${countPerson}');
  }

  void increment() {
    setState(() {
      countPerson++;
    });
    print('Increment: ${countPerson}');
  }

  bool get isEmpty => countPerson == 0;

  bool get isFull => countPerson == 20;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
                'assets/images/imagem-borrada-de-pessoas-no-mercado-do-festival-de-comida.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Pode entrar',
              style: TextStyle(
                fontSize: 30,
                color: Colors.white,
                fontWeight: FontWeight.w500,
                letterSpacing: 4,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(32),
              child: Text(
                '$countPerson',
                style: TextStyle(
                  fontSize: 100,
                  color: isFull ? Colors.red : Colors.white,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: isEmpty ? null : decrement,
                  style: TextButton.styleFrom(
                    backgroundColor:
                        isEmpty ? Colors.white.withOpacity(0.2) : Colors.white,
                    fixedSize: const Size(100, 100),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100)),
                    // padding: const EdgeInsets.all(32)
                  ),
                  child: const Text(
                    'Saiu',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 32,
                ),
                TextButton(
                  onPressed: isFull ? null : increment,
                  style: TextButton.styleFrom(
                    backgroundColor:
                        isFull ? Colors.white.withOpacity(0.2) : Colors.white,
                    fixedSize: const Size(100, 100),
                    // padding: const EdgeInsets.all(32)
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100)),
                  ),
                  child: const Text(
                    'Entrou',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
