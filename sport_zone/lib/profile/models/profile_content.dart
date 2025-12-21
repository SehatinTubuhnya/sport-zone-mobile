import 'dart:convert';

List<ProfileArticleContent> profileArticleContentFromJson(String str) =>
    List<ProfileArticleContent>.from(
      json.decode(str).map((x) => ProfileArticleContent.fromJson(x)),
    );

String profileArticleContentToJson(List<ProfileArticleContent> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ProfileArticleContent {
  String id;
  String title;
  String snippet;
  DateTime createdAt;

  ProfileArticleContent({
    required this.id,
    required this.title,
    required this.snippet,
    required this.createdAt,
  });

  factory ProfileArticleContent.fromJson(Map<String, dynamic> json) =>
      ProfileArticleContent(
        id: json["id"],
        title: json["title"],
        snippet: json["snippet"],
        createdAt: DateTime.parse(json["created_at"]),
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "snippet": snippet,
    "created_at": createdAt.toIso8601String(),
  };
}

List<ProfileProductContent> profileProductContentFromJson(String str) =>
    List<ProfileProductContent>.from(
      json.decode(str).map((x) => ProfileProductContent.fromJson(x)),
    );

String profileProductContentToJson(List<ProfileProductContent> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ProfileProductContent {
  int id;
  String name;
  int price;
  String category;
  String thumbnail;

  ProfileProductContent({
    required this.id,
    required this.name,
    required this.price,
    required this.category,
    required this.thumbnail,
  });

  factory ProfileProductContent.fromJson(Map<String, dynamic> json) =>
      ProfileProductContent(
        id: json["id"],
        name: json["name"],
        price: json["price"],
        category: json["category"],
        thumbnail: json["thumbnail"],
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "price": price,
    "category": category,
    "thumbnail": thumbnail,
  };
}
