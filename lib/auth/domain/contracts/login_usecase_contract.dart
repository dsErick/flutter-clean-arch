import 'package:clean_architecture/auth/domain/entities/logged_user_entity.dart';

abstract class LoginUsecaseContract {
  Future<LoggedUserEntity> call(CredentialsParams params);
}

class CredentialsParams {
  final String email;
  final String password;

  CredentialsParams({ required this.email, required this.password });
}
