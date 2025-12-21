import 'dart:convert';

Account accountFromJson(String str) => Account.fromJson(json.decode(str));

String accountToJson(Account data) => json.encode(data.toJson());

class Account {
  int id;
  String? profilePic;
  String username;
  bool isAdmin;
  bool isAuthor;
  bool isSeller;

  Account({
    required this.id,
    this.profilePic,
    required this.username,
    required this.isAdmin,
    required this.isAuthor,
    required this.isSeller,
  });

  factory Account.fromJson(Map<String, dynamic> json) => Account(
    id: json["id"],
    profilePic: json["profile_pic"],
    username: json["username"],
    isAdmin: json["is_admin"],
    isAuthor: json["is_author"],
    isSeller: json["is_seller"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "profile_pic": profilePic,
    "username": username,
    "is_admin": isAdmin,
    "is_author": isAuthor,
    "is_seller": isSeller,
  };
}
