import 'package:dependencies/dependencies.dart' show Equatable;

class Genre extends Equatable {
  const Genre({required this.id, required this.name});

  final int id;
  final String name;

  @override
  List<Object> get props => [id, name];
}
