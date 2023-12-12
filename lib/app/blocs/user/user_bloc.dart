import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:lestari_admin/app/repositories/user/user_repository.dart';
import 'package:lestari_admin/data/models/user_model.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository _repository;

  UserBloc(this._repository) : super(UserInitial()) {
    on<GetUserByIdEvent>(_getUserById);
  }

  Future<void> _getUserById(GetUserByIdEvent event, Emitter<UserState> emit) async {
    emit(UserLoading());
    try {
      UserModel? userModel = await _repository.getUserById(event.uid);
      if (userModel != null) emit(UserLoaded(userModel));
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }
}
