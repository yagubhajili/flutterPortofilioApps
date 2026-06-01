import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class AppImage extends StatelessWidget {
  final String? path;
  final String baseUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;

  const AppImage({
    super.key,
    required this.path,
    required this.baseUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final url = path != null ? '$baseUrl$path' : null;

    Widget image;

    if (url == null) {
      image = _placeholder();
    } else {
      image = CachedNetworkImage(
        imageUrl: url,
        width: width,
        height: height,
        fit: fit,
        placeholder: (_, _) => _shimmer(),
        errorWidget: (_, _, _) => _placeholder(),
      );
    }

    if (borderRadius != null) {
      image = ClipRRect(borderRadius: borderRadius!, child: image);
    }

    return image;
  }

  Widget _shimmer() => Shimmer.fromColors(
        baseColor: const Color(0xFF2A2A2A),
        highlightColor: const Color(0xFF3A3A3A),
        child: Container(
          width: width,
          height: height,
          color: const Color(0xFF2A2A2A),
        ),
      );

  Widget _placeholder() => Container(
        width: width,
        height: height,
        color: const Color(0xFF252525),
        child: const Center(
          child: Icon(Icons.movie_outlined, color: Color(0xFF555555), size: 40),
        ),
      );
}
