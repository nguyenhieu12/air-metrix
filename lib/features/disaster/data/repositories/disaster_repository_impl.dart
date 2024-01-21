import 'package:dartz/dartz.dart';
import 'package:envi_metrix/core/errors/exceptions.dart';
import 'package:envi_metrix/core/errors/failures.dart';
import 'package:envi_metrix/features/disaster/data/data_sources/disaster_remote_datasource.dart';
import 'package:envi_metrix/features/disaster/domain/entities/disaster_entity.dart';
import 'package:envi_metrix/features/disaster/domain/repositories/disaster_repository.dart';

class DisasterRepositoryImpl implements DisasterRepository {
  final DisasterRemoteDatasource disasterRemoteDatasource;

  DisasterRepositoryImpl({required this.disasterRemoteDatasource});

  @override
  Future<Either<Failure, List<DisasterEntity>>> getCurrentDisaster() async {
    try {
      final remoteDisaster =
          await disasterRemoteDatasource.getCurrentDisaster();

      return Right(remoteDisaster);
    } on ApiException {
      return Left(ApiFailure(errorMessage: 'Cannot call NASA EONET API'));
    }
  }
}
