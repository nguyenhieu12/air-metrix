import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dartz/dartz.dart';
import 'package:envi_metrix/core/errors/exceptions.dart';
import 'package:envi_metrix/core/errors/failures.dart';
import 'package:envi_metrix/features/disaster/domain/entities/disaster_entity.dart';
import 'package:envi_metrix/features/disaster/domain/use_cases/get_current_disaster.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'disaster_state.dart';

class DisasterCubit extends Cubit<DisasterState> {
  final GetCurrentDisaster getCurrentDisaster;

  List<DisasterEntity> disasterEnitites = [];

  DisasterCubit({required this.getCurrentDisaster}) : super(DisasterInitial());

  Future<void> getDisaster() async {
    emit(DisasterLoading());

    final connect = await Connectivity().checkConnectivity();

    if (connect == ConnectivityResult.none) {
      emit(const DisasterFailed(errorMessage: 'Lost Internet connection'));
      return;
    }

    final Either<Failure, List<DisasterEntity>> listDisaster =
        await getCurrentDisaster.getDisaster();

    listDisaster.fold(
      (Failure failure) {
        throw ApiException();
      },
      (List<DisasterEntity> listDisasterResponse) async {
        disasterEnitites = listDisasterResponse;
        emit(DisasterSuccess());
      },
    );
  }
}
