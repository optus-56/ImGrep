import 'package:imgrep/data/asset_image.dart';
import 'package:imgrep/data/device_image.dart';
import 'package:imgrep/utils/settings.dart';

enum ImageSourceType { device, asset }

abstract class ImageSource {
  Future<List<dynamic>> getImages({int page = 0, int? size});
  Future<bool> hasImages();
  void clearCache();
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

  ImageSourceType get sourceType =>
      HomeScreenSettings.useDeviceImages
          ? ImageSourceType.device
          : ImageSourceType.asset;
}
