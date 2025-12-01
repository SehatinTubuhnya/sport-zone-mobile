
enum ProductCategory {
  equipment,
  apparel,
  ball,
}

ProductCategory? productCategoryFromString(String? value) {
  switch (value) {
    case 'equipment':
      return ProductCategory.equipment;
    case 'apparel':
      return ProductCategory.apparel;
    case 'ball':
      return ProductCategory.ball;
    default:
      return null; // kalau backend kirim nilai aneh / null
  }
}

String? productCategoryToString(ProductCategory? category) {
  switch (category) {
    case ProductCategory.equipment:
      return 'equipment';
    case ProductCategory.apparel:
      return 'apparel';
    case ProductCategory.ball:
      return 'ball';
    default:
      return null;
  }
}

/// Model Product versi Dart untuk Flutter
class Product {
  final int? id; // Django otomatis punya id, biasanya integer
  final String name;
  final int price;
  final String description;
  final ProductCategory? category;
  final String? thumbnail; // URL, boleh null
  final bool isFeatured;
  final int? userId; // ForeignKey ke CustomUser, disimpan sebagai id

  Product({
    this.id,
    required this.name,
    required this.price,
    required this.description,
    this.category,
    this.thumbnail,
    this.isFeatured = false,
    this.userId,
  });

  /// Factory constructor dari JSON (response API Django)
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as int?,
      name: json['name'] as String,
      price: json['price'] as int,
      description: json['description'] as String,
      category: productCategoryFromString(json['category'] as String?),
      thumbnail: json['thumbnail'] as String?,
      isFeatured: (json['is_featured'] ?? false) as bool,
      // tergantung API kamu, kadang 'user' atau 'user_id'
      userId: json['user'] as int?, 
    );
  }

  /// Convert ke JSON (untuk POST/PUT ke API)
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'price': price,
      'description': description,
      'category': productCategoryToString(category),
      'thumbnail': thumbnail,
      'is_featured': isFeatured,
      'user': userId,
    };
  }

  /// Optional: biar gampang update sebagian field
  Product copyWith({
    int? id,
    String? name,
    int? price,
    String? description,
    ProductCategory? category,
    String? thumbnail,
    bool? isFeatured,
    int? userId,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      description: description ?? this.description,
      category: category ?? this.category,
      thumbnail: thumbnail ?? this.thumbnail,
      isFeatured: isFeatured ?? this.isFeatured,
      userId: userId ?? this.userId,
    );
  }
}
