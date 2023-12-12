import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lestari_admin/data/models/notification_model.dart';

abstract class BaseNotificationsRepository {
  Future<DocumentReference> addNotification(NotificationModel notificationModel, String uid);
}