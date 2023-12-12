import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:lestari_admin/app/repositories/animals/animals_repository.dart';
import 'package:lestari_admin/data/models/animal_model.dart';

part 'animals_event.dart';
part 'animals_state.dart';

class AnimalsBloc extends Bloc<AnimalsEvent, AnimalsState> {
  final AnimalsRepository _repository;

  AnimalsBloc(this._repository) : super(AnimalsInitial()) {
    on<GetAnimalsEvent>(_getAnimals);
    on<SearchAnimalsEvent>(_getAnimalsByKeyword);
  }

  Future<void> _getAnimals(GetAnimalsEvent event, Emitter<AnimalsState> emit) async {
    emit(AnimalsLoading());
    try {
      List<AnimalModel> model = await _repository.getAnimals();
      emit(AnimalsLoaded(model));
    } catch (e) {
      emit(AnimalsError(e.toString()));
    }
  }

  Future<void> _getAnimalsByKeyword(SearchAnimalsEvent event, Emitter<AnimalsState> emit) async {
    try {
      List<AnimalModel> model = await _repository.getAnimalsByKeyword(event.keyword);
      emit(AnimalsLoaded(model));
    } catch (e) {
      emit(AnimalsError(e.toString()));
    }
  }
}
