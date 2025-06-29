import 'dart:io';

import 'package:flutter/material.dart';
import 'package:imgrep/controllers/image_loader.dart';
import 'package:imgrep/data/image_repository.dart';
import 'package:imgrep/utils/debug_logger.dart' show Dbg;
import 'package:imgrep/widgets/image_widgets.dart';
import 'package:photo_manager/photo_manager.dart';

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
      if (Platform.isAndroid) {
        // Request permissions first
        final PermissionState ps = await PhotoManager.requestPermissionExtend();
        if (ps.isAuth) {
          await _imageLoader.initialize();
        } else {
          // Handle permission denied
          Dbg.e(
            ps.hasAccess
                ? "Limited photo access granted"
                : "Photo permission denied",
          );
        }
      } else {
        await _imageLoader.initialize();
      }
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
      backgroundColor: Colors.black,
      body: RefreshIndicator(
        onRefresh: _refreshImages,
        color: Colors.grey[400],
        child:
            _isLoading
                ? const Center(child: CircularProgressIndicator(strokeWidth: 2))
                : ListenableBuilder(
                  listenable: _imageLoader,
                  builder: (context, _) {
                    if (_imageLoader.isEmpty && Platform.isAndroid) {
                      return PermissionStatusWidget(imageLoader: _imageLoader);
                    }
                    return ImageGrid(imageLoader: _imageLoader);
                  },
                ),
      ),
    );
  }
}

class PermissionStatusWidget extends StatelessWidget {
  final ImageLoader imageLoader;

  const PermissionStatusWidget({super.key, required this.imageLoader});

  @override
  Widget build(BuildContext context) {
    if (imageLoader.isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text(
              "Loading images...",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ],
        ),
      );
    }

    if (imageLoader.hasError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              imageLoader.error ?? "Unknown error",
              style: const TextStyle(color: Colors.white, fontSize: 18),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: imageLoader.refresh,
              child: const Text("Retry"),
            ),
          ],
        ),
      );
    }

    if (imageLoader.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.photo_library_outlined, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              "No images found",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ],
        ),
      );
    }
    return const SizedBox.shrink();
  }
}
