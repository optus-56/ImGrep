import 'package:flutter/material.dart';
import 'package:imgrep/pages/home.dart';


final String description = "ImGrep is your AI-powered visual search companion — built to make sense of the images around you. In a world overflowing with digital content, ImGrep helps you cut through the noise and find what matters. \n It doesn't just look at images — it looks into them, extracting meaning, context, and insight.";

class Getstarted extends StatelessWidget {
  const Getstarted({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              spacing: 30,
              children: [
                SizedBox(
                  height: 50,
                  width: 200,
                  child: Center(
                    child: Text(
                      "ImGrep",
                      style: TextStyle(
                        
                        color: Colors.white,
                        fontFamily: 'Poppins',
                        fontSize: 30,
                        fontWeight: FontWeight.w600
                      ),
                    ),
                  ),
                ),

                SizedBox(
                  width: 380,
                  child: Center(
                    child: Text(
                     description,
                      style: TextStyle(
                        color: Color(0xff8E9295),
                        fontFamily: 'Poppins',
                        fontSize: 16.3,
                        height: 1.6,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
            GestureDetector(
              onTap:
                  () => {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => Home()),
                    ),
                  },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Text(
                        "Get Started",
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Poppins',
                          fontSize: 17,
                          decoration:
                              TextDecoration
                                  .none, // we’ll draw underline ourselves
                        ),
                      ),
                      Positioned(
                        bottom: -2, // controls vertical position
                        child: Container(
                          width:
                              90, // match text width manually or use LayoutBuilder
                          height: 1.5,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(width: 8),
                  Image.asset(
                    'assets/icons/arrowforward.png',
                    height: 10,
                    width: 10,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
