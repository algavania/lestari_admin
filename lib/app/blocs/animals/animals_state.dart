part of 'animals_bloc.dart';

abstract class AnimalsState extends Equatable {
  const AnimalsState();
}

class AnimalsInitial extends AnimalsState {
  @override
  List<Object> get props => [];
}

class AnimalsLoading extends AnimalsState {
  @override
  List<Object> get props => [];
}

class AnimalsLoaded extends AnimalsState {
  final List<AnimalModel> animalModels;

  const AnimalsLoaded(this.animalModels);

  @override
  List<Object> get props => [animalModels];
}

class AnimalsError extends AnimalsState {
  final String message;

  const AnimalsError(this.message);

  @override
  List<Object> get props => [message];
}