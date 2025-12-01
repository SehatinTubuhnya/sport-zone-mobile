// To parse this JSON data, do
//
//     final newsEntry = newsEntryFromJson(jsonString);

import 'dart:convert';

NewsEntry newsEntryFromJson(String str) => NewsEntry.fromJson(json.decode(str));

String newsEntryToJson(NewsEntry data) => json.encode(data.toJson());

class NewsEntry {
    String model;
    String pk;
    Fields fields;

    NewsEntry({
        required this.model,
        required this.pk,
        required this.fields,
    });

    factory NewsEntry.fromJson(Map<String, dynamic> json) => NewsEntry(
        model: json["model"],
        pk: json["pk"],
        fields: Fields.fromJson(json["fields"]),
    );

    Map<String, dynamic> toJson() => {
        "model": model,
        "pk": pk,
        "fields": fields.toJson(),
    };
}

class Fields {
    int? user;
    String username;
    String title;
    String content;
    String category;
    String sportsType;
    String thumbnail;
    int newsViews;
    DateTime createdAt;
    bool isFeatured;

    Fields({
        this.user,
        required this.username,
        required this.title,
        required this.content,
        required this.category,
        required this.sportsType,
        required this.thumbnail,
        required this.newsViews,
        required this.createdAt,
        required this.isFeatured,
    });

    factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        user: json["user"],
        username: json["username"],
        title: json["title"],
        content: json["content"],
        category: json["category"],
        sportsType: json["sports_type"],
        thumbnail: json["thumbnail"],
        newsViews: json["news_views"],
        createdAt: DateTime.parse(json["created_at"]),
        isFeatured: json["is_featured"],
    );

    Map<String, dynamic> toJson() => {
        "user": user,
        "username": username,
        "title": title,
        "content": content,
        "category": category,
        "sports_type": sportsType,
        "thumbnail": thumbnail,
        "news_views": newsViews,
        "created_at": createdAt.toIso8601String(),
        "is_featured": isFeatured,
    };
}
