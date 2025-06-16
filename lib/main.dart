import 'package:flutter/material.dart';
import 'package:imgrep/pages/get_started.dart';
import 'package:imgrep/pages/home.dart';
import 'package:imgrep/pages/loading.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "ImGrep",
      theme: ThemeData(
        primaryColor: Color(0xFF141718),
        fontFamily: 'Poppins',
        textTheme: const TextTheme(
          bodyLarge: TextStyle(fontSize: 18),
          titleLarge: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),

      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(),
        'loading': (context) => Loading(),
        'getStarted': (context) => GetStarted(),
      },
    );
  }
}

// note : if things breaks : consider toggling the 'useDeviceImages' to false in lib/utils/settings.dart
