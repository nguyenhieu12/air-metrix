import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_gemini/flutter_gemini.dart';

part 'contaminant_detail_state.dart';

class ContaminantDetailCubit extends Cubit<ContaminantDetailState> {
  ContaminantDetailCubit() : super(ContaminantDetailLoading());

  final Gemini gemini = Gemini.instance;

  void getContaminantDetailInfo(String contaminantName) {
    emit(ContaminantDetailLoading());

    gemini
        .text(
            "details about $contaminantName including: concept, origin, harmful effects and prevention")
        .then((value) =>
            ContaminantDetailSuccess(outputText: value?.output ?? ''))
        // ignore: invalid_return_type_for_catch_error
        .catchError((e) => const ContaminantDetailFailed(
            errorText: 'Error when get contaminant detail information'));
  }
}
