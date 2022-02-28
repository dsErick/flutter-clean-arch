import 'package:clean_architecture/app/auth/domain/domain.dart';
import 'package:clean_architecture/core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

abstract class LoginUseCaseContract implements UseCase<LoggedUserEntity, CredentialsParams> {}

class LoginUseCase implements LoginUseCaseContract {
  final AuthRepositoryContract repository;

  const LoginUseCase(this.repository);

  @override
  Future<Either<Failure, LoggedUserEntity>> call(CredentialsParams params) async {
    if (params.email.isEmpty) {
      return const Left(AuthFailure('Email inválido.'));
    }

    if (params.password.isEmpty) {
      return const Left(AuthFailure('Senha inválida.'));
    }

    return await repository.login(params);
  }
}

class CredentialsParams extends Equatable {
  final String email;
  final String password;

  const CredentialsParams({ required this.email, required this.password });

  @override
  List<Object> get props => [email, password];
}
