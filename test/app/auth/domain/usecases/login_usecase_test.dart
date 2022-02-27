import 'package:clean_architecture/app/auth/domain/domain.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final loginUsecase = LoginUsecase(AuthRepositoryMock());

  group('LoginUsecase', () {
    test('é obrigatório informar um email', () {
      final result = loginUsecase(const CredentialsParams(email: '', password: '123'));

      expect(() async => await result, throwsA(
        isA<AuthException>().having((e) => e.message, 'message', 'Email inválido.')
      ));
    });

    test('é obrigatório informar uma senha', () {
      final result = loginUsecase(const CredentialsParams(email: 'Teste', password: ''));

      expect(() async => await result, throwsA(
        isA<AuthException>().having((e) => e.message, 'message', 'Senha inválida.')
      ));
    });

    test('o login do usuário é efetuado corretamente', () async {
      final result = await loginUsecase(const CredentialsParams(email: 'teste@teste.com', password: '123'));

      expect(result, isA<LoggedUserEntity>()
        .having((user) => user.email, 'email', 'teste@teste.com')
        .having((user) => user.name, 'name', 'Teste')
      );
    });

    test('se o repositório falhar, as exceções são devidamente tratadas', ()  {
      final result = loginUsecase(const CredentialsParams(email: 'Error', password: '123'));

      expect(() async => await result, throwsA(
        isA<AuthException>().having((e) => e.message, 'message', 'Repository error.')
      ));
    });
  });
}

class AuthRepositoryMock implements AuthRepositoryContract {
  @override
  Future<LoggedUserEntity> login(CredentialsParams params) async {
    if (params.email == 'Error') {
      throw Exception();
    }

    return LoggedUserEntity(name: 'Teste', email: params.email);
  }
}
