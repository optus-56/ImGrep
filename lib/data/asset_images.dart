import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:imgrep/utils/debug_logger.dart';
import 'package:imgrep/utils/settings.dart';
import 'package:path/path.dart' as p;

class AssetImagesService {
  static List<String>? _cachedImages;

  /// Get all asset images
  static Future<List<String>> getImages() async {
    try {
      // Return cached images if available
      if (_cachedImages != null) {
        return _cachedImages!;
      }

      // Load and cache images
      _cachedImages = await _loadAssetImages();
      return _cachedImages!;
    } catch (e) {
      Dbg.e('Error loading asset images: $e');
      return [];
    }
  }

  /// Load images from asset manifest
  static Future<List<String>> _loadAssetImages() async {
    try {
      final manifestContent = await rootBundle.loadString('AssetManifest.json');
      final manifest = json.decode(manifestContent) as Map<String, dynamic>;

      return manifest.keys.where(_isValidImageAsset).toList()
        ..sort(); // Sort for consistent ordering
    } catch (e) {
      Dbg.e('Error parsing AssetManifest.json: $e');
      return [];
    }
  }

  /// Check if asset path is a valid image
  static bool _isValidImageAsset(String key) {
    return key.startsWith(HomeScreenSettings.assetImagesDir) &&
        HomeScreenSettings.supportedExtensions.contains(
          p.extension(key).toLowerCase(),
        );
  }

  /// Clear cached images (useful for refresh)
  static void clearCache() {
    _cachedImages = null;
  }

  /// Get asset images with pagination simulation (for consistency with device images)
  static Future<List<String>> getImagesPaginated({
    required int page,
    int? size,
  }) async {
    try {
      final allImages = await getImages();
      final pageSize = size ?? HomeScreenSettings.pageSize;
      final startIndex = page * pageSize;
      final endIndex = (startIndex + pageSize).clamp(0, allImages.length);

      if (startIndex >= allImages.length) {
        return [];
      }

      return allImages.sublist(startIndex, endIndex);
    } catch (e) {
      Dbg.e('Error getting paginated asset images: $e');
      return [];
    }
  }

  /// Get total asset image count
  static Future<int> getTotalImageCount() async {
    try {
      final images = await getImages();
      return images.length;
    } catch (e) {
      Dbg.e('Error getting asset image count: $e');
      return 0;
    }
  }

  /// Check if asset directory exists and has images
  static Future<bool> hasImages() async {
    try {
      final images = await getImages();
      return images.isNotEmpty;
    } catch (e) {
      Dbg.e('Error checking for asset images: $e');
      return false;
    }
  }
}
