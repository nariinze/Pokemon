/// Satu baris info di halaman detail (label + isi).
class DetailField {
  final String label;
  final String value;
  const DetailField(this.label, this.value);

  factory DetailField.fromJson(Map<String, dynamic> json) =>
      DetailField(json['label'] as String, json['value'] as String);

  Map<String, dynamic> toJson() => {'label': label, 'value': value};
}

/// Model generik: satu "benda" yang tampil di list (karakter, pokemon,
/// makanan, produk, dll). Dipakai juga untuk menyimpan favorite.
class Item {
  final String id;
  final String title;
  final String subtitle;
  final String image;
  final String badge; // label kecil berwarna (status / tipe / kategori)
  final String description;
  final List<DetailField> fields;

  const Item({
    required this.id,
    required this.title,
    required this.image,
    this.subtitle = '',
    this.badge = '',
    this.description = '',
    this.fields = const [],
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: json['id'] as String,
      title: json['title'] as String,
      subtitle: (json['subtitle'] ?? '') as String,
      image: (json['image'] ?? '') as String,
      badge: (json['badge'] ?? '') as String,
      description: (json['description'] ?? '') as String,
      fields: ((json['fields'] ?? []) as List)
          .map((e) => DetailField.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'subtitle': subtitle,
        'image': image,
        'badge': badge,
        'description': description,
        'fields': fields.map((f) => f.toJson()).toList(),
      };
}

/// Satu baris pada tab ke-3 (padanan "Episode").
class Entry {
  final String title;
  final String subtitle;
  final String badge;
  const Entry({required this.title, this.subtitle = '', this.badge = ''});
}

class ItemPage {
  final List<Item> items;
  final bool hasNext;
  const ItemPage(this.items, this.hasNext);
}
