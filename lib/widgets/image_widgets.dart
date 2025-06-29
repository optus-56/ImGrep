import 'package:flutter/material.dart';
import 'package:imgrep/controllers/image_loader.dart';
import 'package:imgrep/utils/settings.dart';
import 'package:photo_manager/photo_manager.dart';
import 'dart:typed_data';

/// Main image grid widget that delegates to specific implementations
class ImageGrid extends StatelessWidget {
  final ImageLoader imageLoader;
  final ScrollController _scrollController = ScrollController();

  ImageGrid({super.key, required this.imageLoader}) {
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        imageLoader.hasMoreImages &&
        !imageLoader.isLoading) {
      imageLoader.loadMoreImages();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      controller: _scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(4),
      itemCount: imageLoader.imageCount + (imageLoader.isLoading ? 1 : 0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: HomeScreenSettings.gridCrossAxisCount,
        mainAxisSpacing: 2,
        crossAxisSpacing: 2,
      ),
      itemBuilder: (context, index) {
        if (index >= imageLoader.imageCount) {
          return const LoadingTile();
        }
        return ImageTile(
          image: imageLoader.images[index],
          imageLoader: imageLoader,
        );
      },
    );
  }
}

class ImageTile extends StatelessWidget {
  final dynamic image;
  final ImageLoader imageLoader;

  const ImageTile({super.key, required this.image, required this.imageLoader});

  @override
  Widget build(BuildContext context) {
    if (image is AssetEntity) {
      return _DeviceImageTile(asset: image, imageLoader: imageLoader);
    }
    if (image is String) {
      return _AssetImageTile(path: image);
    }
    return const ErrorTile();
  }
}

class _DeviceImageTile extends StatelessWidget {
  final AssetEntity asset;
  final ImageLoader imageLoader;

  const _DeviceImageTile({required this.asset, required this.imageLoader});

  @override
  Widget build(BuildContext context) {
    final cached = imageLoader.getCachedThumbnail(asset.id);
    if (cached != null) {
      return ImageContainer(child: Image.memory(cached, fit: BoxFit.cover));
    }

    return FutureBuilder<Uint8List?>(
      future: asset.thumbnailDataWithSize(const ThumbnailSize(200, 200)),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data != null) {
          imageLoader.cacheThumbnail(asset.id, snapshot.data!);
          return ImageContainer(
            child: Image.memory(snapshot.data!, fit: BoxFit.cover),
          );
        }
        return snapshot.hasError ? const ErrorTile() : const LoadingTile();
      },
    );
  }
}

class _AssetImageTile extends StatelessWidget {
  final String path;

  const _AssetImageTile({required this.path});

  @override
  Widget build(BuildContext context) {
    return ImageContainer(
      child: Image.asset(
        path,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => const ErrorTile(),
      ),
    );
  }
}

class ImageContainer extends StatelessWidget {
  final Widget child;

  const ImageContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Stack(
        children: [
          Positioned.fill(
            child: Container(color: const Color.fromARGB(100, 58, 56, 56)),
          ),
          Center(child: child),
        ],
      ),
    );
  }
}

class LoadingTile extends StatelessWidget {
  const LoadingTile({super.key});

  @override
  Widget build(BuildContext context) {
    return const ImageContainer(
      child: Center(
        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
      ),
    );
  }
}

class ErrorTile extends StatelessWidget {
  const ErrorTile({super.key});

  @override
  Widget build(BuildContext context) {
    return const ImageContainer(
      child: Icon(Icons.error_outline, color: Colors.grey, size: 32),
    );
  }
}
