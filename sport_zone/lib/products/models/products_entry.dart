// To parse this JSON data, do
//
//     final productList = productListFromJson(jsonString);

import 'dart:convert';

ProductList productListFromJson(String str) => ProductList.fromJson(json.decode(str));

String productListToJson(ProductList data) => json.encode(data.toJson());

class ProductList {
    List<Product> products;

    ProductList({
        required this.products,
    });

    factory ProductList.fromJson(Map<String, dynamic> json) => ProductList(
        products: List<Product>.from(json["products"].map((x) => Product.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "products": List<dynamic>.from(products.map((x) => x.toJson())),
    };
}

class Product {
    int id;
    String name;
    int price;
    String description;
    Category category;
    String thumbnail;
    bool isFeatured;
    SellerName sellerName;
    dynamic sellerId;

    Product({
        required this.id,
        required this.name,
        required this.price,
        required this.description,
        required this.category,
        required this.thumbnail,
        required this.isFeatured,
        required this.sellerName,
        required this.sellerId,
    });

    factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json["id"],
        name: json["name"],
        price: json["price"],
        description: json["description"],
        category: categoryValues.map[json["category"]]!,
        thumbnail: json["thumbnail"],
        isFeatured: json["is_featured"],
        sellerName: sellerNameValues.map[json["seller_name"]]!,
        sellerId: json["seller_id"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "price": price,
        "description": description,
        "category": categoryValues.reverse[category],
        "thumbnail": thumbnail,
        "is_featured": isFeatured,
        "seller_name": sellerNameValues.reverse[sellerName],
        "seller_id": sellerId,
    };
}

enum Category {
    APPAREL,
    BALL,
    EQUIPMENT
}

final categoryValues = EnumValues({
    "apparel": Category.APPAREL,
    "ball": Category.BALL,
    "equipment": Category.EQUIPMENT
});

enum SellerName {
    TOKO_RESMI
}

final sellerNameValues = EnumValues({
    "Toko Resmi": SellerName.TOKO_RESMI
});

class EnumValues<T> {
    Map<String, T> map;
    late Map<T, String> reverseMap;

    EnumValues(this.map);

    Map<T, String> get reverse {
            reverseMap = map.map((k, v) => MapEntry(v, k));
            return reverseMap;
    }
}

Category? productCategoryFromString(String? value) {
  switch (value) {
    case 'equipment':
      return Category.EQUIPMENT;
    case 'apparel':
      return Category.APPAREL;
    case 'ball':
      return Category.BALL;
    default:
      return null; // kalau backend kirim nilai aneh / null
  }
}

String? productCategoryToString(Category? category) {
  switch (category) {
    case Category.EQUIPMENT:
      return 'equipment';
    case Category.APPAREL:
      return 'apparel';
    case Category.BALL:
      return 'ball';
    default:
      return null;
  }
}
