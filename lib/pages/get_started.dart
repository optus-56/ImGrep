import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(
  home: GetStarted(),
));

class GetStarted extends StatelessWidget {
  const GetStarted({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Get Started'
        ),
      ),
    );
  }
}