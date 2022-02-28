import 'package:clean_architecture/app/auth/domain/domain.dart';
import 'package:clean_architecture/core/errors/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final loginUsecase = LoginUseCase(AuthRepositoryMock());

  group('LoginUsecase', () {
    test('é obrigatório informar um email', () async {
      final result = await loginUsecase(const CredentialsParams(email: '', password: '123'));

      expect(result.isLeft(), true);
      expect(result, const Left(AuthFailure('Email inválido.')));
    });

    test('é obrigatório informar uma senha', () async {
      final result = await loginUsecase(const CredentialsParams(email: 'Teste', password: ''));

      expect(result.isLeft(), true);
      expect(result, const Left(AuthFailure('Senha inválida.')));
    });

    test('o login do usuário é efetuado corretamente', () async {
      final result = await loginUsecase(const CredentialsParams(email: 'teste@teste.com', password: '123'));

      expect(result.isRight(), true);
      expect(result, const Right(LoggedUserEntity(email: 'teste@teste.com', name: 'Teste')));
    });

    test('se o repositório falhar, as exceções são devidamente tratadas', () async {
      final result = await loginUsecase(const CredentialsParams(email: 'Error', password: '123'));

      expect(result.isLeft(), true);
      expect(result, const Left(AuthFailure('Repository error.')));
    });
  });
}

class AuthRepositoryMock implements AuthRepositoryContract {
  @override
  Future<Either<Failure, LoggedUserEntity>> login(CredentialsParams params) async {
    if (params.email == 'Error') {
      return const Left(AuthFailure('Repository error.'));
    }

    return Right(LoggedUserEntity(name: 'Teste', email: params.email));
  }
}
