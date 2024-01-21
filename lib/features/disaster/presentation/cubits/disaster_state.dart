part of 'disaster_cubit.dart';

sealed class DisasterState extends Equatable {
  const DisasterState();

  @override
  List<Object> get props => [];
}

final class DisasterInitial extends DisasterState {}

final class DisasterLoading extends DisasterState {}

final class DisasterSuccess extends DisasterState {}

final class DisasterFailed extends DisasterState {
  final String errorMessage;

  const DisasterFailed({required this.errorMessage});
}
