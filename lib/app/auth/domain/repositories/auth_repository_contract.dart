import 'package:clean_architecture/app/auth/domain/domain.dart';

abstract class AuthRepositoryContract {
  Future<LoggedUserEntity> login(CredentialsParams params);
}