import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

ReportModel reportModelFromMap(String str) =>
    ReportModel.fromMap(json.decode(str));

String reportModelToMap(ReportModel data) => json.encode(data.toMap());

class ReportModel {
  String id;
  final DateTime createdAt;
  final String objectId, category, subject, description, title, reason, action;
  List<String> imageUrls;
  final bool isOpenIssue;

  ReportModel({
    required this.id,
    required this.createdAt,
    required this.objectId,
    required this.category,
    required this.title,
    required this.subject,
    this.reason = '',
    this.action = '',
    required this.description,
    required this.isOpenIssue,
    required this.imageUrls});

  factory ReportModel.fromMap(Map<String, dynamic> json) {
    Timestamp createdAt = json["created_at"];

    return ReportModel(
      id: json['id'],
      title: json['title'],
      createdAt: createdAt.toDate(),
      objectId: json['object_id'],
      category: json['category'],
      subject: json['subject'],
      reason: json['action'],
      action: json['reason'],
      description: json['description'],
      isOpenIssue: json['is_open_issue'],
      imageUrls: List<String>.from(json["image_urls"].map((x) => x)),
    );
  }

  Map<String, dynamic> toMap() =>
      {
        "object_id": objectId,
        "category": category,
        "title": title,
        "reason": reason,
        "action": action,
        "subject": subject,
        "description": description,
        "is_open_issue": isOpenIssue,
        "image_urls": List<String>.from(imageUrls.map((x) => x)),
        "created_at": Timestamp.fromDate(createdAt),
      };
}