import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lestari_admin/app/blocs/campaigns/campaigns_bloc.dart';
import 'package:lestari_admin/app/common/color_values.dart';
import 'package:lestari_admin/app/common/shared_code.dart';
import 'package:lestari_admin/app/repositories/campaigns/campaigns_repository.dart';
import 'package:lestari_admin/data/models/campaign_model.dart';
import 'package:lestari_admin/widgets/custom_campaign_card.dart';
import 'package:lestari_admin/widgets/custom_loading.dart';
import 'package:lestari_admin/widgets/custom_text_field.dart';
import 'package:sizer/sizer.dart';

class CampaignsPage extends StatefulWidget {
  const CampaignsPage({Key? key}) : super(key: key);

  @override
  State<CampaignsPage> createState() => _CampaignsPageState();
}

class _CampaignsPageState extends State<CampaignsPage> with TickerProviderStateMixin {
  final ValueNotifier<int> _currentIndex = ValueNotifier(0);
  bool _isSearching = false;
  late ValueNotifier<BuildContext> _approvalContext, _onlineContext;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _approvalContext = ValueNotifier(context);
    _onlineContext = ValueNotifier(context);
    _tabController = TabController(vsync: this, length: 2);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildSearchAppBar(),
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(color: Colors.white, boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                spreadRadius: 0,
                blurRadius: 1,
                offset: const Offset(0, 2.5), // changes position of shadow
              ),
            ]),
            child: TabBar(
              controller: _tabController,
              onTap: (i) {
                _currentIndex.value = i;
              },
              labelStyle: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500),
              indicatorColor: ColorValues.primaryYellow,
              unselectedLabelColor: ColorValues.grey,
              labelColor: ColorValues.primaryYellow,
              tabs: const [
                Tab(text: 'Menunggu Approval'),
                Tab(text: 'Online'),
              ]
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                CampaignList(listContext: _approvalContext, status: 'waiting'),
                CampaignList(listContext: _onlineContext, status: 'online'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildList(ValueNotifier<BuildContext> listContext, String status) {
    return BlocProvider(
      create: (context) =>
      CampaignsBloc(RepositoryProvider.of<CampaignsRepository>(context))
        ..add(GetCampaignsEvent(status: status)),
      child: RefreshIndicator(
        onRefresh: () async {
          await _refreshPage(listContext.value, status);
        },
        child: BlocBuilder<CampaignsBloc, CampaignsState>(
            builder: (context, state) {
              SchedulerBinding.instance.addPostFrameCallback((_) {
                listContext.value = context;
              });
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
    );
  }

  Widget _buildCampaignGrid(List<CampaignModel> campaignModels) {
    return (campaignModels.isNotEmpty)
        ? GridView.builder(
          padding: SharedCode.defaultPagePadding,
          itemCount: campaignModels.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 48.w / 43.h, mainAxisSpacing: 8.0, crossAxisSpacing: 4.0),
          itemBuilder: (BuildContext context, int index) {
            return CustomCampaignCard(campaignModel: campaignModels[index]);
          },
        )
        : const Center(child: Text('Belum ada kampanye diunggah.'));
  }

  Future<void> _refreshPage(BuildContext listContext, String status) async {
    BlocProvider.of<CampaignsBloc>(listContext).add(GetCampaignsEvent(status: status));
  }

  AppBar _buildSearchAppBar() {
    return AppBar(
      toolbarHeight: 105,
      elevation: 0.0,
      flexibleSpace: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 0.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('List Kampanye', style: GoogleFonts.poppins(fontWeight: FontWeight.w500, fontSize: 18)),
              const SizedBox(height: 10.0),
              ValueListenableBuilder(
                valueListenable: _currentIndex,
                builder: (_, __, ___) {
                  return _currentIndex.value == 0
                      ? ValueListenableBuilder(
                          valueListenable: _approvalContext,
                          builder: (_, __, ___) {
                            return CustomTextField(
                              verticalPadding: 10.0,
                              prefixIcon: const Icon(Icons.search, size: 22.0),
                              hintText: 'Cari kampanye',
                              fontSize: 14,
                              onChanged: (s) {
                                _isSearching = true;
                                (s == null || s.isEmpty) ? _refreshPage(_approvalContext.value, 'waiting') : BlocProvider.of<CampaignsBloc>(_approvalContext.value).add(SearchCampaignsEvent(keyword: s, status: 'waiting'));
                              },
                            );
                          }
                      )
                      : ValueListenableBuilder(
                          valueListenable: _approvalContext,
                          builder: (_, __, ___) {
                            return CustomTextField(
                              verticalPadding: 10.0,
                              prefixIcon: const Icon(Icons.search, size: 22.0),
                              hintText: 'Cari kampanye',
                              fontSize: 14,
                              onChanged: (s) {
                                _isSearching = true;
                                (s == null || s.isEmpty) ? _refreshPage(_onlineContext.value, 'online') : BlocProvider.of<CampaignsBloc>(_onlineContext.value).add(SearchCampaignsEvent(keyword: s, status: 'online'));
                              },
                            );
                          }
                      );
                }
              )
            ],
          ),
        ),
      ),
    );
  }
}

class CampaignList extends StatefulWidget {
  final String status;
  final ValueNotifier<BuildContext> listContext;

  const CampaignList({Key? key, required this.listContext, required this.status}) : super(key: key);

  @override
  State<CampaignList> createState() => _CampaignListState();
}

class _CampaignListState extends State<CampaignList> with AutomaticKeepAliveClientMixin<CampaignList> {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return _CampaignsPageState()._buildList(widget.listContext, widget.status);
  }
}

