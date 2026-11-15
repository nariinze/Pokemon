import 'dart:async';
import 'package:get/get.dart';

import '../config.dart';
import '../models/item.dart';

class ItemController extends GetxController {
  final items = <Item>[].obs;
  final isLoading = false.obs;
  final isLoadingMore = false.obs;
  final errorMessage = RxnString();
  final filter = 'All'.obs;
  final query = ''.obs;

  int _page = 1;
  bool _hasNext = true;
  int _requestId = 0; // mencegah response lama menimpa response baru
  Timer? _debounce;

  @override
  void onInit() {
    super.onInit();
    filter.value = appConfig.filters.first;
    fetchItems();
  }

  @override
  void onClose() {
    _debounce?.cancel();
    super.onClose();
  }

  Future<void> fetchItems() async {
    final id = ++_requestId;
    isLoading.value = true;
    isLoadingMore.value = false;
    errorMessage.value = null;
    _page = 1;
    _hasNext = true;
    items.clear();

    try {
      final res = await appConfig.fetchItems(
        page: 1,
        filter: filter.value,
        query: query.value,
      );
      if (id != _requestId) return;
      items.assignAll(res.items);
      _hasNext = res.hasNext;
    } catch (e) {
      if (id != _requestId) return;
      errorMessage.value =
          'Gagal memuat data. Periksa koneksi internetmu lalu coba lagi.';
    } finally {
      if (id == _requestId) isLoading.value = false;
    }
    _fillIfShort(id);
  }

  Future<void> loadMore() async {
    if (isLoading.value ||
        isLoadingMore.value ||
        !_hasNext ||
        errorMessage.value != null) {
      return;
    }
    final id = _requestId;
    isLoadingMore.value = true;
    try {
      final res = await appConfig.fetchItems(
        page: _page + 1,
        filter: filter.value,
        query: query.value,
      );
      if (id != _requestId) return;
      _page++;
      items.addAll(res.items);
      _hasNext = res.hasNext;
    } catch (_) {
      // gagal load more: data lama tetap tampil, scroll lagi untuk coba ulang
    } finally {
      if (id == _requestId) isLoadingMore.value = false;
    }
    _fillIfShort(id);
  }

  /// Kalau hasil terlalu sedikit sehingga layar tidak bisa di-scroll,
  /// otomatis muat halaman berikutnya.
  void _fillIfShort(int id) {
    if (id != _requestId) return;
    if (_hasNext &&
        items.length < 10 &&
        !isLoading.value &&
        !isLoadingMore.value &&
        errorMessage.value == null) {
      loadMore();
    }
  }

  void setFilter(String f) {
    if (filter.value == f) return;
    filter.value = f;
    fetchItems();
  }

  void onSearchChanged(String text) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (query.value == text.trim()) return;
      query.value = text.trim();
      fetchItems();
    });
  }
}
