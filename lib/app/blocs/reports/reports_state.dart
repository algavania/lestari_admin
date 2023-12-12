part of 'reports_bloc.dart';

abstract class ReportsState extends Equatable {
  const ReportsState();
}

class ReportsError extends ReportsState {
  final String message;

  const ReportsError(this.message);

  @override
  List<Object> get props => [message];
}

class ReportsInitial extends ReportsState {
  @override
  List<Object> get props => [];
}

class ReportsLoading extends ReportsState {
  @override
  List<Object> get props => [];
}

class ReportsLoaded extends ReportsState {
  final List<ReportModel> reportModels;

  const ReportsLoaded(this.reportModels);

  @override
  List<Object> get props => [reportModels];
}

