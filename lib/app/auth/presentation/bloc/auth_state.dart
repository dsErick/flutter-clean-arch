import 'package:clean_architecture/app/auth/domain/entities/logged_user_entity.dart';
import 'package:equatable/equatable.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthInitialState extends AuthState {
  const AuthInitialState();
}

class AuthLoadingState extends AuthState {
  const AuthLoadingState();
}

class AuthErrorState extends AuthState {
  final String message;

  const AuthErrorState(this.message);

  @override
  List<Object> get props => [message];
}

class AuthSuccessState extends AuthState {
  final LoggedUserEntity user;

  const AuthSuccessState(this.user);

  @override
  List<Object> get props => [user];
}
