part of 'animals_bloc.dart';

abstract class AnimalsEvent extends Equatable {
  const AnimalsEvent();
}

class GetAnimalsEvent extends AnimalsEvent {
  const GetAnimalsEvent();

  @override
  List<Object?> get props => [];
}

class SearchAnimalsEvent extends AnimalsEvent {
  const SearchAnimalsEvent(this.keyword);
  final String keyword;

  @override
  List<Object?> get props => [keyword];
}