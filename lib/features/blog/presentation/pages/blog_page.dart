import 'package:blog_app/core/common/widgets/loader.dart';
import 'package:blog_app/core/theme/appPallete.dart';
import 'package:blog_app/core/utils/show_snack_bar.dart';
import 'package:blog_app/features/auth/presentation/pages/login.dart';
import 'package:blog_app/features/blog/presentation/bloc/blog_bloc.dart';
import 'package:blog_app/features/blog/presentation/pages/add_new_blog_page.dart';
import 'package:blog_app/features/blog/presentation/widgets/blog_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BlogPage extends StatefulWidget {
  const BlogPage({super.key});

  static route() => MaterialPageRoute(
        builder: (context) => const BlogPage(),
      );

  @override
  State<BlogPage> createState() => _BlogPageState();
}

class _BlogPageState extends State<BlogPage> {
  @override
  void initState() {
    super.initState();
    context.read<BlogBloc>().add(BlogFetchAllBlogs());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Blogs App"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(context, LoginPage.route());
            },
            icon: const Icon(Icons.login),
          ),
        ],
      ),
      body: BlocConsumer<BlogBloc, BlogState>(listener: (context, state) {
        if (state is BlogFailure) {
          showSnackBar(context, state.error);
        }
      }, builder: (context, state) {
        if (state is BlogLoading) {
          return const MyLoader();
        }
        if (state is BlogDisplaySuccess) {
          return ListView.builder(
              itemCount: state.blogs.length,
              itemBuilder: (context, index) {
                final blog = state.blogs[index];
                return BlogCard(
                  blog: blog,
                  color: index % 3 == 0
                      ? AppPallete.gradient1
                      : index % 3 == 1
                          ? AppPallete.gradient2
                          : AppPallete.gradient3,
                );
              });
        }
        return const SizedBox();
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, AddNEWBlogPage.route());
        },
        hoverColor: AppPallete.gradient2,
        backgroundColor: Color.fromARGB(255, 206, 169, 38),
        child: const Icon(
          Icons.add_circle_outline,
          color: AppPallete.backgroundColor,
        ),
      ),
    );
  }
}
