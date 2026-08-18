import 'package:equatable/equatable.dart';

class FeedArticleModel extends Equatable {
  final String id;
  final String category; // 'Code Update', 'Training', 'Drill Insight'
  final String readTime;
  final String title;
  final String description;
  final String? quote;
  final String authorName;
  final String authorRole;
  final String? authorAvatarUrl;
  final String? authorInitials;
  final String actionText;
  final String? imageUrl;
  final bool isVideo;
  final String fullContent;

  const FeedArticleModel({
    required this.id,
    required this.category,
    required this.readTime,
    required this.title,
    required this.description,
    this.quote,
    required this.authorName,
    required this.authorRole,
    this.authorAvatarUrl,
    this.authorInitials,
    this.actionText = 'READ MORE',
    this.imageUrl,
    this.isVideo = false,
    required this.fullContent,
  });

  @override
  List<Object?> get props => [
        id,
        category,
        readTime,
        title,
        description,
        quote,
        authorName,
        authorRole,
        authorAvatarUrl,
        authorInitials,
        actionText,
        imageUrl,
        isVideo,
        fullContent,
      ];
}
