import 'package:clean_architecture/core/errors/failures.dart';

class AuthFailure implements Failure {
  final String message;

  const AuthFailure(this.message);

  @override
  String toString() => 'AuthFailure(message: $message)';

  @override
  List<Object> get props => [message];

  @override
  bool get stringify => false;
}
