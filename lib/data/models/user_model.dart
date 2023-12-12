import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

UserModel userModelFromMap(String str) => UserModel.fromMap(json.decode(str));

String userModelToMap(UserModel data) => json.encode(data.toMap());


class UserModel {
  final String uid, name, email, role, imageUrl;
  int notifications;
  final DateTime updatedAt;

  UserModel(
      {required this.uid,
        required this.name,
        required this.email,
        required this.role,
        required this.imageUrl,
        required this.notifications,
        required this.updatedAt});

  factory UserModel.fromMap(Map<String, dynamic> json) {
    Timestamp updatedAt = json["updated_at"];
    return UserModel(
      uid: json["uid"],
      name: json["name"],
      email: json["email"],
      role: json["role"],
      imageUrl: json["image_url"],
      notifications: json["notifications"],
      updatedAt: updatedAt.toDate(),
    );
  }

  Map<String, dynamic> toMap() => {
    "name": name,
    "email": email,
    "role": role,
    "image_url": imageUrl,
    "notifications": notifications,
    "updated_at": Timestamp.fromDate(updatedAt),
  };
}