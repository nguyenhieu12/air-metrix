part of 'air_compare_cubit.dart';

sealed class AirCompareState extends Equatable {
  const AirCompareState();

  @override
  List<Object> get props => [];
}

final class AirCompareInitial extends AirCompareState {}

final class AirCompareLoading extends AirCompareState {}

final class AirCompareSuccess extends AirCompareState {}

final class AirCompareFailed extends AirCompareState {}
