import 'package:bloc/bloc.dart';
import 'package:clean_architecture/app/auth/domain/domain.dart';
import 'package:clean_architecture/app/auth/presentation/bloc/bloc.dart';
import 'package:clean_architecture/core/errors/failures.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCaseContract loginUsecase;

  AuthBloc(this.loginUsecase) : super(const AuthInitialState()) {
    on<AuthLoginEvent>(_login);
  }

  Future _login(AuthLoginEvent event, Emitter<AuthState> emit) async {
    if (state is AuthLoadingState) {
      return;
    }

    if (event.email.isEmpty || event.password.isEmpty) {
      return emit(const AuthErrorState('É obrigatório informar um email e senha.'));
    }

    emit(const AuthLoadingState());

    final result = await loginUsecase(CredentialsParams(email: event.email, password: event.password));

    result.fold((Failure failure) {
      // print(failure);

      if (failure is AuthFailure) {
        return emit(AuthErrorState(failure.message));
      }

      if (failure is ServerFailure) {
        return emit(const AuthErrorState('Algo de enesperado ocorreu ao efetuar o login.'));
      }

      emit(const AuthErrorState('Deu ruim.'));
    }, (LoggedUserEntity entity) {
      emit(AuthSuccessState(entity));
    });
  }
}
