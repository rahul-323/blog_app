import 'package:blog_app/core/error/failures.dart';
import 'package:blog_app/core/usecase/usecase.dart';
import 'package:blog_app/core/common/entities/users.dart';
import 'package:blog_app/features/auth/domain/repository/auth_repositort.dart';
import 'package:fpdart/fpdart.dart';

class CurrentUser implements UseCase<User, NoParams> {
  final AuthRepository authrepository;
  CurrentUser(this.authrepository);
  @override
  Future<Either<Failure, User>> call(NoParams params) async {
    return await authrepository.currentUser();
  }
}
