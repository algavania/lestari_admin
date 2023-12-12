part of 'reports_bloc.dart';

abstract class ReportsEvent extends Equatable {
  const ReportsEvent();
}

class GetReportsEvent extends ReportsEvent {
  const GetReportsEvent();

  @override
  List<Object?> get props => [];
}