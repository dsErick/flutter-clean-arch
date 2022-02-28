import 'package:bloc_test/bloc_test.dart';
import 'package:clean_architecture/app/auth/domain/domain.dart';
import 'package:clean_architecture/app/auth/presentation/bloc/bloc.dart';
import 'package:clean_architecture/core/errors/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class LoginUseCaseMock extends Mock implements LoginUseCaseContract {}

class UnhandledFailure extends Failure {}

void main() {
  final loginUsecase = LoginUseCaseMock();

  const loginEvent = AuthLoginEvent(email: 'teste', password: 'teste');
  const credentialsParams = CredentialsParams(email: 'teste', password: 'teste');


  test('o state inicial do AuthBloc é AuthInitialState', () {
    final bloc = AuthBloc(loginUsecase);

    expect(bloc.state, const AuthInitialState());
  });

  group('AuthLoginEvent', () {
    blocTest<AuthBloc, AuthState>(
      'se o state atual do bloc for loading, a execução é interrompida',
      build: () => AuthBloc(loginUsecase),
      seed: () => const AuthLoadingState(),
      act: (bloc) => bloc.add(const AuthLoginEvent(email: '', password: '')),
      expect: () => [],
    );

    group('é retornado um AuthErrorState quando o usuário não preenche os dados corretamente:', () {
      blocTest<AuthBloc, AuthState>(
        'email e senha vazios',
        build: () => AuthBloc(loginUsecase),
        act: (bloc) => bloc.add(const AuthLoginEvent(email: '', password: '')),
        expect: () => [
          const AuthErrorState('É obrigatório informar um email e senha.'),
        ],
      );

      blocTest<AuthBloc, AuthState>(
        'senha vazia',
        build: () => AuthBloc(loginUsecase),
        act: (bloc) => bloc.add(const AuthLoginEvent(email: 'teste', password: '')),
        expect: () => [
          const AuthErrorState('É obrigatório informar um email e senha.'),
        ],
      );

      blocTest<AuthBloc, AuthState>(
        'email vazio',
        build: () => AuthBloc(loginUsecase),
        act: (bloc) => bloc.add(const AuthLoginEvent(email: '', password: 'teste')),
        expect: () => [
          const AuthErrorState('É obrigatório informar um email e senha.'),
        ],
      );
    });

    group('a execução do LoginUseCase retorna um Failure:', () {
      blocTest<AuthBloc, AuthState>(
        'AuthFailure',
        build: () {
          when(() => loginUsecase(credentialsParams)).thenAnswer((_) async => const Left(AuthFailure('Error')));

          return AuthBloc(loginUsecase);
        },
        act: (bloc) => bloc.add(loginEvent),
        expect: () => [
          const AuthLoadingState(),
          const AuthErrorState('Error'),
        ],
      );

      blocTest<AuthBloc, AuthState>(
        'ServerFailure',
        build: () {
          when(() => loginUsecase(credentialsParams)).thenAnswer((_) async => const Left(ServerFailure()));

          return AuthBloc(loginUsecase);
        },
        act: (bloc) => bloc.add(loginEvent),
        expect: () => [
          const AuthLoadingState(),
          const AuthErrorState('Algo de enesperado ocorreu ao efetuar o login.'),
        ],
      );

      blocTest<AuthBloc, AuthState>(
        'UnhandledFailure',
        build: () {
          when(() => loginUsecase(credentialsParams)).thenAnswer((_) async => Left(UnhandledFailure()));

          return AuthBloc(loginUsecase);
        },
        act: (bloc) => bloc.add(loginEvent),
        expect: () => [
          const AuthLoadingState(),
          const AuthErrorState('Deu ruim.'),
        ],
      );
    });

    blocTest<AuthBloc, AuthState>(
      'é retornado um AuthSuccessState se a execução do LoginUseCase retorna um LoggedUserEntity',
      build: () {
        when(() => loginUsecase(credentialsParams)).thenAnswer((_) async => const Right(LoggedUserEntity(email: 'teste', name: 'teste')));

        return AuthBloc(loginUsecase);
      },
      act: (bloc) => bloc.add(loginEvent),
      expect: () => [
        const AuthLoadingState(),
        const AuthSuccessState(LoggedUserEntity(email: 'teste', name: 'teste')),
      ],
    );
  });
}
