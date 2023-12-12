import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:lestari_admin/app/repositories/reports/reports_repository.dart';
import 'package:lestari_admin/data/models/report_model.dart';

part 'reports_event.dart';
part 'reports_state.dart';

class ReportsBloc extends Bloc<ReportsEvent, ReportsState> {
  final ReportsRepository _repository;

  ReportsBloc(this._repository) : super(ReportsInitial()) {
    on<GetReportsEvent>(_getReports);
  }

  Future<void> _getReports(GetReportsEvent event, Emitter<ReportsState> emit) async {
    emit(ReportsLoading());
    try {
      List<ReportModel> model = await _repository.getReports();
      emit(ReportsLoaded(model));
    } catch (e) {
      emit(ReportsError(e.toString()));
    }
  }
}
