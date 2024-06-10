// ignore_for_file: public_member_api_docs, sort_constructors_first
class Blog {
  final String id;
  final String posterId;
  final String imageUrl;
  final String title;
  final String content;
  final List<String> topics;
  final DateTime updatedAt;
  final String? posterName;

  Blog({
    this.posterName,
    required this.id,
    required this.posterId,
    required this.imageUrl,
    required this.title,
    required this.content,
    required this.topics,
    required this.updatedAt,
  });
}
