import 'package:blog_app/features/blog/domain/entities/blog.dart';

class BlogModel extends Blog {
  BlogModel({
    required super.id,
    required super.posterId,
    required super.imageUrl,
    required super.title,
    required super.content,
    required super.updatedAt,
    required super.topics,
    super.posterName,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'poster_id': posterId,
      'image_url': imageUrl,
      'title': title,
      'content': content,
      'topics': topics,
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  factory BlogModel.fromJson(Map<String, dynamic> map) {
    return BlogModel(
      id: map['id'] as String,
      posterId: map['poster_id'] as String,
      imageUrl: map['image_url'] as String,
      title: map['title'] as String,
      content: map['content'] as String,
      topics:
          (map['topics'] as List<dynamic>).map((e) => e.toString()).toList(),
      updatedAt: map['updated_at'] == null
          ? DateTime.now()
          : DateTime.parse(map['updated_at']),
    );
  }

  BlogModel copyWith({
    String? id,
    String? posterId,
    String? imageUrl,
    String? title,
    String? content,
    String? posterName,
    List<String>? topics,
    DateTime? updatedAt,
  }) {
    return BlogModel(
      id: id ?? this.id,
      posterId: posterId ?? this.posterId,
      imageUrl: imageUrl ?? this.imageUrl,
      title: title ?? this.title,
      content: content ?? this.content,
      topics: topics ?? this.topics,
      posterName: posterName ?? this.posterName,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
