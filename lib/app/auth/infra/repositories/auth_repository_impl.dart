import 'package:clean_architecture/app/auth/domain/domain.dart';
import 'package:clean_architecture/app/auth/infra/infra.dart';
import 'package:clean_architecture/core/errors/failures.dart';
import 'package:dartz/dartz.dart';

class AuthRespositoryImpl implements AuthRepositoryContract {
  final AuthDatasourceContract datasource;

  const AuthRespositoryImpl(this.datasource);

  @override
  Future<Either<Failure, LoggedUserEntity>> login(CredentialsParams params) async {
    try {
      final user = await datasource.login(params);

      return Right(user);

    } on FormatException {
      return const Left(ServerFailure());
    }
  }
}
