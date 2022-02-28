import 'package:clean_architecture/app/auth/domain/usecases/login_usecase.dart';
import 'package:clean_architecture/app/auth/infra/infra.dart';

class AuthDatasourceImpl implements AuthDatasourceContract {
  @override
  Future<LoggedUserModel> login(CredentialsParams params) async {
    // Faz o request pra API

    return LoggedUserModel.fromJson('{"name": "Teste", "email": "${params.email}"}');
  }
}
