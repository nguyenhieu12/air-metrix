part of 'location_search_bar_cubit.dart';

sealed class LocationSearchBarState extends Equatable {
  const LocationSearchBarState();

  @override
  List<Object> get props => [];
}

final class LocationSearchBarInitial extends LocationSearchBarState {}

final class LocationSearchBarLoading extends LocationSearchBarState {}

final class LocationSearchBarSuccess extends LocationSearchBarState {}

final class LocationSearchBarFailed extends LocationSearchBarState {}
