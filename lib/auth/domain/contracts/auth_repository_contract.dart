import 'package:clean_architecture/auth/domain/domain.dart';

abstract class AuthRepositoryContract {
  Future<LoggedUserEntity> login(CredentialsParams params);
}
