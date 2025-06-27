import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Text(
          "Image to be displayed here",
          style: TextStyle(color: Colors.white),
        ),
      ),
      floatingActionButton: Container(
        margin: EdgeInsets.only(left: 20),
        child: Row(
          children: [
            SizedBox(width: 20),
            SizedBox(
              height: 50,
              width: 60,
              child: FloatingActionButton(
                onPressed: () {},
                backgroundColor: Color(0xFF2B2D30),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: SvgPicture.asset('assets/icons/VoiceSearch.svg'),
              ),
            ),

            SizedBox(width: 12),

            Expanded(
              child: SizedBox(
                height: 50,
                child: TextField(
                  style: TextStyle(color: Colors.white, fontSize: 12),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Color(0xFF2B2D30),
                    hintText: 'What are we looking up for today',
                    hintStyle: TextStyle(color: Colors.white70, fontSize: 12),
                    contentPadding: EdgeInsets.symmetric(horizontal: 16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                    suffixIcon: Padding(
                      padding: EdgeInsets.only(right: 8),
                      child: IconButton(
                        onPressed: () {},
                        icon: SvgPicture.asset('assets/icons/SendIcon.svg'),
                        padding: EdgeInsets.zero,
                        constraints: BoxConstraints(),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: 10),
          ],
        ),
      ),
    );
  }
}
