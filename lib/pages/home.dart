import 'package:flutter/material.dart';
import 'package:imgrep/data/image_repository.dart';
import 'package:imgrep/widgets/app_bar.dart';
import 'package:imgrep/widgets/nav_bar.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final ImageRepository _imageRepo = ImageRepository();
  List<dynamic> _images = [];

  @override
  void initState() {
    super.initState();
    _loadImages();
  }

  Future<void> _loadImages() async {
    final images = await _imageRepo.getImages();
    setState(() => _images = images);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ImGrep_AppBar(),
      body: Container(
        color: Colors.black,
        padding: EdgeInsets.all(8.0),
        child: GridView.builder(
          itemCount: _images.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemBuilder: (context, index) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(_images[index], fit: BoxFit.cover),
            );
          },
        ),
      ),
      bottomNavigationBar: ImGrep_NavBar(),
    );
  }
}
