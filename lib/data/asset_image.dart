import 'package:flutter/services.dart';
import 'package:imgrep/data/image_repository.dart';
import 'package:imgrep/utils/debug_logger.dart';
import 'package:imgrep/utils/settings.dart';
import 'dart:convert';
import 'package:path/path.dart' as p;

class AssetImageSource implements ImageSource {
  List<String>? _cachedImages;

  @override
  Future<List<dynamic>> getImages({int page = 0, int? size}) async {
    try {
      final allImages = await _loadAssetImages();
      final pageSize = size ?? HomeScreenSettings.pageSize;
      final startIndex = page * pageSize;
      final endIndex = (startIndex + pageSize).clamp(0, allImages.length);
      if (startIndex >= allImages.length) return [];
      return allImages.sublist(startIndex, endIndex);
    } catch (e) {
      Dbg.e('Error loading asset images: $e');
      return [];
    }
  }

  @override
  Future<bool> hasImages() async {
    try {
      final images = await _loadAssetImages();
      return images.isNotEmpty;
    } catch (e) {
      Dbg.e('Error checking asset images: $e');
      return false;
    }
  }

  @override
  void clearCache() {
    _cachedImages = null;
  }

  Future<List<String>> _loadAssetImages() async {
    if (_cachedImages != null) return _cachedImages!;
    try {
      final manifestContent = await rootBundle.loadString('AssetManifest.json');
      final manifest = json.decode(manifestContent) as Map<String, dynamic>;
      _cachedImages =
          manifest.keys
              .where(
                (key) =>
                    key.startsWith(HomeScreenSettings.assetImagesDir) &&
                    HomeScreenSettings.supportedExtensions.contains(
                      p.extension(key).toLowerCase(),
                    ),
              )
              .toList()
            ..sort();
      return _cachedImages!;
    } catch (e) {
      Dbg.e('Error parsing AssetManifest.json: $e');
      return [];
    }
  }
}
