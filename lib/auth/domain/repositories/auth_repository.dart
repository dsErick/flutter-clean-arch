import 'package:clean_architecture/auth/domain/domain.dart';

class AuthRepository implements AuthRepositoryContract {
  @override
  Future<LoggedUserEntity> login(CredentialsParams params) async {
    throw UnimplementedError();
  }
}
