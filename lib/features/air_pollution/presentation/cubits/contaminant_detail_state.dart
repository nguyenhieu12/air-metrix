part of 'contaminant_detail_cubit.dart';

sealed class ContaminantDetailState extends Equatable {
  const ContaminantDetailState();

  @override
  List<Object> get props => [];
}

final class ContaminantDetailInitial extends ContaminantDetailState {}

final class ContaminantDetailLoading extends ContaminantDetailState {}

final class ContaminantDetailSuccess extends ContaminantDetailState {
  final String outputText;

  const ContaminantDetailSuccess({required this.outputText});
}

final class ContaminantDetailFailed extends ContaminantDetailState {
  final String errorText;

  const ContaminantDetailFailed({required this.errorText});
}
