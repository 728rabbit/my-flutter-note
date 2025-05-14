/*
Slider gallery

ImageSlider( 
    imageUrls: [
      'https://picsum.photos/id/1015/400/200',
      'https://picsum.photos/id/1025/400/200',
      'https://picsum.photos/id/1035/400/200',
    ]
)
*/
import 'dart:async';

import 'package:devapp/core/config.dart';
import 'package:flutter/material.dart';

class ImageSlider extends StatefulWidget {
  final List<String> imageUrls;
  final bool autoPlay;
  final Duration interval;
  final bool arrowController;
  final bool indicatorIndex;
  final double fixedHeight;

  const ImageSlider({
    super.key,
    required this.imageUrls,
    this.autoPlay = true,
    this.interval = const Duration(seconds: 3),
    this.arrowController = true,
    this.indicatorIndex = true,
    this.fixedHeight = 0
  });

  @override
  State<ImageSlider> createState() => _ImageSliderState();
}

class _ImageSliderState extends State<ImageSlider> {
  final PageController _controller = PageController();
  int _currentPage = 0;
  Timer? _timer;
  double _currentHeight = 0; // default initial height
  final Map<int, double> _imageHeights = {}; // store image heights per index

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadInitialImageSize();
      if (widget.autoPlay == true) {
        _startAutoPlay();
      }
    });
  }

  Future<void> _loadInitialImageSize() async {
    if (widget.imageUrls.isNotEmpty) {
      _updateImageHeight(_currentPage, widget.imageUrls[_currentPage]);
    }
  }

  void _startAutoPlay() {
    _timer = Timer.periodic(widget.interval, (_) {
      if (!_controller.hasClients) return;
      int nextPage = (_currentPage + 1) % widget.imageUrls.length;
      _controller.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut
      );
    });
  }

  void _onArrowPressed(int direction) {
    int nextPage = _currentPage + direction;
    if (nextPage >= 0 && nextPage < widget.imageUrls.length && _controller.hasClients) {
      _controller.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut
      );
    }
  }

  Future<void> _updateImageHeight(int index, String url) async {
    // Ensure the widget is still mounted before proceeding.
    if (!mounted) return;

    final completer = Completer<Size>();
    final image = Image.network(url);
    image.image.resolve(const ImageConfiguration()).addListener(
      ImageStreamListener((ImageInfo info, bool _) {
        final size = Size(
          info.image.width.toDouble(),
          info.image.height.toDouble()
        );
        completer.complete(size);
      }),
    );

    final size = await completer.future;
    final aspectRatio = size.width / size.height;

    // Use context safely inside mounted check
    if (mounted) {
      final width = MediaQuery.of(context).size.width;
      final newHeight = width / aspectRatio;

      setState(() {
        _imageHeights[index] = newHeight;
        if (_currentPage == index) {
          _currentHeight = newHeight;
        }
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _timer?.cancel();
    super.dispose();
  }

  Widget _buildImage(String url, int index) {
    return Image.network(
      url,
      fit: BoxFit.cover,
      width: double.infinity,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) {
          if (!_imageHeights.containsKey(index)) {
            _updateImageHeight(index, url);
          }
          return child;
        } else {
          return Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppConfig.hexCode('primary')),
              strokeWidth: 4
            )
          );
        }
      },
      errorBuilder: (context, error, stackTrace) {
        return const Center(child: Icon(Icons.error));
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      width: double.infinity,
      height: ((widget.fixedHeight > 0)? widget.fixedHeight: _currentHeight),
      color: Colors.white,
      child: Stack(
        alignment: Alignment.center,
        children: [
          PageView.builder(
            controller: _controller,
            itemCount: widget.imageUrls.length,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
                if (_imageHeights.containsKey(index)) {
                  _currentHeight = _imageHeights[index]!;
                } else {
                  _updateImageHeight(index, widget.imageUrls[index]);
                }
              });
            },
            itemBuilder: (context, index) {
              return _buildImage(widget.imageUrls[index], index);
            }
          ),
          if (widget.arrowController == true) ...[
            Positioned(
              left: 10,
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios),
                color: Colors.white,
                onPressed: () => _onArrowPressed(-1)
              )
            ),
            Positioned(
              right: 10,
              child: IconButton(
                icon: const Icon(Icons.arrow_forward_ios),
                color: Colors.white,
                onPressed: () => _onArrowPressed(1)
              )
            )
          ],
          if (widget.indicatorIndex == true)
            Positioned(
              bottom: 10,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(widget.imageUrls.length, (index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: _currentPage == index ? 12 : 8,
                    height: _currentPage == index ? 12 : 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _currentPage == index
                          ? AppConfig.hexCode('primary')
                          : AppConfig.hexCode('gray')
                    )
                  );
                })
              )
            )
        ]
      )
    );
  }
}