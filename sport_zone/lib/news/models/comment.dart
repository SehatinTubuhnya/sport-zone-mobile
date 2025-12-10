// To parse this JSON data, do
//
//     final comment = commentFromJson(jsonString);

import 'dart:convert';

Comment commentFromJson(String str) => Comment.fromJson(json.decode(str));

String commentToJson(Comment data) => json.encode(data.toJson());

class Comment {
    String model;
    String pk;
    Fields fields;

    Comment({
        required this.model,
        required this.pk,
        required this.fields,
    });

    factory Comment.fromJson(Map<String, dynamic> json) => Comment(
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
    String content;
    DateTime createdAt;
    int user;
    String username;
    String profilePic;
    String news;

    Fields({
        required this.content,
        required this.createdAt,
        required this.user,
        required this.username,
        required this.profilePic,
        required this.news,
    });

    factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        content: json["content"],
        createdAt: DateTime.parse(json["created_at"]),
        user: json["user"],
        username: json["username"],
        profilePic: json["profile_pic"],
        news: json["news"],
    );

    Map<String, dynamic> toJson() => {
        "content": content,
        "created_at": createdAt.toIso8601String(),
        "user": user,
        "username": username,
        "profile_pic": profilePic,
        "news": news,
    };
}
