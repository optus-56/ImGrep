import 'package:flutter/material.dart';
import 'package:imgrep/controllers/image_loader.dart';
import 'package:imgrep/utils/settings.dart';
import 'package:photo_manager/photo_manager.dart';
import 'dart:typed_data';

/// Main image grid widget that delegates to specific implementations
class ImageGrid extends StatelessWidget {
  final ImageLoader imageLoader;

  const ImageGrid({super.key, required this.imageLoader});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: imageLoader,
      builder: (context, child) {
        if (imageLoader.isEmpty) {
          return EmptyStateWidget(
            message: imageLoader.statusMessage,
            onRetry: imageLoader.refresh,
          );
        }

        return HomeScreenSettings.useDeviceImages
            ? DeviceImageGrid(imageLoader: imageLoader)
            : AssetImageGrid(imageLoader: imageLoader);
      },
    );
  }
}

/// Grid for device images with pagination
class DeviceImageGrid extends StatelessWidget {
  final ImageLoader imageLoader;

  const DeviceImageGrid({super.key, required this.imageLoader});

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (scrollInfo) {
        // Smooth pagination trigger
        if (!imageLoader.isLoading &&
            imageLoader.hasMoreImages &&
            scrollInfo.metrics.pixels >=
                scrollInfo.metrics.maxScrollExtent -
                    HomeScreenSettings.paginationTriggerOffset) {
          imageLoader.loadMoreImages();
        }
        return true;
      },
      child: GridView.builder(
        padding: const EdgeInsets.all(HomeScreenSettings.gridSpacing),
        itemCount:
            imageLoader.imageCount +
            (imageLoader.hasMoreImages && imageLoader.isLoading ? 1 : 0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: HomeScreenSettings.gridCrossAxisCount,
          mainAxisSpacing: HomeScreenSettings.gridSpacing,
          crossAxisSpacing: HomeScreenSettings.gridSpacing,
        ),
        itemBuilder: (context, index) {
          if (index >= imageLoader.imageCount) {
            return const LoadingTile();
          }

          return DeviceImageTile(
            asset: imageLoader.images[index] as AssetEntity,
            imageLoader: imageLoader,
          );
        },
      ),
    );
  }
}

/// Grid for asset images (no pagination needed)
class AssetImageGrid extends StatelessWidget {
  final ImageLoader imageLoader;

  const AssetImageGrid({super.key, required this.imageLoader});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(HomeScreenSettings.gridSpacing),
      itemCount: imageLoader.imageCount,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: HomeScreenSettings.gridCrossAxisCount,
        mainAxisSpacing: HomeScreenSettings.gridSpacing,
        crossAxisSpacing: HomeScreenSettings.gridSpacing,
      ),
      itemBuilder: (context, index) {
        return AssetImageTile(assetPath: imageLoader.images[index] as String);
      },
    );
  }
}

/// Device image tile with caching
class DeviceImageTile extends StatelessWidget {
  final AssetEntity asset;
  final ImageLoader imageLoader;

  const DeviceImageTile({
    super.key,
    required this.asset,
    required this.imageLoader,
  });

  @override
  Widget build(BuildContext context) {
    final cacheKey = asset.id;
    final cachedImage = imageLoader.getCachedThumbnail(cacheKey);

    if (cachedImage != null) {
      return ImageContainer(
        child: Image.memory(
          cachedImage,
          fit: BoxFit.cover,
          gaplessPlayback: true,
          cacheHeight: 300, 
              cacheWidth: 300,
              frameBuilder: (context, child, frame, wasSync) {
                if (frame == null) {
                  return Container(
                    color: Colors.grey[400],
                    child: const Center(
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  );
                }
                return child;
              },
        ),
      );
    }

    return FutureBuilder<Uint8List?>(
      future: asset.thumbnailDataWithSize(
        const ThumbnailSize(
          HomeScreenSettings.thumbnailSize,
          HomeScreenSettings.thumbnailSize,
        ),
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData &&
            snapshot.data != null) {
          imageLoader.cacheThumbnail(cacheKey, snapshot.data!);

          return ImageContainer(
            child: Image.memory(
              snapshot.data!,
              fit: BoxFit.cover,
              gaplessPlayback: true,
              cacheHeight: 300, 
              cacheWidth: 300,
              frameBuilder: (context, child, frame, wasSync) {
                if (frame == null) {
                  return Container(
                    color: Colors.grey[400],
                    child: const Center(
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  );
                }
                return child;
              },
            ),
          );
        } else if (snapshot.hasError) {
          return const ErrorTile();
        } else {
          return const LoadingTile();
        }
      },
    );
  }
}

/// Asset image tile
class AssetImageTile extends StatelessWidget {
  final String assetPath;

  const AssetImageTile({super.key, required this.assetPath});

  @override
  Widget build(BuildContext context) {
    return ImageContainer(
      child: Image.asset(
        assetPath,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => const ErrorTile(),
        cacheHeight: 300, 
              cacheWidth: 300,
              frameBuilder: (context, child, frame, wasSync) {
                if (frame == null) {
                  return Container(
                    color: Colors.grey[400],
                    child: const Center(
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  );
                }
                return child;
              },
      ),
    );
  }
}

/// Reusable container for images
class ImageContainer extends StatelessWidget {
  final Widget child;

  const ImageContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(borderRadius: BorderRadius.circular(8), child: child);
  }
}

/// Loading indicator tile
/// @bijan TODO : here is the loding spinner
class LoadingTile extends StatelessWidget {
  const LoadingTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Center(
        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
      ),
    );
  }
}

/// Error indicator tile
class ErrorTile extends StatelessWidget {
  const ErrorTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Icon(Icons.error_outline, color: Colors.grey, size: 32),
    );
  }
}

/// Empty state widget
class EmptyStateWidget extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const EmptyStateWidget({
    super.key,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            message.contains("Permission") || message.contains("Error")
                ? Icons.error_outline
                : Icons.photo_library_outlined,
            size: 64,
            color: Colors.grey,
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: const TextStyle(color: Colors.white, fontSize: 18),
            textAlign: TextAlign.center,
          ),
          if (message.contains("Permission") || message.contains("Error"))
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: ElevatedButton(
                onPressed: onRetry,
                child: const Text("Retry"),
              ),
            ),
        ],
      ),
    );
  }
}
