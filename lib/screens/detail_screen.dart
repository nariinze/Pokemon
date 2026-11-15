import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../config.dart';
import '../models/item.dart';
import '../theme.dart';
import '../widgets/favorite_button.dart';
import '../widgets/net_image.dart';
import '../widgets/state_views.dart';
import '../widgets/status_chip.dart';

class DetailScreen extends StatefulWidget {
  final Item item;
  final String? heroTag;
  const DetailScreen({super.key, required this.item, this.heroTag});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late Future<Item> _future;

  static const _tileColors = [
    AppColors.primary,
    AppColors.accent,
    Color(0xFFFFA726),
    Color(0xFFEC407A),
    Color(0xFF66BB6A),
  ];

  @override
  void initState() {
    super.initState();
    _future = appConfig.fetchDetail(widget.item); // GET detail dari API
  }

  void _retry() {
    setState(() => _future = appConfig.fetchDetail(widget.item));
  }

  @override
  Widget build(BuildContext context) {
    final it = widget.item;
    Widget image = NetImage(url: it.image);
    if (widget.heroTag != null) {
      image = Hero(tag: widget.heroTag!, child: image);
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: Padding(
          padding: const EdgeInsets.all(8),
          child: Material(
            color: Colors.black.withValues(alpha: .45),
            shape: const CircleBorder(),
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: () => Get.back(),
              child: const Icon(Icons.arrow_back_rounded, color: Colors.white),
            ),
          ),
        ),
        actions: [
          FavoriteButton(item: it),
          const SizedBox(width: 12),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          // ---------- Foto ----------
          SizedBox(
            height: 400,
            child: Stack(
              fit: StackFit.expand,
              children: [
                image,
                const DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.center,
                      end: Alignment.bottomCenter,
                      colors: [Colors.transparent, AppColors.bg],
                    ),
                  ),
                ),
              ],
            ),
          ),
          // ---------- Nama ----------
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(it.title,
                    style: const TextStyle(
                        fontSize: 30, fontWeight: FontWeight.w900)),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 10,
                  runSpacing: 8,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    if (it.badge.isNotEmpty) StatusChip(label: it.badge),
                    if (it.subtitle.isNotEmpty)
                      Text(it.subtitle,
                          style: const TextStyle(color: AppColors.muted)),
                  ],
                ),
              ],
            ),
          ),
          // ---------- Info detail dari API ----------
          FutureBuilder<Item>(
            future: _future,
            builder: (context, snap) {
              if (snap.connectionState != ConnectionState.done) {
                return const Padding(
                  padding: EdgeInsets.all(40),
                  child: Center(
                    child: CircularProgressIndicator(color: AppColors.primary),
                  ),
                );
              }
              if (snap.hasError) {
                return Center(
                  child: ErrorView(
                    message: 'Gagal memuat detail.',
                    onRetry: _retry,
                  ),
                );
              }
              final d = snap.data!;
              return Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
                child: Column(
                  children: [
                    for (var i = 0; i < d.fields.length; i++)
                      _InfoTile(
                        color: _tileColors[i % _tileColors.length],
                        label: d.fields[i].label,
                        value: d.fields[i].value,
                      ),
                    if (d.description.isNotEmpty)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                              color: Colors.white.withValues(alpha: .06)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Deskripsi',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w800)),
                            const SizedBox(height: 8),
                            Text(d.description,
                                style: const TextStyle(
                                    height: 1.5, color: Colors.white70)),
                          ],
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final Color color;
  final String label;
  final String value;
  const _InfoTile({
    required this.color,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withValues(alpha: .06)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: .15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.bookmark_rounded, color: color, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: const TextStyle(
                        fontSize: 12, color: AppColors.muted)),
                const SizedBox(height: 2),
                Text(value,
                    style: const TextStyle(
                        fontSize: 15,
                        height: 1.4,
                        fontWeight: FontWeight.w700)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
