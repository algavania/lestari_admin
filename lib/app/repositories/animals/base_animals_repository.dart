
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lestari_admin/data/models/animal_model.dart';

abstract class BaseAnimalsRepository {
  Future<List<AnimalModel>> getAnimals();
  Future<DocumentReference> addAnimal(AnimalModel animalModel);
  Future<void> updateAnimal(AnimalModel animalModel);
  Future<void> deleteAnimal(String animalId);
  Future<List<AnimalModel>> getAnimalsByKeyword(String keyword);
}
