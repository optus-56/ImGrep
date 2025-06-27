import 'package:imgrep/data/image_repository.dart';
import 'package:imgrep/utils/debug_logger.dart';
import 'package:imgrep/utils/settings.dart';
import 'package:photo_manager/photo_manager.dart';

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
