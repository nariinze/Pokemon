import 'package:flutter/material.dart';
import 'models/item.dart';

/// Kontrak yang harus diisi tiap tema. Semua yang berbeda antar tema
/// (nama, API, filter, field detail) ada di lib/config.dart.
abstract class AppConfig {
  // ---- teks & ikon ----
  String get titleLeft; // judul AppBar bagian putih, contoh: "Poké"
  String get titleRight; // bagian berwarna, contoh: "dex"
  String get loginSubtitle;
  String get registerSubtitle => 'Buat akun dulu sebelum masuk';
  String get searchHint;
  String get emptyTitle => 'Data tidak ditemukan';
  IconData get logoIcon;

  // ---- tab bottom navigation ----
  String get tabItems;
  IconData get tabItemsIcon;
  String get tabEntries;
  IconData get tabEntriesIcon;

  // ---- filter & search ----
  /// Elemen pertama harus 'All'. Kalau cuma 1 elemen, chip filter disembunyikan.
  List<String> get filters;
  bool get hasSearch => true;

  // ---- data dari API ----
  Future<ItemPage> fetchItems({
    required int page,
    required String filter,
    required String query,
  });

  Future<Item> fetchDetail(Item item);

  Future<List<Entry>> fetchEntries();
}
