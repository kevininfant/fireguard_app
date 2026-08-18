import 'package:equatable/equatable.dart';

class FeaturedStoryModel extends Equatable {
  final String id;
  final String tag;
  final String title;
  final String subtitle;
  final String imageUrl;
  final String fullContent;

  const FeaturedStoryModel({
    required this.id,
    required this.tag,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.fullContent,
  });

  @override
  List<Object?> get props => [id, tag, title, subtitle, imageUrl, fullContent];
}
