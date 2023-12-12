import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

CampaignModel campaignModelFromMap(String str) => CampaignModel.fromMap(json.decode(str));

String campaignModelToMap(CampaignModel data) => json.encode(data.toMap());

class CampaignModel {
  String id, status;
  final String organizerId, title, category, province, city, description, websiteUrl;
  List<String> imageUrls;
  final DateTime date;

  CampaignModel({
    required this.id,
    required this.title,
    required this.organizerId,
    required this.category,
    required this.province,
    required this.city,
    required this.imageUrls,
    required this.description,
    required this.websiteUrl,
    required this.date,
    required this.status,
  });

  factory CampaignModel.fromMap(Map<String, dynamic> json) {
    Timestamp date = json["date"];
    return CampaignModel(
      id: json["id"],
      title: json["title"],
      organizerId: json["organizer_id"],
      category: json["category"],
      province: json["province"],
      city: json["city"],
      imageUrls: List<String>.from(json["image_urls"].map((x) => x)),
      description: json["description"],
      websiteUrl: json["website_url"],
      status: json["status"],
      date: date.toDate(),
    );
  }

  Map<String, dynamic> toMap() => {
    "title": title,
    "organizer_id": organizerId,
    "category": category,
    "province": province,
    "city": city,
    "image_urls": List<dynamic>.from(imageUrls.map((x) => x)),
    "description": description,
    "website_url": websiteUrl,
    "status": status,
    "date": Timestamp.fromDate(date),
  };
}