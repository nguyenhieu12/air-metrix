part of 'dashboard_cubit.dart';

sealed class DashboardState extends Equatable {
  const DashboardState();

  @override
  List<Object> get props => [];
}

final class DashboardInitial extends DashboardState {}

final class DashboardLoading extends DashboardState {}

final class DashboardSuccess extends DashboardState {
  final AirPollutionEntity airPollutionEntity;
  final List<DisasterEntity> listDisasterEntity;
  final Address address;

  const DashboardSuccess(
      {required this.airPollutionEntity,
      required this.listDisasterEntity,
      required this.address});
}

final class DashboardFailed extends DashboardState {
  final String errorMessage;

  const DashboardFailed({required this.errorMessage});
}
