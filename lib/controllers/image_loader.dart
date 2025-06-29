import 'package:flutter/foundation.dart';
import 'package:imgrep/data/image_repository.dart';
import 'package:imgrep/utils/debug_logger.dart';

/// Handles all image loading logic and state management
class ImageLoader extends ChangeNotifier {
  final ImageRepository _repository;
  final List<dynamic> _images = [];
  final Map<String, Uint8List> _thumbnailCache = {};

  bool _isLoading = false;
  bool _hasMoreImages = true;
  int _currentPage = 0;
  String? _error;

  ImageLoader(this._repository);

  // Getters
  List<dynamic> get images => _images;
  int get imageCount => _images.length;
  bool get isEmpty => _images.isEmpty;
  bool get isLoading => _isLoading;
  bool get hasMoreImages => _hasMoreImages;
  String? get error => _error;
  bool get hasError => _error != null;

  // Thumbnail cache methods
  Uint8List? getCachedThumbnail(String key) => _thumbnailCache[key];
  void cacheThumbnail(String key, Uint8List data) =>
      _thumbnailCache[key] = data;

  /// Initialize image loading
  Future<void> initialize() async {
    if (_isLoading) return;

    _clearError();

    try {
      final hasImages = await _repository.hasImages();
      if (!hasImages) {
        _hasMoreImages = false;
        return;
      }

      await loadMoreImages();
    } catch (e) {
      _setError('Failed to initialize: $e');
      Dbg.e('Error initializing images: $e');
    }
  }

  /// Load more images (pagination)
  Future<void> loadMoreImages() async {
    if (_isLoading || !_hasMoreImages) return;

    _isLoading = true;
    _clearError();

    try {
      final newImages = await _repository.getImages(page: _currentPage);

      if (newImages.isEmpty) {
        _hasMoreImages = false;
      } else {
        _images.addAll(newImages);
        _currentPage++;
      }
    } catch (e) {
      _setError('Failed to load images: $e');
      Dbg.e('Error loading images: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Refresh all images
  Future<void> refresh() async {
    _reset();
    await initialize();
  }

  /// Reset all state
  void _reset() {
    _images.clear();
    _thumbnailCache.clear();
    _currentPage = 0;
    _hasMoreImages = true;
    _isLoading = false;
    _clearError();
    _repository.clearCache();
  }

  void _setError(String error) {
    _error = error;
    notifyListeners();
  }

  void _clearError() => _error = null;

  @override
  void dispose() {
    _thumbnailCache.clear();
    super.dispose();
  }
}
