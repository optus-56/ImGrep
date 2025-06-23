import 'package:flutter/material.dart';
import 'package:imgrep/controllers/image_loader.dart';
import 'package:imgrep/utils/settings.dart';
import 'package:photo_manager/photo_manager.dart';
import 'dart:typed_data';

/// Main image grid widget that delegates to specific implementations
class ImageGrid extends StatefulWidget {
  final ImageLoader imageLoader;
  const ImageGrid({super.key, required this.imageLoader});
  @override
  State<ImageGrid> createState() => _ImageGridState();
}

class _ImageGridState extends State<ImageGrid> {
  bool _isLoadingMore = false;
  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.imageLoader,
      builder:
          (context, _) =>
              widget.imageLoader.isEmpty
                  ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          widget.imageLoader.statusMessage.contains(
                                    "Permission",
                                  ) ||
                                  widget.imageLoader.statusMessage.contains(
                                    "Error",
                                  )
                              ? Icons.error_outline
                              : Icons.photo_library_outlined,
                          size: 64,
                          color: Colors.grey,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          widget.imageLoader.statusMessage,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        if (widget.imageLoader.statusMessage.contains(
                              "Permission",
                            ) ||
                            widget.imageLoader.statusMessage.contains("Error"))
                          Padding(
                            padding: const EdgeInsets.only(top: 16),
                            child: ElevatedButton(
                              onPressed: widget.imageLoader.refresh,
                              child: const Text("Retry"),
                            ),
                          ),
                      ],
                    ),
                  )
                  : NotificationListener<ScrollNotification>(
                    onNotification: (scrollInfo) {
                      if (!_isLoadingMore &&
                          !widget.imageLoader.isLoading &&
                          widget.imageLoader.hasMoreImages &&
                          scrollInfo.metrics.pixels >=
                              scrollInfo.metrics.maxScrollExtent -
                                  HomeScreenSettings.paginationTriggerOffset) {
                        setState(() => _isLoadingMore = true);
                        widget.imageLoader.loadMoreImages().then((_) {
                          if (mounted) setState(() => _isLoadingMore = false);
                        });
                      }
                      return false;
                    },
                    child: GridView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(
                        HomeScreenSettings.gridSpacing,
                      ),
                      itemCount:
                          widget.imageLoader.imageCount +
                          (widget.imageLoader.hasMoreImages &&
                                  widget.imageLoader.isLoading
                              ? 1
                              : 0),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount:
                                HomeScreenSettings.gridCrossAxisCount,
                            mainAxisSpacing: HomeScreenSettings.gridSpacing,
                            crossAxisSpacing: HomeScreenSettings.gridSpacing,
                          ),
                      itemBuilder:
                          (context, index) =>
                              index >= widget.imageLoader.imageCount
                                  ? const LoadingTile()
                                  : ImageTile(
                                    image: widget.imageLoader.images[index],
                                    imageLoader: widget.imageLoader,
                                  ),
                    ),
                  ),
    );
  }
}

class ImageTile extends StatelessWidget {
  final dynamic image;
  final ImageLoader imageLoader;

  const ImageTile({super.key, required this.image, required this.imageLoader});

  @override
  Widget build(BuildContext context) {
    if (image is! AssetEntity && image is! String) return const ErrorTile();

    final isDeviceImage = image is AssetEntity;
    final cacheKey = isDeviceImage ? (image as AssetEntity).id : null;
    final cachedImage =
        isDeviceImage ? imageLoader.getCachedThumbnail(cacheKey!) : null;

    return ImageContainer(
      child:
          cachedImage != null
              ? Image.memory(
                cachedImage,
                fit: BoxFit.fill,
                gaplessPlayback: true,
                cacheHeight: HomeScreenSettings.thumbnailHeightSize,
                cacheWidth: HomeScreenSettings.thumbnailWidthSize,
              )
              : isDeviceImage
              ? FutureBuilder<Uint8List?>(
                future: (image as AssetEntity).thumbnailDataWithSize(
                  ThumbnailSize(
                    HomeScreenSettings.thumbnailHeightSize,
                    HomeScreenSettings.thumbnailWidthSize,
                  ),
                ),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done &&
                      snapshot.hasData &&
                      snapshot.data != null) {
                    imageLoader.cacheThumbnail(cacheKey!, snapshot.data!);
                    return Image.memory(
                      snapshot.data!,
                      fit: BoxFit.fill,
                      gaplessPlayback: true,
                      cacheHeight: HomeScreenSettings.thumbnailHeightSize,
                      cacheWidth: HomeScreenSettings.thumbnailWidthSize,
                    );
                  }
                  return snapshot.hasError
                      ? const ErrorTile()
                      : const LoadingTile();
                },
              )
              : Image.asset(
                image as String,
                fit: BoxFit.fill,
                cacheHeight: HomeScreenSettings.thumbnailHeightSize,
                cacheWidth: HomeScreenSettings.thumbnailWidthSize,
                errorBuilder: (context, error, stackTrace) => const ErrorTile(),
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
          Positioned.fill(child: Container(color: Colors.grey[400])),
          child,
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
