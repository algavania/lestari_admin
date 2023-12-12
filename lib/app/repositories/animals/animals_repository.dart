import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:lestari_admin/app/repositories/animals/base_animals_repository.dart';
import 'package:lestari_admin/data/models/animal_model.dart';

class AnimalsRepository extends BaseAnimalsRepository {
  CollectionReference animalsRef = FirebaseFirestore.instance.collection('animals');

  @override
  Future<List<AnimalModel>> getAnimals() async {
    List<AnimalModel> models = [];
    try {
      QuerySnapshot snapshot = await animalsRef.orderBy('updated_at', descending: true).get();
      for (var element in snapshot.docs) {
        Map<String, dynamic> map = element.data() as Map<String, dynamic>;
        map['id'] = element.id;
        AnimalModel model = AnimalModel.fromMap(map);
        models.add(model);
      }
      return models;
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Future<DocumentReference> addAnimal(AnimalModel animalModel) async {
    Map<String, Object?> json = animalModel.toMap();
    return await animalsRef.add(json);
  }

  @override
  Future<void> updateAnimal(AnimalModel animalModel) async {
    await animalsRef.doc(animalModel.id).update(animalModel.toMap());
  }

  @override
  Future<void> deleteAnimal(String animalId) async {
    await animalsRef.doc(animalId).delete();
    await FirebaseStorage.instance.ref('animals/$animalId').listAll().then((value) {
      for (Reference element in value.items) {
        FirebaseStorage.instance.ref(element.fullPath).delete();
      }
    });
  }

  @override
  Future<List<AnimalModel>> getAnimalsByKeyword(String keyword) async {
    List<AnimalModel> models = [];
    keyword = keyword.toUpperCase();
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('animals')
          .where('searchable_name', isGreaterThanOrEqualTo: keyword)
          .where('searchable_name', isLessThanOrEqualTo: "$keyword\uf7ff")
          .get();
      for (var element in snapshot.docs) {
        Map<String, dynamic> map = element.data() as Map<String, dynamic>;
        map['id'] = element.id;
        AnimalModel model = AnimalModel.fromMap(map);
        models.add(model);
      }
      return models;
    } catch (e) {
      throw e.toString();
    }
  }
}