import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../config.dart';
import '../controllers/entry_controller.dart';
import '../controllers/favorite_controller.dart';
import '../controllers/item_controller.dart';
import '../services/auth_service.dart';
import '../theme.dart';
import '../widgets/item_card.dart';
import '../widgets/state_views.dart';
import '../widgets/status_chip.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final c = Get.find<ItemController>();
  final _scroll = ScrollController();
  final _search = TextEditingController();

  @override
  void initState() {
    super.initState();
    _scroll.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scroll.dispose();
    _search.dispose();
    super.dispose();
  }

  // Infinite scroll: muat halaman berikutnya saat hampir mentok bawah
  void _onScroll() {
    if (!_scroll.hasClients) return;
    if (_scroll.position.pixels >= _scroll.position.maxScrollExtent - 300) {
      c.loadMore();
    }
  }

  Future<void> _logout() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text('Logout'),
        content: const Text('Yakin ingin keluar dari akunmu?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Logout',
                style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );
    if (ok != true) return;

    await AuthService.logout();
    Get.find<FavoriteController>().clear();
    Get.delete<ItemController>(force: true);
    Get.delete<EntryController>(force: true);
    Get.offAll(() => const LoginScreen(), transition: Transition.fadeIn);
  }

  @override
  Widget build(BuildContext context) {
    final filters = appConfig.filters;
    return Scaffold(
      appBar: AppBar(
        title: Text.rich(
          TextSpan(children: [
            TextSpan(text: appConfig.titleLeft),
            TextSpan(
              text: appConfig.titleRight,
              style: const TextStyle(color: AppColors.primary),
            ),
          ]),
        ),
        actions: [
          IconButton(
            tooltip: 'Logout',
            onPressed: _logout,
            icon: const Icon(Icons.logout_rounded),
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: Column(
        children: [
          // ---------- Search ----------
          if (appConfig.hasSearch)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
              child: TextField(
                controller: _search,
                textInputAction: TextInputAction.search,
                onChanged: (v) {
                  setState(() {});
                  c.onSearchChanged(v);
                },
                decoration: InputDecoration(
                  hintText: appConfig.searchHint,
                  prefixIcon: const Icon(Icons.search_rounded),
                  suffixIcon: _search.text.isEmpty
                      ? null
                      : IconButton(
                          icon: const Icon(Icons.close_rounded),
                          onPressed: () {
                            _search.clear();
                            setState(() {});
                            c.onSearchChanged('');
                          },
                        ),
                ),
              ),
            ),
          // ---------- Filter ----------
          if (filters.length > 1)
            SizedBox(
              height: 44,
              child: Obx(() {
                final current = c.filter.value;
                return ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: filters.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (_, i) {
                    final f = filters[i];
                    final selected = current == f;
                    return ChoiceChip(
                      showCheckmark: false,
                      selected: selected,
                      onSelected: (_) => c.setFilter(f),
                      selectedColor: AppColors.primary,
                      backgroundColor: AppColors.surface,
                      side: BorderSide(
                        color: selected
                            ? AppColors.primary
                            : Colors.white.withValues(alpha: .08),
                      ),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                      avatar: i == 0 ? null : StatusDot(label: f),
                      label: Text(
                        f,
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          color: selected ? Colors.black : Colors.white,
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
          const SizedBox(height: 8),
          // ---------- Konten: loading / error / kosong / grid ----------
          Expanded(child: _buildContent()),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return Obx(() {
      final loading = c.isLoading.value;
      final error = c.errorMessage.value;
      final list = c.items.toList();

      if (loading) {
        return const Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        );
      }
      if (error != null) {
        return Center(
          child: SingleChildScrollView(
            child: ErrorView(message: error, onRetry: c.fetchItems),
          ),
        );
      }
      if (list.isEmpty) {
        return EmptyView(
          icon: Icons.search_off_rounded,
          title: appConfig.emptyTitle,
          subtitle: 'Coba ganti kata kunci atau filter.',
        );
      }

      return RefreshIndicator(
        color: AppColors.primary,
        backgroundColor: AppColors.surface,
        onRefresh: c.fetchItems,
        child: CustomScrollView(
          controller: _scroll,
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 14,
                  crossAxisSpacing: 14,
                  childAspectRatio: .72,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, i) => ItemCard(item: list[i]),
                  childCount: list.length,
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Obx(() => c.isLoadingMore.value
                  ? const Padding(
                      padding: EdgeInsets.all(20),
                      child: Center(
                        child: SizedBox(
                          width: 26,
                          height: 26,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    )
                  : const SizedBox(height: 16)),
            ),
          ],
        ),
      );
    });
  }
}
