import 'package:flutter/services.dart';
import 'package:imgrep/utils/debug_logger.dart';
import 'package:imgrep/utils/settings.dart';
import 'package:photo_manager/photo_manager.dart';
import 'dart:convert';
import 'package:path/path.dart' as p;

enum ImageSourceType { device, asset }

abstract class ImageSource {
  Future<List<dynamic>> getImages({int page = 0, int? size});
  Future<bool> hasImages();
  void clearCache();
}

class DeviceImageSource implements ImageSource {
  AssetPathEntity? _cachedMainAlbum;

  @override
  Future<List<dynamic>> getImages({int page = 0, int? size}) async {
    try {
      final album = await _getMainAlbum();
      if (album == null) return [];
      return await album.getAssetListPaged(
        page: page,
        size: size ?? HomeScreenSettings.pageSize,
      );
    } catch (e) {
      Dbg.e('Error loading device images: $e');
      return [];
    }
  }

  @override
  Future<bool> hasImages() async {
    final permission = await PhotoManager.requestPermissionExtend();
    return permission == PermissionState.authorized ||
        permission == PermissionState.limited;
  }

  @override
  void clearCache() {
    _cachedMainAlbum = null;
  }

  Future<AssetPathEntity?> _getMainAlbum() async {
    if (_cachedMainAlbum != null) return _cachedMainAlbum;
    try {
      final albums = await PhotoManager.getAssetPathList(
        type: RequestType.image,
      );
      if (albums.isEmpty) return null;
      AssetPathEntity? mainAlbum;
      int maxCount = 0;
      for (var album in albums) {
        final count = await album.assetCountAsync;
        if (count > maxCount) {
          maxCount = count;
          mainAlbum = album;
        }
      }
      _cachedMainAlbum = mainAlbum;
      return mainAlbum;
    } catch (e) {
      Dbg.e('Error finding main album: $e');
      return null;
    }
  }
}

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

class ImageRepository {
  final ImageSource _source;

  ImageRepository()
    : _source =
          HomeScreenSettings.useDeviceImages
              ? DeviceImageSource()
              : AssetImageSource();

  Future<List<dynamic>> getImages({int page = 0, int? size}) =>
      _source.getImages(page: page, size: size);

  Future<bool> hasImages() => _source.hasImages();

  void clearCache() => _source.clearCache();
}
