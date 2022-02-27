import 'package:clean_architecture/app/auth/domain/domain.dart';
import 'package:clean_architecture/core/usecases/usecase.dart';
import 'package:equatable/equatable.dart';

class LoginUseCase implements UseCase<LoggedUserEntity, CredentialsParams> {
  final AuthRepositoryContract repository;

  const LoginUseCase(this.repository);

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

class CredentialsParams extends Equatable {
  final String email;
  final String password;

  const CredentialsParams({ required this.email, required this.password });

  @override
  List<Object> get props => [email, password];
}
