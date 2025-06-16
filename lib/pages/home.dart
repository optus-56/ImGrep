import 'package:flutter/material.dart';
import 'package:imgrep/controllers/image_loader.dart';
import 'package:imgrep/widgets/image_widgets.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final ImageLoader _imageLoader;

  @override
  void initState() {
    super.initState();
    _imageLoader = ImageLoader();
    _imageLoader.initialize();
  }

  @override
  void dispose() {
    _imageLoader.dispose();
    super.dispose();
  }

  Future<void> _refreshImages() async {
    await _imageLoader.refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      backgroundColor: Colors.black,
      body: ImageGrid(imageLoader: _imageLoader),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: ListenableBuilder(
        listenable: _imageLoader,
        builder: (context, child) {
          return Text('ImGrep', style: const TextStyle(color: Colors.white));
        },
      ),
      backgroundColor: Colors.black,
      actions: [
        IconButton(
          onPressed: _refreshImages,
          icon: const Icon(Icons.refresh, color: Colors.white),
          tooltip: 'Refresh',
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.sort, color: Colors.white),
        ),
      ],
    );
  }
}
