import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'contaminant_detail_state.dart';

class ContaminantDetailCubit extends Cubit<ContaminantDetailState> {
  ContaminantDetailCubit() : super(ContaminantDetailLoading());

  Future<void> getContaminantDetailInfo(String contaminantName) async {
    emit(ContaminantDetailLoading());

    String markdownResult = await rootBundle
        .loadString('./assets/data/${contaminantName}_detail_info.md');

    if (markdownResult.isNotEmpty) {
      emit(ContaminantDetailSuccess(outputText: markdownResult));
    } else {
      emit(const ContaminantDetailFailed(
          errorText: 'Cannot load contaminant detail information'));
    }
  }
}
