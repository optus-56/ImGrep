import 'package:imgrep/data/asset_images.dart';
import 'package:imgrep/data/device_images.dart';
import 'package:imgrep/utils/settings.dart';
import 'package:photo_manager/photo_manager.dart';

/// Main repository class that abstracts image source selection
class ImageRepository {
  bool useDeviceImages = HomeScreenSettings.useDeviceImages;

  /// Get images from the current source
  Future<List<dynamic>> getImages() async {
    return useDeviceImages
        ? await DeviceImagesService.getImages()
        : await AssetImagesService.getImages();
  }

  /// Get images with pagination
  Future<List<dynamic>> getImagesPaginated({
    required int page,
    int? size,
    AssetPathEntity? album,
  }) async {
    if (useDeviceImages) {
      if (album == null) {
        album = await DeviceImagesService.getMainAlbum();
        if (album == null) return [];
      }
      return await DeviceImagesService.getImagesPaginated(
        album: album,
        page: page,
        size: size,
      );
    } else {
      return await AssetImagesService.getImagesPaginated(
        page: page,
        size: size,
      );
    }
  }

  /// Get main album (device images only)
  Future<AssetPathEntity?> getMainAlbum() async {
    return useDeviceImages ? await DeviceImagesService.getMainAlbum() : null;
  }

  /// Check if images are available
  Future<bool> hasImages() async {
    if (useDeviceImages) {
      return await DeviceImagesService.hasPermissions();
    } else {
      return await AssetImagesService.hasImages();
    }
  }

  /// Clear all caches
  void clearCache() {
    DeviceImagesService.clearCache();
    AssetImagesService.clearCache();
  }
}
