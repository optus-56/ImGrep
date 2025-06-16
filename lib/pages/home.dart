import 'package:flutter/material.dart';
import 'package:imgrep/data/image_repository.dart';
import 'package:imgrep/utils/debug_logger.dart';
import 'package:photo_manager/photo_manager.dart';
import 'dart:typed_data';

void main() =>
    runApp(const MaterialApp(home: Home(), debugShowCheckedModeBanner: false));

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final List<AssetEntity> _images = [];
  final Map<String, Uint8List> _thumbnailCache = {}; // Cache for thumbnails
  final Map<String, Future<Uint8List?>> _loadingFutures =
      {}; // Cache for futures; avoids jitters
  int _currentPage = 0;
  bool _isLoading = false;
  bool _hasMoreImages = true;
  AssetPathEntity? _album;
  String _statusMessage = "Loading...";

  @override
  void initState() {
    super.initState();
    _initializeImages();
  }

  /// Initialize the image loading process
  Future<void> _initializeImages() async {
    try {
      setState(() {
        _statusMessage = "Requesting permissions...";
      });

      // Get the main album using the repository
      _album = await DeviceImages.getMainAlbum();

      if (_album == null) {
        setState(() {
          _statusMessage = "No accessible photo albums found";
        });
        return;
      }

      // Load first batch of images
      await _loadMoreImages();
    } catch (e) {
      Dbg.e('Error initializing images: $e');
      setState(() {
        _statusMessage = "Error loading photos: $e";
      });
    }
  }

  /// Load more images for pagination
  Future<void> _loadMoreImages() async {
    if (_isLoading || !_hasMoreImages || _album == null) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final newImages = await DeviceImages.getImagesPaginated(
        album: _album!,
        page: _currentPage,
        size: 20,
      );

      setState(() {
        if (newImages.isEmpty) {
          _hasMoreImages = false;
        } else {
          _images.addAll(newImages);
          _currentPage++;
        }

        _isLoading = false;
        _statusMessage = _images.isEmpty ? "No images found" : "";
      });
    } catch (e) {
      Dbg.e('Error loading more images: $e');
      setState(() {
        _isLoading = false;
        _statusMessage = "Error loading images: $e";
      });
    }
  }

  /// Refresh the entire image list
  Future<void> _refreshImages() async {
    // Clear caches when refreshing
    _thumbnailCache.clear();
    _loadingFutures.clear();

    setState(() {
      _images.clear();
      _currentPage = 0;
      _hasMoreImages = true;
      _album = null;
      _statusMessage = "Refreshing...";
    });

    await _initializeImages();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'ImGrep (${_images.length})',
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            onPressed: _refreshImages,
            icon: const Icon(Icons.refresh, color: Colors.white),
            tooltip: 'Refresh',
          ),
          IconButton(
            onPressed: () {
              // TODO: Implement sorting
            },
            icon: const Icon(Icons.sort, color: Colors.white),
            tooltip: 'Sort',
          ),
        ],
      ),
      backgroundColor: Colors.black,
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_images.isEmpty) {
      return _buildEmptyState();
    }

    return NotificationListener<ScrollNotification>(
      onNotification: (scrollInfo) {
        // Load more images when near the bottom
        if (!_isLoading &&
            _hasMoreImages &&
            scrollInfo.metrics.pixels >=
                scrollInfo.metrics.maxScrollExtent - 200) {
          _loadMoreImages();
        }
        return true;
      },
      child: GridView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: _images.length + (_hasMoreImages && _isLoading ? 1 : 0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
        ),
        itemBuilder: (context, index) {
          // Show loading indicator at the end
          if (index >= _images.length) {
            return const Center(
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            );
          }

          return _buildImageTile(_images[index]);
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            _statusMessage.contains("Permission") ||
                    _statusMessage.contains("Error")
                ? Icons.error_outline
                : Icons.photo_library_outlined,
            size: 64,
            color: Colors.grey,
          ),
          const SizedBox(height: 16),
          Text(
            _statusMessage,
            style: const TextStyle(color: Colors.white, fontSize: 18),
            textAlign: TextAlign.center,
          ),
          if (_statusMessage.contains("Permission") ||
              _statusMessage.contains("Error"))
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: ElevatedButton(
                onPressed: _refreshImages,
                child: const Text("Retry"),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildImageTile(AssetEntity asset) {
    final cacheKey = asset.id;

    // Return cached image immediately if available
    if (_thumbnailCache.containsKey(cacheKey)) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.memory(
          _thumbnailCache[cacheKey]!,
          fit: BoxFit.cover,
          gaplessPlayback: true, // Prevents flashing during rebuilds
        ),
      );
    }

    // If not cached, create or reuse the loading future
    if (!_loadingFutures.containsKey(cacheKey)) {
      _loadingFutures[cacheKey] = asset.thumbnailDataWithSize(
        const ThumbnailSize(200, 200),
      );
    }

    return FutureBuilder<Uint8List?>(
      future: _loadingFutures[cacheKey],
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData &&
            snapshot.data != null) {
          // Cache the loaded thumbnail
          _thumbnailCache[cacheKey] = snapshot.data!;

          return ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.memory(
              snapshot.data!,
              fit: BoxFit.cover,
              gaplessPlayback: true,
            ),
          );
        } else if (snapshot.hasError) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.error_outline,
              color: Colors.grey,
              size: 32,
            ),
          );
        } else {
          return Container(
            decoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Center(
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            ),
          );
        }
      },
    );
  }
}
