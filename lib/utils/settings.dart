class HomeScreenSettings {
  //TOGGLE - CHANGE THIS TO SWITCH IMAGE SOURCES
  static const bool useDeviceImages =
      true; // true = device storage, false = assets

  // Pagination settings
  static const int pageSize = 30;
  static const double paginationTriggerOffset =
      800.0; // Start loading when 800px from bottom

  // Grid settings
  static const int gridCrossAxisCount = 3;
  static const double gridSpacing = 8.0;

  // Thumbnail settings
  static const int thumbnailHeightSize = 200;
  static const int thumbnailWidthSize = 200;

  // Asset settings
  static const String assetImagesDir = 'assets/images/';
  static const List<String> supportedExtensions = [
    '.jpg',
    '.jpeg',
    '.png',
    '.webp',
    '.gif',
    '.mp4',
  ];
}
