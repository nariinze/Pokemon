import 'package:flutter/material.dart';
import '../theme.dart';

class NetImage extends StatelessWidget {
  final String url;
  final BoxFit fit;
  const NetImage({super.key, required this.url, this.fit = BoxFit.cover});

  @override
  Widget build(BuildContext context) {
    return Image.network(
      url,
      fit: fit,
      loadingBuilder: (context, child, progress) {
        if (progress == null) return child;
        return Container(
          color: AppColors.surface2,
          child: const Center(
            child: SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: AppColors.primary,
              ),
            ),
          ),
        );
      },
      errorBuilder: (context, error, stack) => Container(
        color: AppColors.surface2,
        child: const Icon(Icons.broken_image_outlined, color: AppColors.muted),
      ),
    );
  }
}
