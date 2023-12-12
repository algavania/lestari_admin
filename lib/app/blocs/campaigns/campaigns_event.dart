part of 'campaigns_bloc.dart';

abstract class CampaignsEvent extends Equatable {
  const CampaignsEvent();
}

class GetCampaignsEvent extends CampaignsEvent {
  const GetCampaignsEvent({required this.status});
  final String status;

  @override
  List<Object?> get props => [status];

}

class SearchCampaignsEvent extends CampaignsEvent {
  const SearchCampaignsEvent({required this.keyword, required this.status});
  final String keyword, status;

  @override
  List<Object?> get props => [keyword, status];
}
