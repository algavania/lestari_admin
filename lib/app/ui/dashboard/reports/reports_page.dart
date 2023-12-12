import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lestari_admin/app/blocs/reports/reports_bloc.dart';
import 'package:lestari_admin/app/common/color_values.dart';
import 'package:lestari_admin/app/repositories/repositories.dart';
import 'package:lestari_admin/data/models/report_model.dart';
import 'package:lestari_admin/widgets/custom_loading.dart';
import 'package:lestari_admin/widgets/custom_report_card.dart';


class ReportsPage extends StatefulWidget {
  const ReportsPage({Key? key}) : super(key: key);

  @override
  State<ReportsPage> createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage> {
  List<ReportModel> _reportModels = [];
  bool isOpenExist = false;
  bool isClosedExist = false;

  @override
  void initState() {
    // TODO: implement build
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    const int tabsCount = 2;
    return BlocProvider(
      create: (context) =>
      ReportsBloc(RepositoryProvider.of<ReportsRepository>(context))
        ..add(const GetReportsEvent()),
      child: DefaultTabController(
        initialIndex: 1,
        length: tabsCount,
        child: Column(
          children: [
            TabBar(
                labelStyle: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500),
                indicatorColor: ColorValues.primaryYellow,
                unselectedLabelColor: ColorValues.grey,
                labelColor: ColorValues.primaryYellow,
                tabs: const <Widget>[
                  Tab(text: 'Terbuka'),
                  Tab(text: 'Riwayat'),
                ]
            ),
            Expanded(
              child: BlocBuilder<ReportsBloc, ReportsState>(
                builder: (context, state) {
                  if (state is ReportsLoading) {
                    return const CustomLoading();
                  }
                  if (state is ReportsInitial) {
                    return const SizedBox.shrink();
                  }
                  if (state is ReportsError) {
                    return Center(child: Text(state.message));
                  }
                  if (state is ReportsLoaded) {
                    _reportModels = state.reportModels;
                    print('lll ${_reportModels.length}');
                    return _buildPage();
                  }
                  return Container();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPage() {
    return TabBarView(
      children: <Widget>[
        _buildList(true),
        _buildList(false),
      ],
    );
  }

  Widget _buildList(bool isOpenIssue) {
    return _reportModels.isNotEmpty
      ? ListView.builder(
        primary: false,
        shrinkWrap: true,
        itemCount: _reportModels.length,
        itemBuilder: (_, i) {
          return _reportModels[i].isOpenIssue == isOpenIssue
              ?  CustomReportCard(reportModel: _reportModels[i], index: 1)
              : const SizedBox.shrink();
        },
      )
      : const Center(child: Text('Belum ada laporan untuk saat ini.'));
  }
}

