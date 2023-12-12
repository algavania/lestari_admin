import 'package:lestari_admin/data/models/report_model.dart';

abstract class BaseReportsRepository {
  Future<List<ReportModel>> getReports();
  }
