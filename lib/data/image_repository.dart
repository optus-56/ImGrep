import 'package:imgrep/utils/debug_logger.dart';
import 'package:photo_manager/photo_manager.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as p;

//main class
class ImageRepository {
  bool useDeviceImages = true; //<<<<
  // toggle to load in device images

  Future<List<dynamic>> getImages() async {
    return useDeviceImages
        ? await DeviceImages.getImages()
        : AssetImages.getImages(); //images stored in assets/
  }
}

//
// load device from the local storage
//not working
class DeviceImages {
  static Future<List<AssetEntity>> getImages() async {
    Dbg.todo("fix me");
    try {
      // Check and request permission
      final PermissionState permission =
          await PhotoManager.requestPermissionExtend();

      if (permission != PermissionState.authorized) {
        throw Exception('Permission not granted: $permission');
      }

      // Get albums
      final albums = await PhotoManager.getAssetPathList(
        type: RequestType.image,
        hasAll: true,
      );

      if (albums.isEmpty) {
        Dbg.warn('No image albums found');
        return [];
      }

      // Get assets from first album
      final assets = await albums.first.getAssetListRange(start: 0, end: 1000);

      return assets;
    } catch (e, st) {
      Dbg.e('Error loading images: $e', e, st);
      return [];
    }
  }
}

//
//import all images in the assets/images/
class AssetImages {
  static const _dir = 'assets/images/';
  static const _exts = ['.jpg', '.jpeg', '.png', '.webp', '.gif'];

  static Future<List<String>> getImages() async {
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
  }
}
