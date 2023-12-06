abstract class Failure {
  final String errorMessage;
  const Failure({
    required this.errorMessage,
  });
}

class ApiFailure extends Failure {
  ApiFailure({required super.errorMessage});
}

class CacheFailure extends Failure {
  CacheFailure({required super.errorMessage});
}