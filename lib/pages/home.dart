import 'package:flutter/material.dart';
import 'package:imgrep/controllers/image_loader.dart';
import 'package:imgrep/data/image_repository.dart';
import 'package:imgrep/widgets/app_bar.dart';
import 'package:imgrep/widgets/image_widgets.dart';
import 'package:imgrep/widgets/nav_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final ImageLoader _imageLoader;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _imageLoader = ImageLoader(ImageRepository());
    _initialize();
  }

  Future<void> _initialize() async {
    setState(() => _isLoading = true);
    try {
      await _imageLoader.initialize();
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _refreshImages() async {
    setState(() => _isLoading = true);
    try {
      await _imageLoader.refresh();
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _imageLoader.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ImGrep_AppBar(),
      backgroundColor: Colors.black,
      body: RefreshIndicator(
        onRefresh: _refreshImages,
        color: Colors.grey[400],
        child:
            _isLoading
                ? const Center(child: CircularProgressIndicator(strokeWidth: 2))
                : ImageGrid(imageLoader: _imageLoader),
      ),
      bottomNavigationBar: const ImGrep_NavBar(),
    );
  }
}
