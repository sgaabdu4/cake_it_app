import 'package:flutter/material.dart';

class CachedNetworkImage extends StatelessWidget {
  const CachedNetworkImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.placeholder,
    this.errorWidget,
  });

  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Widget? placeholder;
  final Widget? errorWidget;

  @override
  Widget build(BuildContext context) {
    return Image.network(
      imageUrl,
      width: width,
      height: height,
      fit: fit,
      // handle infinite cache values
      cacheWidth: width != null && width!.isFinite ? width!.toInt() : null,
      cacheHeight: height != null && height!.isFinite ? height!.toInt() : null,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return placeholder ??
            SizedBox(
              width: width,
              height: height,
              child: const Center(
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            );
      },
      errorBuilder: (context, error, stackTrace) {
        return errorWidget ??
            SizedBox(
              width: width,
              height: height,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.broken_image,
                  color: Colors.grey.shade400,
                  size: (width != null &&
                          width!.isFinite &&
                          height != null &&
                          height!.isFinite)
                      ? (width! + height!) / 4
                      : 32,
                ),
              ),
            );
      },
    );
  }
}
