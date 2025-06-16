import 'package:flutter/foundation.dart';
import 'package:imgrep/data/image_repository.dart';
import 'package:imgrep/utils/debug_logger.dart';
import 'package:imgrep/utils/settings.dart';

/// Handles all image loading logic and state management
class ImageLoader extends ChangeNotifier {
  final ImageRepository _repository;
  final List<dynamic> _images = [];
  final Map<String, Uint8List> _thumbnailCache = {};
  bool _isLoading = false;
  bool _hasMoreImages = true;
  String _statusMessage = "Loading...";
  int _currentPage = 0;

  ImageLoader(this._repository);

  // Getters
  List<dynamic> get images => _images;
  int get imageCount => _images.length;
  String get statusMessage => _statusMessage;
  bool get isEmpty => _images.isEmpty;
  bool get isLoading => _isLoading;
  bool get hasMoreImages => _hasMoreImages;

  // Thumbnail cache methods
  Uint8List? getCachedThumbnail(String key) => _thumbnailCache[key];
  void cacheThumbnail(String key, Uint8List data) =>
      _thumbnailCache[key] = data;

  /// Initialize image loading
  Future<void> initialize() async {
    _statusMessage =
        HomeScreenSettings.useDeviceImages
            ? "Requesting permissions..."
            : "Loading asset images...";
    notifyListeners();

    try {
      await loadMoreImages();
    } catch (e) {
      Dbg.e('Error initializing images: $e');
      _statusMessage = "Error loading images: $e";
      notifyListeners();
    }
  }

  /// Load more images (pagination for device images)
  Future<void> loadMoreImages() async {
    if (_isLoading || !_hasMoreImages) return;
    _isLoading = true;
    _statusMessage =
        HomeScreenSettings.useDeviceImages
            ? "Loading device images..."
            : "Loading assets...";
    notifyListeners();

    try {
      final newImages = await _repository.getImages(page: _currentPage);
      if (newImages.isEmpty) {
        _hasMoreImages = false;
      } else {
        _images.addAll(newImages);
        _currentPage++;
      }
      _statusMessage = _images.isEmpty ? "No images found" : "";
    } catch (e) {
      Dbg.e('Error loading images: $e');
      _statusMessage = "Error loading images: $e";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Refresh all images
  Future<void> refresh() async {
    _images.clear();
    _thumbnailCache.clear();
    _currentPage = 0;
    _hasMoreImages = true;
    _repository.clearCache();
    await initialize();
  }

  @override
  void dispose() {
    _thumbnailCache.clear();
    super.dispose();
  }
}
