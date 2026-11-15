import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../config.dart';
import '../controllers/entry_controller.dart';
import '../theme.dart';
import '../widgets/state_views.dart';

/// Tab ke-3 (padanan "Episode"): daftar sederhana judul + keterangan.
class EntryScreen extends StatelessWidget {
  const EntryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<EntryController>();

    return Scaffold(
      appBar: AppBar(title: Text(appConfig.tabEntries)),
      body: Obx(() {
        final loading = c.isLoading.value;
        final error = c.errorMessage.value;
        final list = c.entries.toList();

        if (loading) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        }
        if (error != null) {
          return Center(
            child: SingleChildScrollView(
              child: ErrorView(message: error, onRetry: c.fetchEntries),
            ),
          );
        }
        if (list.isEmpty) {
          return const EmptyView(
            icon: Icons.inbox_rounded,
            title: 'Belum ada data',
            subtitle: 'Tarik layar ke bawah untuk memuat ulang.',
          );
        }

        return RefreshIndicator(
          color: AppColors.primary,
          backgroundColor: AppColors.surface,
          onRefresh: c.fetchEntries,
          child: ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
            itemCount: list.length,
            itemBuilder: (context, i) {
              final e = list[i];
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: Colors.white.withValues(alpha: .06)),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 46,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: .14),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${i + 1}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w900,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(e.title,
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w800)),
                          if (e.subtitle.isNotEmpty) ...[
                            const SizedBox(height: 4),
                            Text(e.subtitle,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    fontSize: 13, color: AppColors.muted)),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      }),
    );
  }
}
