import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lestari_admin/app/repositories/reports/base_reports_repository.dart';
import 'package:lestari_admin/data/models/report_model.dart';

class ReportsRepository extends BaseReportsRepository {
  CollectionReference reportsRef = FirebaseFirestore.instance.collection('reports');

  @override
  Future<List<ReportModel>> getReports() async {
    List<ReportModel> models = [];
    try {
      QuerySnapshot snapshot = await reportsRef.orderBy('created_at', descending: false).get();

      for (var element in snapshot.docs) {
        Map<String, dynamic> map = element.data() as Map<String, dynamic>;
        map['id'] = element.id;
        ReportModel model = ReportModel.fromMap(map);
        models.add(model);
      }
      return models;
    } catch (e) {
      throw e.toString();
    }
  }
}