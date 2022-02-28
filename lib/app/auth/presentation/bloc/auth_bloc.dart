import 'package:bloc/bloc.dart';
import 'package:clean_architecture/app/auth/domain/domain.dart';
import 'package:clean_architecture/app/auth/presentation/bloc/bloc.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase loginUsecase;

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
    print('loading');

    await Future.delayed(const Duration(seconds: 1));

    print('logged');
    emit(const AuthSuccessState());
  }
}
