import 'package:equatable/equatable.dart';

abstract class UseCase<Entity, Params> {
  Future<Entity> call(Params params);
}

class NoParams extends Equatable {
  const NoParams();

  @override
  List<Object> get props => [];
}
