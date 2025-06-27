import 'package:flutter/material.dart';
import 'package:imgrep/controllers/image_loader.dart';
import 'package:imgrep/data/image_repository.dart';
import 'package:imgrep/data/local_database.dart';
import 'package:imgrep/utils/debug_logger.dart' show Dbg;
import 'package:imgrep/utils/settings.dart';
import 'package:imgrep/widgets/image_widgets.dart';
import 'package:photo_manager/photo_manager.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final ImageLoader _imageLoader;
  late final LocalDatabase _db;
  bool _isLoading = true;
  bool _isScanning = false;

  @override
  void initState() {
    super.initState();
    _db = LocalDatabase();
    _imageLoader = ImageLoader(ImageRepository(), _db);
    _initialize();
  }

  Future<void> _initialize() async {
    setState(() => _isLoading = true);
    try {
      // Request permissions first
      final PermissionState ps = await PhotoManager.requestPermissionExtend();
      if (ps.isAuth) {
        await _imageLoader.initialize();
        // Run change detection after loading images
        if (HomeScreenSettings.useDeviceImages) {
          _startBackgroundScan();
        }
      } else {
        // Handle permission denied
        Dbg.e(
          ps.hasAccess
              ? "Limited photo access granted"
              : "Photo permission denied",
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _startBackgroundScan() {
    if (_isScanning) return;
    _isScanning = true;
    Future(() async {
      try {
        await _imageLoader.scanAndCompare();
      } catch (e) {
        Dbg.e('Background scan error: $e');
      } finally {
        _isScanning = false;
      }
    });
  }

  Future<void> _refreshImages() async {
    setState(() => _isLoading = true);
    try {
      await _imageLoader.refresh();
      _imageLoader.scanAndCompare(); //no await
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
                    if (_imageLoader.isEmpty) {
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

  bool get _hasPermissionError =>
      imageLoader.statusMessage.contains("Permission") ||
      imageLoader.statusMessage.contains("Error");

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            _hasPermissionError
                ? Icons.error_outline
                : Icons.photo_library_outlined,
            size: 64,
            color: Colors.grey,
          ),
          const SizedBox(height: 16),
          Text(
            imageLoader.statusMessage,
            style: const TextStyle(color: Colors.white, fontSize: 18),
            textAlign: TextAlign.center,
          ),
          if (_hasPermissionError)
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: ElevatedButton(
                onPressed: imageLoader.refresh,
                child: const Text("Retry"),
              ),
            ),
        ],
      ),
    );
  }
}
