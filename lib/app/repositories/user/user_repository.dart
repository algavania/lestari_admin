import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lestari_admin/app/repositories/user/base_user_repository.dart';
import 'package:lestari_admin/data/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserRepository extends BaseUserRepository {
  CollectionReference usersRef = FirebaseFirestore.instance.collection('users');

  @override
  Future<UserModel?> getUserById(String uid) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (uid == 'CURRENT_USER') uid = prefs.getString('uid')!;

    try {
      UserModel? userModel;

      final docRef = usersRef.doc(uid);
      await docRef.get().then((DocumentSnapshot doc) {
          Map<String, dynamic> map = doc.data() as Map<String, dynamic>;
          map['uid'] = doc.id;
          userModel = UserModel.fromMap(map);
      });

      return userModel;
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Future<void> updateUser(UserModel userModel) async {
    final docRef = FirebaseFirestore.instance.collection('users').doc(userModel.uid);
    await docRef.set(userModel.toMap());
  }
}