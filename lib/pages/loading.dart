import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(
  home: Loading(),
));

class Loading extends StatelessWidget {
  const Loading({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Loading'
        ),
      ),
    );
  }
}