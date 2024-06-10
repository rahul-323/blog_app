import 'package:blog_app/core/error/exceptions.dart';
import 'package:blog_app/core/error/failures.dart';
import 'package:blog_app/core/network/connection_checker.dart';
import 'package:blog_app/features/auth/data/datasources/authRemoteDatasource.dart';
import 'package:blog_app/core/common/entities/users.dart';
import 'package:blog_app/features/auth/data/model/user_model.dart';
import 'package:blog_app/features/auth/domain/repository/auth_repositort.dart';
import 'package:fpdart/fpdart.dart';

class AuthRepoImplementation implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final ConnectionChecker connectionChecker;
  AuthRepoImplementation(this.remoteDataSource, this.connectionChecker);

  @override
  Future<Either<Failure, User>> currentUser() async {
    try {
      if (!await (connectionChecker.isConnected)) {
        final session = remoteDataSource.currentSession;

        if (session == null) {
          return left(
            Failure('User not Logged In'),
          );
        }

        return right(UserModel(
            id: session.user.id, email: session.user.email ?? '', name: ""));
      }

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
      if (!await (connectionChecker.isConnected)) {
        return left(Failure('No Internet Connection!!'));
      }
      final user = await fn();
      return right(user);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }
}
