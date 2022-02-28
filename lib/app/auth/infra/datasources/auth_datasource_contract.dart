import 'package:clean_architecture/app/auth/domain/usecases/login_usecase.dart';
import 'package:clean_architecture/app/auth/infra/models/logged_user_model.dart';

abstract class AuthDatasourceContract {
  Future<LoggedUserModel> login(CredentialsParams params);
}
