import 'package:clean_architecture/app/auth/domain/domain.dart';
import 'package:clean_architecture/app/auth/infra/infra.dart';
import 'package:clean_architecture/core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class AuthDatasourceMock extends Mock implements AuthDatasourceContract {}

void main() {
  final datasource = AuthDatasourceMock();
  final repository = AuthRespositoryImpl(datasource);

  const params = CredentialsParams(email: 'teste@teste.com', password: 'teste');

  test('caso uma FormatException aconteça, é retornado um ServerFailure', () async {
    when(() => datasource.login(params)).thenThrow(const FormatException());

    final result = await repository.login(params);

    expect(result, const Left(ServerFailure()));
  });

  test('é retornado um LoggedUserModel quando nenhuma exceção ocorrer', () async {
    when(() => datasource.login(params)).thenAnswer((_) async => const LoggedUserModel(name: 'Teste', email: 'teste@teste.com'));

    final result = await repository.login(params);

    expect(result, const Right(LoggedUserModel(name: 'Teste', email: 'teste@teste.com')));
  });
}
