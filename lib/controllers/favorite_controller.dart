import 'dart:convert';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/item.dart';

/// Favorite disimpan di Shared Preferences (per akun) sehingga
/// tidak hilang saat aplikasi ditutup. Karena memakai RxList,
/// Home, Detail dan Favorite screen otomatis ikut ter-update.
class FavoriteController extends GetxController {
  final favorites = <Item>[].obs;
  String _username = '';

  String get _key => 'favorites_$_username';

  Future<void> load(String username) async {
    _username = username;
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_key) ?? [];
    favorites.assignAll(raw
        .map((e) => Item.fromJson(jsonDecode(e) as Map<String, dynamic>))
        .toList());
  }

  void clear() {
    favorites.clear();
    _username = '';
  }

  bool isFavorite(String id) => favorites.any((c) => c.id == id);

  /// return true jika ditambahkan, false jika dihapus
  Future<bool> toggle(Item item) async {
    final added = !isFavorite(item.id);
    if (added) {
      favorites.insert(0, item);
    } else {
      favorites.removeWhere((x) => x.id == item.id);
    }
    await _save();
    return added;
  }

  /// return index lama (untuk fitur undo)
  Future<int> remove(Item item) async {
    final index = favorites.indexWhere((x) => x.id == item.id);
    if (index == -1) return -1;
    favorites.removeAt(index);
    await _save();
    return index;
  }

  Future<void> restore(Item item, int index) async {
    if (isFavorite(item.id)) return;
    final pos = index > favorites.length ? favorites.length : index;
    favorites.insert(pos, item);
    await _save();
  }

  Future<void> _save() async {
    if (_username.isEmpty) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      _key,
      favorites.map((c) => jsonEncode(c.toJson())).toList(),
    );
  }
}
