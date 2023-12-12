part of 'campaigns_bloc.dart';

abstract class CampaignsState extends Equatable {
  const CampaignsState();
}

class CampaignsInitial extends CampaignsState {
  @override
  List<Object> get props => [];
}

class CampaignsLoading extends CampaignsState {
  @override
  List<Object> get props => [];
}

class CampaignsLoaded extends CampaignsState {
  final List<CampaignModel> campaignModels;

  const CampaignsLoaded(this.campaignModels);

  @override
  List<Object> get props => [campaignModels];
}

class CampaignsError extends CampaignsState {
  final String message;

  const CampaignsError(this.message);

  @override
  List<Object> get props => [message];
}