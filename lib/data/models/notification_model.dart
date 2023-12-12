import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

NotificationModel notificationModelFromMap(String str) => NotificationModel.fromMap(json.decode(str));

String notificationModelToMap(NotificationModel data) => json.encode(data.toMap());

class NotificationModel {
  NotificationModel({
    required this.id,
    required this.campaignTitle,
    required this.action,
    required this.reason,
    required this.isRead,
    required this.createdAt,
  });

  final String id, campaignTitle, action, reason;
  bool isRead;
  final DateTime createdAt;

  factory NotificationModel.fromMap(Map<String, dynamic> json) {
    Timestamp createdAt = json["created_at"];
    return NotificationModel(
      id: json["id"],
      campaignTitle: json["campaign_title"],
      action: json["action"],
      reason: json["reason"],
      isRead: json["is_read"],
      createdAt: createdAt.toDate(),
    );
  }

  Map<String, dynamic> toMap() => {
    "campaign_title": campaignTitle,
    "action": action,
    "reason": reason,
    "is_read": isRead,
    "created_at": Timestamp.fromDate(createdAt),
  };
}