import 'package:flutter/material.dart';

class SearchScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Text(
          "Image to be displayed here",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      floatingActionButton: Container(
        margin: EdgeInsets.only(left: 20),
        child: Row(
          children: [
            SizedBox(width: 30),
            SizedBox(
              height: 50,
              width: 70,
              child: FloatingActionButton(
                onPressed: () {},
                backgroundColor: Color(0xFF2B2D30),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Icon(
                  Icons.mic,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(width: 20),
            Expanded(
              child: SizedBox(
                height: 50,
                child: TextField(
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Color(0xFF2B2D30),
                  hintStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                  hintText: 'What are we looking up for today',
                  contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  suffixIcon: Padding(
                    padding: EdgeInsets.only(right: 5),
                    child: IconButton(
                      icon: Icon(
                        Icons.send,
                        color: Colors.white,
                      ),
                      onPressed: () {},
                    ),
                  ),
                ),
              ),
            ),
            ),
            SizedBox(width: 15),
          ],
        ),
      ),
    );
  }
}
