// To parse this JSON data, do
//
//     final recent = recentFromJson(jsonString);

import 'dart:convert';

Recent recentFromJson(String str) => Recent.fromJson(json.decode(str));

String recentToJson(Recent data) => json.encode(data.toJson());

class Recent {
  List<Article> articles;
  List<Product> products;

  Recent({required this.articles, required this.products});

  factory Recent.fromJson(Map<String, dynamic> json) => Recent(
    articles: List<Article>.from(
      json["articles"].map((x) => Article.fromJson(x)),
    ),
    products: List<Product>.from(
      json["products"].map((x) => Product.fromJson(x)),
    ),
  );

  Map<String, dynamic> toJson() => {
    "articles": List<dynamic>.from(articles.map((x) => x.toJson())),
    "products": List<dynamic>.from(products.map((x) => x.toJson())),
  };
}

class Article {
  String title;
  String category;
  String sportsType;
  String thumbnail;
  bool isFeatured;
  DateTime createdAt;

  Article({
    required this.title,
    required this.category,
    required this.sportsType,
    required this.thumbnail,
    required this.isFeatured,
    required this.createdAt,
  });

  factory Article.fromJson(Map<String, dynamic> json) => Article(
    title: json["title"],
    category: json["category"],
    sportsType: json["sports_type"],
    thumbnail: json["thumbnail"],
    isFeatured: json["is_featured"],
    createdAt: DateTime.parse(json["created_at"]),
  );

  Map<String, dynamic> toJson() => {
    "title": title,
    "category": category,
    "sports_type": sportsType,
    "thumbnail": thumbnail,
    "is_featured": isFeatured,
    "created_at": createdAt.toIso8601String(),
  };
}

class Product {
  String name;
  int price;
  String thumbnail;
  bool isFeatured;

  Product({
    required this.name,
    required this.price,
    required this.thumbnail,
    required this.isFeatured,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    name: json["name"],
    price: json["price"],
    thumbnail: json["thumbnail"],
    isFeatured: json["is_featured"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "price": price,
    "thumbnail": thumbnail,
    "is_featured": isFeatured,
  };
}
