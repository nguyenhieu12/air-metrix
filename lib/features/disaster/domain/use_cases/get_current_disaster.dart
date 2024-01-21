import 'package:dartz/dartz.dart';
import 'package:envi_metrix/core/errors/failures.dart';
import 'package:envi_metrix/features/disaster/domain/entities/disaster_entity.dart';
import 'package:envi_metrix/features/disaster/domain/repositories/disaster_repository.dart';

class GetCurrentDisaster {
  final DisasterRepository disasterRepository;

  GetCurrentDisaster({required this.disasterRepository});

  Future<Either<Failure, List<DisasterEntity>>> getDisaster() async {
    return await disasterRepository.getCurrentDisaster();
  }
}