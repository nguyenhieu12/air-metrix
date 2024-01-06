part of 'air_pollution_cubit.dart';

sealed class AirPollutionState extends Equatable {
  const AirPollutionState();

  @override
  List<Object> get props => [];
}

final class AirPollutionInitial extends AirPollutionState {}

final class AirPollutionLoading extends AirPollutionState {}

final class AirPollutionSuccess extends AirPollutionState {
  final AirPollutionEntity airPollutionEntity;

  const AirPollutionSuccess({required this.airPollutionEntity});
}

final class AirPollutionFailed extends AirPollutionState {
  final String errorMessage;

  const AirPollutionFailed({required this.errorMessage});
}
