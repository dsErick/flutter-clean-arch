import 'package:equatable/equatable.dart';

class LoggedUserEntity extends Equatable {
  final String name;
  final String email;

  const LoggedUserEntity({ required this.name, required this.email });

  @override
  List<Object> get props => [name, email];
}
