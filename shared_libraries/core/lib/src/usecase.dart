import 'package:dependencies/dependencies.dart';

abstract class UseCase<Result, Params> {
  Result call(Params params);
}

class NoParams extends Equatable {
  const NoParams();

  @override
  List<Object?> get props => [];
}
