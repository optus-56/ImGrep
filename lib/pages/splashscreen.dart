import 'dart:async';

import 'package:flutter/material.dart';
import 'package:imgrep/utils/initial_route_controller.dart';
import 'package:lottie/lottie.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 1), () {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder:
              (context, animation, secondaryAnimation) =>
                  InitialRouteController(), 
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: Duration(milliseconds: 300),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Lottie.asset('assets/icons/logosplash.json', height: 600, width: 700),

            Column(
              spacing: 0,
              children: [
                Text(
                  'ImGrep',
                  style: TextStyle(color: Colors.white, fontSize: 33),
                ),
                Text(
                  'Powered By Lobic',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w100,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
