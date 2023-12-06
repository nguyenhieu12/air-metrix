part of 'air_pollution_cubit.dart';

sealed class AirPollutionState extends Equatable {
  const AirPollutionState();

  @override
  List<Object> get props => [];
}

final class AirPollutionInitial extends AirPollutionState {}

final class AirPollutionLoading extends AirPollutionState {}

final class AirPollutionLoaded extends AirPollutionState {
  final AirPollutionEntity airPollutionEntity;

  const AirPollutionLoaded({required this.airPollutionEntity});

  @override
  List<Object> get props => [airPollutionEntity];
}

final class AirPollutionError extends AirPollutionState {
  final String errorMessage;

  const AirPollutionError({required this.errorMessage});
}
