// To parse this JSON data, do
//
//     final adminSummary = adminSummaryFromJson(jsonString);

import 'dart:convert';

AdminSummary adminSummaryFromJson(String str) => AdminSummary.fromJson(json.decode(str));

String adminSummaryToJson(AdminSummary data) => json.encode(data.toJson());

class AdminSummary {
    int userCount;
    int articleCount;
    int productCount;
    List<RecentLog> recentLogs;

    AdminSummary({
        required this.userCount,
        required this.articleCount,
        required this.productCount,
        required this.recentLogs,
    });

    factory AdminSummary.fromJson(Map<String, dynamic> json) => AdminSummary(
        userCount: json["user_count"],
        articleCount: json["article_count"],
        productCount: json["product_count"],
        recentLogs: List<RecentLog>.from(json["recent_logs"].map((x) => RecentLog.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "user_count": userCount,
        "article_count": articleCount,
        "product_count": productCount,
        "recent_logs": List<dynamic>.from(recentLogs.map((x) => x.toJson())),
    };
}

class RecentLog {
    DateTime timestamp;
    String actor;
    String action;

    RecentLog({
        required this.timestamp,
        required this.actor,
        required this.action,
    });

    factory RecentLog.fromJson(Map<String, dynamic> json) => RecentLog(
        timestamp: DateTime.parse(json["timestamp"]),
        actor: json["actor"],
        action: json["action"],
    );

    Map<String, dynamic> toJson() => {
        "timestamp": timestamp.toIso8601String(),
        "actor": actor,
        "action": action,
    };
}
