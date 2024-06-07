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
      topics: List<String>.from(map['topics'] as List<String>),
      updatedAt: map['updated_at'] == null
          ? DateTime.now()
          : DateTime.parse(map['updated_at'] ?? []),
    );
  }

  BlogModel copyWith({
    String? id,
    String? posterId,
    String? imageUrl,
    String? title,
    String? content,
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
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
