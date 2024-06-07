import 'dart:io';
import 'package:blog_app/features/blog/data/data_sources/blog_data_source.dart';
import 'package:fpdart/fpdart.dart';
import 'package:uuid/uuid.dart';
import 'package:blog_app/features/blog/data/models/blog_model.dart';
import 'package:blog_app/features/blog/domain/entities/blog.dart';
import 'package:blog_app/features/blog/domain/repository/blog_repo.dart';
import 'package:blog_app/core/error/exceptions.dart';
import 'package:blog_app/core/error/failures.dart';

class BlogrepoImplementation implements BlogRepository {
  final BlogRemoteDataSource blogRemoteDataSource;
  BlogrepoImplementation(this.blogRemoteDataSource);

  @override
  Future<Either<Failure, Blog>> uploadBlog({
    required File image,
    required String title,
    required String content,
    required String posterId,
    required List<String> topics,
  }) async {
    try {
      BlogModel blogModel = BlogModel(
        id: const Uuid().v1(),
        posterId: posterId,
        imageUrl: 'imageUrl',
        title: title,
        content: content,
        updatedAt: DateTime.now(),
        topics: topics,
      );

      final imageUrl = await blogRemoteDataSource.uploadBlogImage(
        image: image,
        blog: blogModel,
      );

      blogModel = blogModel.copyWith(imageUrl: imageUrl);

      final uploadedBlog = await blogRemoteDataSource.uploadBlog(blogModel);

      return right(uploadedBlog);
    } on ServerException catch (e) {
      return left(
        Failure(
          e.message,
        ),
      );
    }
  }
}
