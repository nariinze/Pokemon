import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'app_config.dart';
import 'models/item.dart';

/// TEMA: Pokédex  |  API: https://pokeapi.co/api/v2
///  - List      : /pokemon?limit=1025       (nama + url, id diambil dari url)
///  - Filter    : /type/{fire}              (daftar pokemon bertipe tsb)
///  - Detail    : /pokemon/{id}
///  - Tab ke-3  : /move?limit=100
class _Ref {
  final int id;
  final String name;
  _Ref(this.id, this.name);
}

class PokemonConfig extends AppConfig {
  static const _base = 'https://pokeapi.co/api/v2';
  static const _timeout = Duration(seconds: 20);
  static const _pageSize = 20;

  List<_Ref>? _all;
  final Map<String, List<_Ref>> _byTypeCache = {};

  @override
  String get titleLeft => 'Poké';
  @override
  String get titleRight => 'dex';
  @override
  String get loginSubtitle => 'Login untuk mulai menangkap semua Pokémon';
  @override
  String get registerSubtitle => 'Daftar dulu sebelum jadi Pokémon Trainer';
  @override
  String get searchHint => 'Cari Pokémon...';
  @override
  String get emptyTitle => 'Pokémon tidak ditemukan';
  @override
  IconData get logoIcon => Icons.catching_pokemon_rounded;

  @override
  String get tabItems => 'Pokédex';
  @override
  IconData get tabItemsIcon => Icons.catching_pokemon_rounded;
  @override
  String get tabEntries => 'Moves';
  @override
  IconData get tabEntriesIcon => Icons.flash_on_rounded;

  @override
  List<String> get filters => const [
        'All', 'Normal', 'Fire', 'Water', 'Grass', 'Electric', 'Ice',
        'Fighting', 'Poison', 'Ground', 'Flying', 'Psychic', 'Bug', 'Rock',
        'Ghost', 'Dragon', 'Dark', 'Steel', 'Fairy',
      ];

  // ---------- helper ----------
  int _idFromUrl(String url) {
    final parts = url.split('/').where((e) => e.isNotEmpty).toList();
    return int.parse(parts.last);
  }

  String _cap(String s) => s
      .split('-')
      .map((w) => w.isEmpty ? w : w[0].toUpperCase() + w.substring(1))
      .join(' ');

  String _art(int id) =>
      'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/$id.png';

  Future<dynamic> _get(String path) async {
    final res = await http.get(Uri.parse('$_base/$path')).timeout(_timeout);
    if (res.statusCode != 200) {
      throw Exception('Gagal memuat data (${res.statusCode})');
    }
    return jsonDecode(res.body);
  }

  Future<List<_Ref>> _allPokemon() async {
    if (_all != null) return _all!;
    final data = await _get('pokemon?limit=1025&offset=0');
    _all = (data['results'] as List)
        .map((e) => _Ref(_idFromUrl(e['url'] as String), e['name'] as String))
        .toList();
    return _all!;
  }

  Future<List<_Ref>> _byType(String type) async {
    final cached = _byTypeCache[type];
    if (cached != null) return cached;
    final data = await _get('type/$type');
    final list = (data['pokemon'] as List)
        .map((e) => e['pokemon'])
        .map((p) => _Ref(_idFromUrl(p['url'] as String), p['name'] as String))
        .where((r) => r.id <= 1025)
        .toList()
      ..sort((a, b) => a.id.compareTo(b.id));
    _byTypeCache[type] = list;
    return list;
  }

  Item _toItem(_Ref r) => Item(
        id: '${r.id}',
        title: _cap(r.name),
        subtitle: '#${r.id.toString().padLeft(4, '0')}',
        image: _art(r.id),
      );

  // ---------- API ----------
  @override
  Future<ItemPage> fetchItems({
    required int page,
    required String filter,
    required String query,
  }) async {
    var source = filter == 'All'
        ? await _allPokemon()
        : await _byType(filter.toLowerCase());

    final q = query.trim().toLowerCase();
    if (q.isNotEmpty) {
      source = source.where((r) => r.name.contains(q)).toList();
    }

    // paginasi dilakukan lokal
    final start = (page - 1) * _pageSize;
    if (start >= source.length) return const ItemPage([], false);
    final end =
        start + _pageSize > source.length ? source.length : start + _pageSize;
    return ItemPage(
      source.sublist(start, end).map(_toItem).toList(),
      end < source.length,
    );
  }

  @override
  Future<Item> fetchDetail(Item item) async {
    final d = await _get('pokemon/${item.id}') as Map<String, dynamic>;

    final types = (d['types'] as List)
        .map((t) => _cap(t['type']['name'] as String))
        .toList();
    final abilities = (d['abilities'] as List)
        .map((a) => _cap(a['ability']['name'] as String))
        .toList();

    final stats = <DetailField>[];
    for (final s in d['stats'] as List) {
      stats.add(DetailField(_cap(s['stat']['name'] as String), '${s['base_stat']}'));
    }

    final height = (d['height'] as int) / 10;
    final weight = (d['weight'] as int) / 10;

    return Item(
      id: item.id,
      title: item.title,
      subtitle: item.subtitle,
      image: item.image,
      badge: types.isNotEmpty ? types.first : '',
      fields: [
        DetailField('Type', types.join(', ')),
        DetailField('Height', '$height m'),
        DetailField('Weight', '$weight kg'),
        DetailField('Abilities', abilities.join(', ')),
        DetailField('Base EXP', '${d['base_experience'] ?? '-'}'),
        ...stats,
      ],
    );
  }

  @override
  Future<List<Entry>> fetchEntries() async {
    final data = await _get('move?limit=100');
    return (data['results'] as List).map((e) {
      final id = _idFromUrl(e['url'] as String);
      return Entry(title: _cap(e['name'] as String), subtitle: 'Move #$id');
    }).toList();
  }
}

final AppConfig appConfig = PokemonConfig();
