import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lestari_admin/app/common/shared_code.dart';
import 'package:lestari_admin/app/repositories/auth/base_auth_repository.dart';
import 'package:lestari_admin/data/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepository extends BaseAuthRepository {
  @override
  Future<void> login(String email, String password) async {
    try {
      final UserCredential credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      User user = credential.user!;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('uid', user.uid);

      DocumentSnapshot snapshot = await SharedCode.firestore
          .collection('users')
          .doc(user.uid)
          .get();
      if (snapshot.exists) {
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
        data['uid'] = user.uid;
        UserModel userModel = UserModel.fromMap(data);

        if (userModel.role != 'admin') throw 'not-admin';
      } else {
        throw 'not-exist';
      }
    } on FirebaseAuthException catch (e) {
      throw e.code;
    }
  }
}
