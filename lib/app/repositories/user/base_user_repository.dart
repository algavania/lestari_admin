import 'package:lestari_admin/data/models/user_model.dart';

abstract class BaseUserRepository {
  Future<UserModel?> getUserById(String uid);
  Future<void> updateUser(UserModel userModel);
}