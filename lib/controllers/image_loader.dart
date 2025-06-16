import 'package:flutter/foundation.dart';
import 'package:imgrep/data/image_repository.dart';
import 'package:imgrep/utils/debug_logger.dart';
import 'package:imgrep/utils/settings.dart';
import 'package:photo_manager/photo_manager.dart';

/// Handles all image loading logic and state management
class ImageLoader extends ChangeNotifier {
  final ImageRepository _repository = ImageRepository();
  final List<dynamic> _images = [];
  final Map<String, Uint8List> _thumbnailCache = {};

  // Device-specific pagination state
  int _currentPage = 0;
  bool _isLoading = false;
  bool _hasMoreImages = true;
  AssetPathEntity? _album;

  String _statusMessage = "Loading...";

  // Getters
  List<dynamic> get images => _images;
  int get imageCount => _images.length;
  String get statusMessage => _statusMessage;
  bool get isEmpty => _images.isEmpty;
  bool get isLoading => _isLoading;
  bool get hasMoreImages => _hasMoreImages;

  // Thumbnail cache methods   //TODO : this might need some optimizations like lowering the resolution for thumnails
  Uint8List? getCachedThumbnail(String key) => _thumbnailCache[key];
  void cacheThumbnail(String key, Uint8List data) =>
      _thumbnailCache[key] = data;

  /// Initialize image loading
  Future<void> initialize() async {
    try {
      _updateStatusMessage("initializing");

      if (HomeScreenSettings.useDeviceImages) {
        await _initializeDeviceImages();
      } else {
        await _initializeAssetImages();
      }
    } catch (e) {
      Dbg.e('Error initializing images: $e');
      _statusMessage = "Error loading photos: $e";
      notifyListeners();
    }
  }

  /// Initialize device images
  Future<void> _initializeDeviceImages() async {
    _album = await _repository.getMainAlbum();

    if (_album == null) {
      _statusMessage = "No accessible photo albums found";
      notifyListeners();
      return;
    }

    await loadMoreImages();
  }

  /// Initialize asset images
  Future<void> _initializeAssetImages() async {
    final assetImages = await _repository.getImages();

    _images.clear();
    _images.addAll(assetImages);
    _statusMessage = _images.isEmpty ? "No asset images found" : "";
    notifyListeners();
  }

  /// Load more images (pagination for device images)
  Future<void> loadMoreImages() async {
    if (_isLoading || !_hasMoreImages) return;

    // Asset images don't need pagination
    if (!HomeScreenSettings.useDeviceImages) return;

    _isLoading = true;
    notifyListeners();

    try {
      final newImages = await _repository.getImagesPaginated(
        page: _currentPage,
        album: _album,
      );

      if (newImages.isEmpty) {
        _hasMoreImages = false;
      } else {
        _images.addAll(newImages);
        _currentPage++;
      }

      _isLoading = false;
      _statusMessage = _images.isEmpty ? "No images found" : "";
      notifyListeners();
    } catch (e) {
      Dbg.e('Error loading more images: $e');
      _isLoading = false;
      _statusMessage = "Error loading images: $e";
      notifyListeners();
    }
  }

  /// Refresh all images
  Future<void> refresh() async {
    _clearState();
    _repository.clearCache();
    await initialize();
  }

  /// Clear all state
  void _clearState() {
    _thumbnailCache.clear();
    _images.clear();
    _currentPage = 0;
    _hasMoreImages = true;
    _album = null;
    _statusMessage = "Refreshing...";
    notifyListeners();
  }

  /// Update status message based on current state
  void _updateStatusMessage(String operation) {
    if (HomeScreenSettings.useDeviceImages) {
      switch (operation) {
        case "initializing":
          _statusMessage = "Requesting permissions...";
          break;
        case "loading":
          _statusMessage = "Loading device images...";
          break;
      }
    } else {
      switch (operation) {
        case "initializing":
          _statusMessage = "Loading asset images...";
          break;
        case "loading":
          _statusMessage = "Loading assets...";
          break;
      }
    }
    notifyListeners();
  }

  @override
  void dispose() {
    _thumbnailCache.clear();
    super.dispose();
  }
}
