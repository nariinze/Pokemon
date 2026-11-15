import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/favorite_controller.dart';
import '../models/item.dart';
import 'app_snackbar.dart';

/// Tombol hati. Ikon otomatis berubah (outline <-> solid) mengikuti
/// status favorite, dan menampilkan Snackbar saat ditambah / dihapus.
class FavoriteButton extends StatelessWidget {
  final Item item;
  final bool small;
  const FavoriteButton({super.key, required this.item, this.small = false});

  Future<void> _toggle(BuildContext context, FavoriteController fav) async {
    final added = await fav.toggle(item);
    if (!context.mounted) return;
    showAppSnackBar(
      context,
      added
          ? '${item.title} ditambahkan ke favorit'
          : '${item.title} dihapus dari favorit',
      icon: added ? Icons.favorite_rounded : Icons.heart_broken_rounded,
      color: added ? Colors.redAccent : Colors.white70,
    );
  }

  @override
  Widget build(BuildContext context) {
    final fav = Get.find<FavoriteController>();
    return Obx(() {
      final isFav = fav.isFavorite(item.id);
      return Material(
        color: Colors.black.withValues(alpha: .45),
        shape: const CircleBorder(),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: () => _toggle(context, fav),
          child: Padding(
            padding: EdgeInsets.all(small ? 7 : 10),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 220),
              transitionBuilder: (child, anim) =>
                  ScaleTransition(scale: anim, child: child),
              child: Icon(
                isFav ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                key: ValueKey(isFav),
                color: isFav ? Colors.redAccent : Colors.white,
                size: small ? 20 : 26,
              ),
            ),
          ),
        ),
      );
    });
  }
}
