class Product {
  final int id;
  final String name;
  final int price;
  final String category;
  final String description;
  final String? thumbnail;
  final bool isFeatured;
  final int? sellerId;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.category,
    required this.description,
    this.thumbnail,
    required this.isFeatured,
    this.sellerId,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      price: json['price'],
      category: json['category'],
      description: json['description'] ?? '',
      thumbnail: json['thumbnail'],
      isFeatured: json['is_featured'] ?? false,
      sellerId: json['seller_id'],
    );
  }
}
