import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lestari_admin/app/repositories/notifications/base_notifications_repository.dart';
import 'package:lestari_admin/data/models/notification_model.dart';

class NotificationsRepository extends BaseNotificationsRepository {

  @override
  Future<DocumentReference> addNotification(NotificationModel notificationModel, String uid) async {
    Map<String, Object?> json = notificationModel.toMap();
    return await FirebaseFirestore.instance.collection('users').doc(uid).collection('notifications').add(json);
  }
}