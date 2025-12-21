import 'dart:convert';

ProfileDetail profileDetailFromJson(String str) =>
    ProfileDetail.fromJson(json.decode(str));

String profileDetailToJson(ProfileDetail data) => json.encode(data.toJson());

class ProfileDetail {
  int id;
  String username;
  String profilePic;
  String dateJoinedDisplay;
  String birthDateDisplay;
  DateTime birthDateIso;
  bool isAdmin;
  bool isSeller;
  bool isAuthor;
  bool isSelf;

  ProfileDetail({
    required this.id,
    required this.username,
    required this.profilePic,
    required this.dateJoinedDisplay,
    required this.birthDateDisplay,
    required this.birthDateIso,
    required this.isAdmin,
    required this.isSeller,
    required this.isAuthor,
    required this.isSelf,
  });

  factory ProfileDetail.fromJson(Map<String, dynamic> json) => ProfileDetail(
    id: json["id"],
    username: json["username"],
    profilePic: json["profile_pic"],
    dateJoinedDisplay: json["date_joined_display"],
    birthDateDisplay: json["birth_date_display"],
    birthDateIso: DateTime.parse(json["birth_date_iso"]),
    isAdmin: json["is_admin"],
    isSeller: json["is_seller"],
    isAuthor: json["is_author"],
    isSelf: json["is_self"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "username": username,
    "profile_pic": profilePic,
    "date_joined_display": dateJoinedDisplay,
    "birth_date_display": birthDateDisplay,
    "birth_date_iso":
        "${birthDateIso.year.toString().padLeft(4, '0')}-${birthDateIso.month.toString().padLeft(2, '0')}-${birthDateIso.day.toString().padLeft(2, '0')}",
    "is_admin": isAdmin,
    "is_seller": isSeller,
    "is_author": isAuthor,
    "is_self": isSelf,
  };
}
