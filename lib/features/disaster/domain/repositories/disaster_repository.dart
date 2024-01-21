import 'package:dartz/dartz.dart';
import 'package:envi_metrix/core/errors/failures.dart';
import 'package:envi_metrix/features/disaster/domain/entities/disaster_entity.dart';

abstract class DisasterRepository {
  Future<Either<Failure, List<DisasterEntity>>> getCurrentDisaster();
}