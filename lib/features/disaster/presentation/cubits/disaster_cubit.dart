import 'dart:math' as math;
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dartz/dartz.dart';
import 'package:envi_metrix/core/errors/exceptions.dart';
import 'package:envi_metrix/core/errors/failures.dart';
import 'package:envi_metrix/features/disaster/domain/entities/disaster_entity.dart';
import 'package:envi_metrix/features/disaster/domain/use_cases/get_current_disaster.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'disaster_state.dart';

class DisasterCubit extends Cubit<DisasterState> {
  final GetCurrentDisaster getCurrentDisaster;

  Map<String, int> disasterQuantity = {};
  String maxDisaster = '';

  int totalDisasters = 0;

  List<Color> disastersChartColor = [];

  DisasterCubit({required this.getCurrentDisaster}) : super(DisasterLoading());

  Future<void> getDisaster() async {
    emit(DisasterLoading());

    final connect = await Connectivity().checkConnectivity();

    if (connect == ConnectivityResult.none) {
      await Future.delayed(const Duration(milliseconds: 750));
      emit(const DisasterFailed(errorMessage: 'Lost Internet connection'));
      return;
    }

    final Either<Failure, List<DisasterEntity>> listDisaster =
        await getCurrentDisaster.getDisaster();

    listDisaster.fold(
      (Failure failure) {
        emit(const DisasterFailed(errorMessage: 'Cannot get NASA EONET API!'));

        throw ApiException();
      },
      (List<DisasterEntity> listDisasterResponse) async {
        List<String> disasterId =
            listDisasterResponse.map((e) => e.categories.id).toList();

        disasterQuantity = createMap(disasterId);

        getMaxDisasterInfo(disasterQuantity);

        disasterQuantity.forEach((key, value) => totalDisasters += value);

        disastersChartColor.clear();

        disasterQuantity.forEach((key, value) => disastersChartColor.add(
            Color((math.Random().nextDouble() * 0xFFFFFF).toInt())
                .withOpacity(1.0)));
                
        emit(DisasterSuccess(entities: listDisasterResponse));
      },
    );
  }

  Map<String, int> createMap(List<String> list) {
    Map<String, int> mapOccurrences = {};

    for (var element in list) {
      if (mapOccurrences.containsKey(element)) {
        mapOccurrences[element] = mapOccurrences[element]! + 1;
      } else {
        mapOccurrences[element] = 1;
      }
    }

    return mapOccurrences;
  }

  void getMaxDisasterInfo(Map<String, dynamic> mapData) {
    String keyResult = '';
    int valueResult = 0;

    mapData.forEach((key, value) {
      if (value > valueResult) {
        keyResult = key;
        valueResult = value;
      }
    });

    maxDisaster = keyResult;
  }
}
