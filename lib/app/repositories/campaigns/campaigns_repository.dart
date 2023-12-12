import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:lestari_admin/app/repositories/campaigns/base_campaigns_repository.dart';
import 'package:lestari_admin/data/models/campaign_model.dart';

class CampaignsRepository extends BaseCampaignsRepository {
  CollectionReference campaignsRef =
      FirebaseFirestore.instance.collection('campaigns');

  @override
  Future<List<CampaignModel>> getCampaigns(String status) async {
    List<CampaignModel> models = [];
    try {
      QuerySnapshot snapshot = await campaignsRef
          .where('status', isEqualTo: status)
          .orderBy('date', descending: false)
          .get();

      for (var element in snapshot.docs) {
        Map<String, dynamic> map = element.data() as Map<String, dynamic>;
        map['id'] = element.id;
        CampaignModel model = CampaignModel.fromMap(map);
        models.add(model);
      }
      return models;
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Future<void> deleteCampaign(String campaignId) async {
    await campaignsRef.doc(campaignId).delete();
    await FirebaseStorage.instance
        .ref('campaigns/$campaignId')
        .listAll()
        .then((value) {
      for (Reference element in value.items) {
        FirebaseStorage.instance.ref(element.fullPath).delete();
      }
    });
  }

  @override
  Future<void> updateCampaign(CampaignModel campaignModel) async {
    await campaignsRef.doc(campaignModel.id).update(campaignModel.toMap());
  }

  @override
  Future<List<CampaignModel>> getCampaignsByKeyword(String keyword, String status) async {
    List<CampaignModel> models = [];
    keyword = keyword.toUpperCase();
    try {
      QuerySnapshot snapshot;
      snapshot = await FirebaseFirestore.instance
          .collection('campaigns')
          .where('searchable_title', isGreaterThanOrEqualTo: keyword)
          .where('searchable_title', isLessThanOrEqualTo: "$keyword\uf7ff")
          .where('status', isEqualTo: status)
          .get();
      for (var element in snapshot.docs) {
        Map<String, dynamic> map = element.data() as Map<String, dynamic>;
        map['id'] = element.id;
        CampaignModel model = CampaignModel.fromMap(map);
        models.add(model);
      }
      return models;
    } catch (e) {
      throw e.toString();
    }
  }
}
