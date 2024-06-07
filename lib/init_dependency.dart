import 'package:blog_app/core/common/cubit/app_user/app_user_cubit.dart';
import 'package:blog_app/core/secrets/app_secrets.dart';
import 'package:blog_app/features/auth/data/datasources/authRemoteDatasource.dart';
import 'package:blog_app/features/auth/data/repositories/auth_repo_implementation.dart';
import 'package:blog_app/features/auth/domain/repository/auth_repositort.dart';
import 'package:blog_app/features/auth/domain/usecases/current_user.dart';
import 'package:blog_app/features/auth/domain/usecases/user_login.dart';
import 'package:blog_app/features/auth/domain/usecases/user_sign_up.dart';
import 'package:blog_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:blog_app/features/blog/data/data_sources/blog_data_source.dart';
import 'package:blog_app/features/blog/data/repositories/blog_repository_implementation.dart';
import 'package:blog_app/features/blog/domain/repository/blog_repo.dart';
import 'package:blog_app/features/blog/domain/usecases/upload_blog.dart';
import 'package:blog_app/features/blog/presentation/bloc/blog_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final serviceLocater = GetIt.instance;

Future<void> initDependency() async {
  _initAuth();
  _initBlog();
  final supabase = await Supabase.initialize(
      url: Secrets.supabaseUrl, anonKey: Secrets.supabaseAnonKey);
  serviceLocater.registerLazySingleton(() => supabase.client);
  serviceLocater.registerLazySingleton(() => AppUserCubit());
}

void _initAuth() {
  //Data Source
  serviceLocater
    ..registerFactory<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImplementation(
        serviceLocater(),
      ),
    )
    //Repo
    ..registerFactory<AuthRepository>(
      () => AuthRepoImplementation(
        serviceLocater(),
      ),
      //USeCases
    )
    ..registerFactory(
      () => UserSignUp(
        serviceLocater(),
      ),
    )
    ..registerFactory(
      () => UserLogin(
        serviceLocater(),
      ),
    )
    ..registerFactory(
      () => CurrentUser(
        serviceLocater(),
      ),
    )

    //Bloc
    ..registerLazySingleton(
      () => AuthBloc(
        userSignUp: serviceLocater(),
        userLogin: serviceLocater(),
        currentUser: serviceLocater(),
        appUserCubit: serviceLocater(),
      ),
    );
}

void _initBlog() {
  serviceLocater
    ..registerFactory<BlogRemoteDataSource>(
      () => BlogRemoteDataSourceImpl(
        serviceLocater(),
      ),
    )
    ..registerFactory<BlogRepository>(
      () => BlogrepoImplementation(
        serviceLocater(),
      ),
    )
    ..registerFactory(
      () => UploadBlog(
        serviceLocater(),
      ),
    )
    ..registerLazySingleton(
      () => BlogBloc(
        serviceLocater(),
      ),
    );
}
