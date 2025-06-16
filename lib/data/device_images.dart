import 'package:imgrep/utils/debug_logger.dart';
import 'package:imgrep/utils/settings.dart';
import 'package:photo_manager/photo_manager.dart';

class DeviceImagesService {
  static AssetPathEntity? _cachedMainAlbum;

  /// Get all images from device (legacy method)
  static Future<List<AssetEntity>> getImages() async {
    try {
      final album = await getMainAlbum();
      if (album == null) return [];

      return await album.getAssetListPaged(page: 0, size: 100);
    } catch (e) {
      Dbg.e('Error loading device images: $e');
      return [];
    }
  }

  /// Get images with pagination
  static Future<List<AssetEntity>> getImagesPaginated({
    required AssetPathEntity album,
    required int page,
    int? size,
  }) async {
    try {
      return await album.getAssetListPaged(
        page: page,
        size: size ?? HomeScreenSettings.pageSize,
      );
    } catch (e) {
      Dbg.e('Error loading page $page: $e');
      return [];
    }
  }

  /// Get the main album (with permission handling)
  static Future<AssetPathEntity?> getMainAlbum() async {
    try {
      // Check permissions first
      if (!await _requestPermissions()) return null;

      // Return cached album if available
      if (_cachedMainAlbum != null) return _cachedMainAlbum;

      // Find and cache the main album
      _cachedMainAlbum = await _findMainAlbum();
      return _cachedMainAlbum;
    } catch (e) {
      Dbg.e('Error getting main album: $e');
      return null;
    }
  }

  /// Clear cached album (useful for refresh)
  static void clearCache() {
    _cachedMainAlbum = null;
  }

  /// Request necessary permissions
  static Future<bool> _requestPermissions() async {
    final permission = await PhotoManager.requestPermissionExtend();
    return permission == PermissionState.authorized ||
        permission == PermissionState.limited;
  }

  /// Find the album with the most photos
  static Future<AssetPathEntity?> _findMainAlbum() async {
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

      return mainAlbum;
    } catch (e) {
      Dbg.e('Error finding main album: $e');
      return null;
    }
  }

  /// Check if permissions are granted
  static Future<bool> hasPermissions() async {
    final permission = await PhotoManager.requestPermissionExtend();
    return permission == PermissionState.authorized ||
        permission == PermissionState.limited;
  }
}
