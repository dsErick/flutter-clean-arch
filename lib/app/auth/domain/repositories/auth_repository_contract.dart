import 'package:clean_architecture/app/auth/domain/domain.dart';
import 'package:clean_architecture/core/errors/failures.dart';
import 'package:dartz/dartz.dart';

abstract class AuthRepositoryContract {
  Future<Either<Failure, LoggedUserEntity>> login(CredentialsParams params);
}
