import 'package:lestari_admin/data/models/campaign_model.dart';

abstract class BaseCampaignsRepository {
  Future<List<CampaignModel>> getCampaigns(String status);
  Future<List<CampaignModel>> getCampaignsByKeyword(String keyword, String status);
  Future<void> deleteCampaign(String campaignId);
  Future<void> updateCampaign(CampaignModel campaignModel);
}
