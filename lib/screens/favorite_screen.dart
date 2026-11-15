import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/favorite_controller.dart';
import '../theme.dart';
import '../widgets/app_snackbar.dart';
import '../widgets/net_image.dart';
import '../widgets/state_views.dart';
import '../widgets/status_chip.dart';
import 'detail_screen.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final fav = Get.find<FavoriteController>();

    return Scaffold(
      appBar: AppBar(title: const Text('Favorites')),
      body: Obx(() {
        final list = fav.favorites.toList();

        // Pesan jika daftar favorite masih kosong
        if (list.isEmpty) {
          return const EmptyView(
            icon: Icons.favorite_border_rounded,
            title: 'Belum ada favorit',
            subtitle: 'Tekan ikon hati untuk menyimpannya di sini.',
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
          itemCount: list.length + 1,
          itemBuilder: (ctx, i) {
            if (i == 0) {
              return const Padding(
                padding: EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    Icon(Icons.swipe_left_rounded,
                        size: 16, color: AppColors.muted),
                    SizedBox(width: 6),
                    Text('Geser ke kiri untuk menghapus',
                        style:
                            TextStyle(fontSize: 12, color: AppColors.muted)),
                  ],
                ),
              );
            }
            final it = list[i - 1];

            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Dismissible(
                  key: ValueKey('fav-${it.id}'),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 24),
                    color: Colors.redAccent,
                    child: const Icon(Icons.delete_rounded,
                        color: Colors.white, size: 28),
                  ),
                  onDismissed: (_) async {
                    final index = await fav.remove(it);
                    if (!ctx.mounted) return;
                    showAppSnackBar(
                      ctx,
                      '${it.title} berhasil dihapus dari favorit',
                      icon: Icons.delete_rounded,
                      color: Colors.redAccent,
                      action: SnackBarAction(
                        label: 'UNDO',
                        textColor: AppColors.primary,
                        onPressed: () => fav.restore(it, index),
                      ),
                    );
                  },
                  child: InkWell(
                    onTap: () => Get.to(() => DetailScreen(item: it)),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      color: AppColors.surface,
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(14),
                            child: SizedBox(
                              width: 72,
                              height: 72,
                              child: NetImage(url: it.image),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(it.title,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w800)),
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    if (it.badge.isNotEmpty) ...[
                                      StatusDot(label: it.badge),
                                      const SizedBox(width: 8),
                                    ],
                                    Expanded(
                                      child: Text(
                                        it.subtitle.isNotEmpty
                                            ? it.subtitle
                                            : it.badge,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                            fontSize: 13,
                                            color: AppColors.muted),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const Icon(Icons.favorite_rounded,
                              color: Colors.redAccent),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
