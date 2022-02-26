import 'package:clean_architecture/auth/domain/domain.dart';

class LoginUsecase implements LoginUsecaseContract {
  final AuthRepositoryContract repository;

  LoginUsecase(this.repository);

  @override
  Future<LoggedUserEntity> call(CredentialsParams params) async {
    if (params.email.isEmpty) {
      throw AuthException('Email inválido.');
    }

    if (params.password.isEmpty) {
      throw AuthException('Senha inválida.');
    }

    return await repository.login(params);
  }
}
