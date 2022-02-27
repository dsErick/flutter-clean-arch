import 'package:clean_architecture/app/auth/domain/domain.dart';

abstract class LoginUsecaseContract {
  Future<LoggedUserEntity> call(CredentialsParams params);
}

class LoginUsecase implements LoginUsecaseContract {
  final AuthRepositoryContract repository;

  const LoginUsecase(this.repository);

  @override
  Future<LoggedUserEntity> call(CredentialsParams params) async {
    if (params.email.isEmpty) {
      throw const AuthException('Email inválido.');
    }

    if (params.password.isEmpty) {
      throw const AuthException('Senha inválida.');
    }

    try {
      return await repository.login(params);
    } catch (e) {
      throw const AuthException('Repository error.');
    }
  }
}

class CredentialsParams {
  final String email;
  final String password;

  const CredentialsParams({ required this.email, required this.password });
}
