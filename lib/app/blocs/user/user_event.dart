part of 'user_bloc.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();
}

class GetUserByIdEvent extends UserEvent {
  final String uid;

  const GetUserByIdEvent(this.uid);

  @override
  List<Object?> get props => [uid];
}