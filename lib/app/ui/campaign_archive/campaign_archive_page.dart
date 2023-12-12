import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lestari_admin/app/blocs/campaigns/campaigns_bloc.dart';
import 'package:lestari_admin/app/common/shared_code.dart';
import 'package:lestari_admin/app/repositories/repositories.dart';
import 'package:lestari_admin/data/models/campaign_model.dart';
import 'package:lestari_admin/widgets/custom_campaign_card.dart';
import 'package:lestari_admin/widgets/custom_loading.dart';
import 'package:sizer/sizer.dart';

class CampaignArchivePage extends StatefulWidget {
  const CampaignArchivePage({Key? key}) : super(key: key);

  @override
  State<CampaignArchivePage> createState() => _CampaignArchivePageState();
}

class _CampaignArchivePageState extends State<CampaignArchivePage> {
  bool _isSearching = false;
  late BuildContext _context;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: BlocProvider(
        create: (context) =>
        CampaignsBloc(RepositoryProvider.of<CampaignsRepository>(context))
          ..add(const GetCampaignsEvent(status: 'archived')),
        child: RefreshIndicator(
          onRefresh: () async {
            await _refreshPage();
          },
          child: BlocBuilder<CampaignsBloc, CampaignsState>(
              builder: (context, state) {
                _context = context;
                if (state is CampaignsLoading) {
                  if (!_isSearching) {
                    return const CustomLoading();
                  } else {
                    _isSearching = false;
                    return const SizedBox.shrink();
                  }
                }
                if (state is CampaignsInitial) {
                  return const SizedBox.shrink();
                }
                if (state is CampaignsError) {
                  return Center(child: Text(state.message));
                }
                if (state is CampaignsLoaded) {
                  return _buildCampaignGrid(state.campaignModels);
                }
                return Container();
              }
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return SharedCode.buildSearchAppBar(context: context, searchHint: 'Cari kampanye', title: 'Arsip Kampanye', isWithLeading: true, onChanged: (s) {
      _isSearching = true;
      if (s == null || s.isEmpty) {
        _refreshPage();
      } else {
        BlocProvider.of<CampaignsBloc>(_context).add(SearchCampaignsEvent(keyword: s, status: 'archived'));
      }
    });
  }

  Widget _buildCampaignGrid(List<CampaignModel> campaignModels) {
    return GridView.builder(
      padding: SharedCode.defaultPagePadding,
      itemCount: campaignModels.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 48.w / 43.h, mainAxisSpacing: 8.0, crossAxisSpacing: 4.0),
      itemBuilder: (BuildContext context, int index) {
        return CustomCampaignCard(campaignModel: campaignModels[index]);
      },
    );
  }

  Future<void> _refreshPage() async {
    BlocProvider.of<CampaignsBloc>(_context).add(const GetCampaignsEvent(status: 'archived'));
  }
}
