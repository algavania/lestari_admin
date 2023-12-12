import 'package:cloud_firestore/cloud_firestore.dart';

class ArticleModel {
  final String authorId, title, description;
  final DateTime createdAt;
  String id, imageUrl;

  ArticleModel({
    required this.id,
    required this.authorId,
    required this.title,
    required this.imageUrl,
    required this.description,
    required this.createdAt,
  });

  factory ArticleModel.fromMap(Map<String, dynamic> json) {
    Timestamp createdAt = json["created_at"];
    return ArticleModel(
      id: json["id"],
      title: json["title"],
      authorId: json["author_id"],
      imageUrl: json["image_url"],
      description: json["description"],
      createdAt: createdAt.toDate(),
    );
  }

  Map<String, dynamic> toMap() => {
    "title": title,
    "searchable_title": title.toUpperCase(),
    "author_id": authorId,
    "image_url": imageUrl,
    "description": description,
    "created_at": Timestamp.fromDate(createdAt),
  };
}