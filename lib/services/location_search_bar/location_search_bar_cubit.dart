import 'package:envi_metrix/features/air_pollution/presentation/cubits/air_pollution_cubit.dart';
import 'package:envi_metrix/features/app/cubits/app_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'location_search_bar_state.dart';

class LocationSearchBarCubit extends Cubit<LocationSearchBarState> {
  LocationSearchBarCubit() : super(LocationSearchBarInitial());

  Future<void> handleSearchByName(AirPollutionCubit airPollutionCubit,
      AppCubit appCubit, String selectedText) async {
    emit(LocationSearchBarLoading());

    airPollutionCubit.currentLocationName = selectedText;

    Map<String, dynamic> coordinatesData = appCubit.cityData[selectedText];

    airPollutionCubit
        .fetchAirPollutionData(double.parse(coordinatesData['lat']),
            double.parse(coordinatesData['lon']), false)
        .then((value) => emit(LocationSearchBarSuccess()));
  }
}
