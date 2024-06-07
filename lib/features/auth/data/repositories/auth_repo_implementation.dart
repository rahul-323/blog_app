import 'package:blog_app/core/error/exceptions.dart';
import 'package:blog_app/core/error/failures.dart';
import 'package:blog_app/features/auth/data/datasources/authRemoteDatasource.dart';
import 'package:blog_app/core/common/entities/users.dart';
import 'package:blog_app/features/auth/domain/repository/auth_repositort.dart';
import 'package:fpdart/src/either.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sp;

class AuthRepoImplementation implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  AuthRepoImplementation(this.remoteDataSource);

  @override
  Future<Either<Failure, User>> currentUser() async {
    try {
      final user = await remoteDataSource.getCurrentUserData();
      if (user == null) {
        return left(Failure('User Not logged In'));
      }
      return right(user);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, User>> logInWithEmailPassword(
      {required String email, required String password}) async {
    return _getUser(() async => await remoteDataSource.loginWithEmailPassword(
        email: email, password: password));
  }

  @override
  Future<Either<Failure, User>> signUpWithEmailPassword(
      {required String name,
      required String email,
      required String password}) async {
    return _getUser(
      () async => await remoteDataSource.signUpWithEmailPassword(
          name: name, email: email, password: password),
    );
  }

  Future<Either<Failure, User>> _getUser(
    Future<User> Function() fn,
  ) async {
    try {
      final user = await fn();
      return right(user);
    } on sp.AuthException catch (x) {
      return left(Failure(x.message));
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }
}
