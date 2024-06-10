import 'package:blog_app/core/theme/appPallete.dart';
import 'package:blog_app/core/utils/calculate_reading_time.dart';
import 'package:blog_app/core/utils/forat_date.dart';
import 'package:blog_app/features/blog/domain/entities/blog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class BlogViewerPage extends StatelessWidget {
  final Blog blog;

  static route(Blog blog) => MaterialPageRoute(
        builder: (context) => BlogViewerPage(blog: blog),
      );

  const BlogViewerPage({super.key, required this.blog});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Scrollbar(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  blog.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  'By ${blog.posterName}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  '${formatDatebyddMMYY(blog.updatedAt)}.${calculateReadingtime(blog.content)} min',
                  style: const TextStyle(
                    color: AppPallete.greyColor,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(blog.imageUrl),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  blog.content,
                  style: const TextStyle(
                    color: AppPallete.greyColor,
                    fontWeight: FontWeight.w800,
                    fontSize: 15,
                    height: 2,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
