import 'package:dependencies/dependencies.dart';

abstract class Failure extends Equatable {
  const Failure(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}

class ServerFailure extends Failure {
  ServerFailure(super.message);
}

class ConnectionFailure extends Failure {
  ConnectionFailure(super.message);
}

class CacheFailure extends Failure {
  CacheFailure(super.message);
}

class DatabaseFailure extends Failure {
  DatabaseFailure(super.message);
}
