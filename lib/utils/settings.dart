import 'dart:io';

class HomeScreenSettings {
  static final bool useDeviceImages = Platform.isAndroid;
  static const int pageSize = 30;
  static const String assetImagesDir = 'assets/images/';
  static const List<String> supportedExtensions = [
    '.jpg',
    '.jpeg',
    '.png',
    '.webp',
    '.gif',
  ];
}
