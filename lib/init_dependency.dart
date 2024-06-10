import 'package:blog_app/core/common/cubit/app_user/app_user_cubit.dart';
import 'package:blog_app/core/network/connection_checker.dart';
import 'package:blog_app/core/secrets/app_secrets.dart';
import 'package:blog_app/features/auth/data/datasources/authRemoteDatasource.dart';
import 'package:blog_app/features/auth/data/repositories/auth_repo_implementation.dart';
import 'package:blog_app/features/auth/domain/repository/auth_repositort.dart';
import 'package:blog_app/features/auth/domain/usecases/current_user.dart';
import 'package:blog_app/features/auth/domain/usecases/user_login.dart';
import 'package:blog_app/features/auth/domain/usecases/user_sign_up.dart';
import 'package:blog_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:blog_app/features/blog/data/data_sources/blog_data_source.dart';
import 'package:blog_app/features/blog/data/data_sources/local_data_source.dart';
import 'package:blog_app/features/blog/data/repositories/blog_repository_implementation.dart';
import 'package:blog_app/features/blog/domain/repository/blog_repo.dart';
import 'package:blog_app/features/blog/domain/usecases/get_all_blogs.dart';
import 'package:blog_app/features/blog/domain/usecases/upload_blog.dart';
import 'package:blog_app/features/blog/presentation/bloc/blog_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final serviceLocater = GetIt.instance;

Future<void> initDependency() async {
  _initAuth();
  _initBlog();
  final supabase = await Supabase.initialize(
      url: Secrets.supabaseUrl, anonKey: Secrets.supabaseAnonKey);
  Hive.defaultDirectory = (await getApplicationDocumentsDirectory()).path;
  serviceLocater.registerLazySingleton(() => supabase.client);

  serviceLocater.registerLazySingleton(
    () => Hive.box(name: 'blogs'),
  );

  serviceLocater.registerFactory(() => InternetConnection());
  serviceLocater.registerLazySingleton(() => AppUserCubit());
  serviceLocater.registerFactory<ConnectionChecker>(
    () => ConnectionCheckerImpl(
      serviceLocater(),
    ),
  );
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
    ..registerFactory<BlogLocalDataSource>(
        () => BlogLocalDataSourceImpl(serviceLocater()))
    ..registerFactory<BlogRepository>(
      () => BlogrepoImplementation(
        serviceLocater(),
        serviceLocater(),
        serviceLocater(),
      ),
    )
    ..registerFactory(
      () => UploadBlog(
        serviceLocater(),
      ),
    )
    ..registerFactory(
      () => GetAllBlogs(
        serviceLocater(),
      ),
    )
    ..registerLazySingleton(
      () => BlogBloc(
        getAllBlogs: serviceLocater(),
        uploadBlog: serviceLocater(),
      ),
    );
}
