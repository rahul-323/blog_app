import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:blog_app/core/common/cubit/app_user/app_user_cubit.dart';
import 'package:blog_app/core/common/widgets/loader.dart';
import 'package:blog_app/core/theme/appPallete.dart';
import 'package:blog_app/core/utils/pick_image.dart';
import 'package:blog_app/core/utils/show_snack_bar.dart';
import 'package:blog_app/features/blog/presentation/bloc/blog_bloc.dart';
import 'package:blog_app/features/blog/presentation/pages/blog_page.dart';
import 'package:blog_app/features/blog/presentation/widgets/blog_editor.dart';

class AddNEWBlogPage extends StatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const AddNEWBlogPage(),
      );
  const AddNEWBlogPage({super.key});

  @override
  State<AddNEWBlogPage> createState() => _AddNEWBlogPageState();
}

class _AddNEWBlogPageState extends State<AddNEWBlogPage> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  List<String> selectedTopic = [];
  File? image;

  void selectImage() async {
    final pickedImage = await pickImage();
    if (pickedImage != null) {
      setState(() {
        image = pickedImage;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
    contentController.dispose();
  }

  void uploadBlog() {
    if (formKey.currentState!.validate() &&
        selectedTopic.isNotEmpty &&
        image != null) {
      final posterId =
          (context.read<AppUserCubit>().state as AppUserLoggedIn).user.id;
      context.read<BlogBloc>().add(BlogUpload(
          posterId: posterId,
          title: titleController.text.trim(),
          content: contentController.text.trim(),
          image: image!,
          topics: selectedTopic));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                uploadBlog(); // Call the function here
              },
              icon: const Icon(Icons.done_rounded))
        ],
      ),
      body: BlocConsumer<BlogBloc, BlogState>(
        listener: (context, state) {
          if (state is BlogFailure) {
            showSnackBar(context, state.error);
          } else if (state is BlogSuccess) {
            Navigator.pushAndRemoveUntil(
                context, BlogPage.route(), (route) => false);
          }
        },
        builder: (context, state) {
          if (state is BlogLoading) {
            return const MyLoader();
          }
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    image != null
                        ? GestureDetector(
                            onTap: selectImage,
                            child: SizedBox(
                              height: 150,
                              width: double.infinity,
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.file(image!, fit: BoxFit.cover)),
                            ),
                          )
                        : GestureDetector(
                            onTap: selectImage,
                            child: DottedBorder(
                              color: AppPallete.borderColor,
                              dashPattern: [10, 4],
                              radius: const Radius.circular(10),
                              strokeCap: StrokeCap.round,
                              borderType: BorderType.RRect,
                              child: Container(
                                height: 200,
                                width: MediaQuery.sizeOf(context).width,
                                child: const Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.folder_open,
                                      size: 40,
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    Text(
                                      'Select Your Image',
                                      style: TextStyle(fontSize: 15),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                    const SizedBox(
                      height: 25,
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          'Technology',
                          'Business',
                          'Programming',
                          'Entertainment',
                        ]
                            .map((e) => Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      if (selectedTopic.contains(e)) {
                                        selectedTopic.remove(e);
                                      } else {
                                        selectedTopic.add(e);
                                      }
                                      setState(() {});
                                    },
                                    child: Chip(
                                      color: selectedTopic.contains(e)
                                          ? MaterialStatePropertyAll(
                                              AppPallete.gradient1)
                                          : null,
                                      label: Text(e),
                                      side: selectedTopic.contains(e)
                                          ? null
                                          : const BorderSide(
                                              color: AppPallete.borderColor),
                                    ),
                                  ),
                                ))
                            .toList(),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    BlogEditor(controller: titleController, hintText: "Title"),
                    const SizedBox(
                      height: 10,
                    ),
                    BlogEditor(
                        controller: contentController, hintText: "Blog Content")
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
