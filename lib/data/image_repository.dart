import 'package:imgrep/utils/debug_logger.dart';
import 'package:photo_manager/photo_manager.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as p;

// Main class to fetch images from device or assets
class ImageRepository {
  bool useDeviceImages = true;

  Future<List<dynamic>> getImages() async {
    return useDeviceImages
        ? await DeviceImages.getImages()
        : await AssetImages.getImages();
  }
}

// Handles loading images from device storage
class DeviceImages {
  static Future<List<AssetEntity>> getImages() async {
    try {
      // Request permission
      final permission = await PhotoManager.requestPermissionExtend();
      if (permission != PermissionState.authorized &&
          permission != PermissionState.limited) {
        Dbg.e('Permission not granted: $permission');
        return [];
      }

      // Get all images from all albums
      final images = await _getAllImages();
      return images;
    } catch (e) {
      Dbg.e('Error loading device images: $e');
      return [];
    }
  }

  static Future<List<AssetEntity>> _getAllImages() async {
    final albums = await PhotoManager.getAssetPathList(type: RequestType.image);
    if (albums.isEmpty) {
      Dbg.w('No albums found');
      return [];
    }

    final List<AssetEntity> allImages = [];
    for (var album in albums) {
      try {
        // Load all images from each album
        final images = await album.getAssetListPaged(page: 0, size: 1000);
        allImages.addAll(images);
      } catch (e) {
        Dbg.w('Error loading images from album ${album.name}: $e');
      }
    }
    return allImages;
  }

  // Paginated image loading for UI
  static Future<List<AssetEntity>> getImagesPaginated({
    required AssetPathEntity album,
    required int page,
    int size = 20,
  }) async {
    try {
      return await album.getAssetListPaged(page: page, size: size);
    } catch (e) {
      Dbg.e('Error loading page $page: $e');
      return [];
    }
  }

  // Get main album for pagination (optional, kept for compatibility)
  static Future<AssetPathEntity?> getMainAlbum() async {
    try {
      final permission = await PhotoManager.requestPermissionExtend();
      if (permission != PermissionState.authorized &&
          permission != PermissionState.limited) {
        Dbg.e('Permission not granted: $permission');
        return null;
      }
      final albums = await PhotoManager.getAssetPathList(
        type: RequestType.image,
      );
      return albums.isNotEmpty ? albums[0] : null; // Return first album or null
    } catch (e) {
      Dbg.e('Error getting main album: $e');
      return null;
    }
  }
}

// Handles loading images from assets
class AssetImages {
  static const _dir = 'assets/images/';
  static const _exts = ['.jpg', '.jpeg', '.png', '.webp', '.gif'];

  static Future<List<String>> getImages() async {
    try {
      final manifest =
          json.decode(await rootBundle.loadString('AssetManifest.json'))
              as Map<String, dynamic>;
      return manifest.keys
          .where(
            (key) =>
                key.startsWith(_dir) &&
                _exts.contains(p.extension(key).toLowerCase()),
          )
          .toList();
    } catch (e) {
      Dbg.e('Error loading asset images: $e');
      return [];
    }
  }
}
