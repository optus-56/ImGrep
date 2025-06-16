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
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _imageLoader = ImageLoader();
    _setLoadingState(true);
    _imageLoader.initialize().then((_) => _setLoadingState(false));
  }

  @override
  void dispose() {
    _imageLoader.dispose();
    super.dispose();
  }

  void _setLoadingState(bool isLoading) {
    setState(() {
      _isLoading = isLoading;
    });
  }

  Future<void> _refreshImages() async {
    _setLoadingState(true);
    await _imageLoader.refresh();
    _setLoadingState(false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: RefreshIndicator(
        onRefresh: _refreshImages,
        color: Colors.grey[400],
        child:
            _isLoading
                ? const Center(
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
                : ImageGrid(imageLoader: _imageLoader),
      ),
    );
  }
}
