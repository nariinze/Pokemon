import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/item.dart';
import '../screens/detail_screen.dart';
import '../theme.dart';
import 'favorite_button.dart';
import 'net_image.dart';
import 'status_chip.dart';

class ItemCard extends StatelessWidget {
  final Item item;
  const ItemCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final heroTag = 'home-${item.id}';
    return GestureDetector(
      onTap: () => Get.to(
        () => DetailScreen(item: item, heroTag: heroTag),
        transition: Transition.fadeIn,
      ),
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: Colors.white.withValues(alpha: .06)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Hero(tag: heroTag, child: NetImage(url: item.image)),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: FavoriteButton(item: item, small: true),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      if (item.badge.isNotEmpty) ...[
                        StatusDot(label: item.badge),
                        const SizedBox(width: 8),
                      ],
                      Expanded(
                        child: Text(
                          item.subtitle.isNotEmpty ? item.subtitle : item.badge,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontSize: 12, color: AppColors.muted),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
