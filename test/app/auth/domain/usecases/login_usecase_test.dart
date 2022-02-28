import 'package:clean_architecture/app/auth/domain/domain.dart';
import 'package:clean_architecture/core/errors/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class AuthRepositoryMock extends Mock implements AuthRepositoryContract {}

void main() {
  final repository = AuthRepositoryMock();
  final loginUsecase = LoginUseCase(repository);

  const params = CredentialsParams(email: 'teste@teste.com', password: '123');
  const entity = LoggedUserEntity(email: 'teste@teste.com', name: 'Teste');

  group('LoginUsecase', () {
    test('é obrigatório informar um email', () async {
      final result = await loginUsecase(const CredentialsParams(email: '', password: '123'));

      expect(result, const Left(AuthFailure('Email inválido.')));
    });

    test('é obrigatório informar uma senha', () async {
      final result = await loginUsecase(const CredentialsParams(email: 'Teste', password: ''));

      expect(result, const Left(AuthFailure('Senha inválida.')));
    });

    test('o login do usuário é efetuado corretamente', () async {
      when(() => repository.login(params)).thenAnswer((_) async => const Right(entity));

      final result = await loginUsecase(params);

      expect(result, const Right(entity));
      verify(() => repository.login(params)).called(1);
    });

    test('as exceções tratadas no repositório são retornadas corretamente', () async {
      when(() => repository.login(params)).thenAnswer((_) async => const Left(ServerFailure()));

      final result = await loginUsecase(params);

      expect(result, const Left(ServerFailure()));
      verify(() => repository.login(params)).called(1);
    });
  });
}
