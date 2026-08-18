import 'package:equatable/equatable.dart';
import 'package:fireguard_app/features/feed/data/models/featured_story_model.dart';
import 'package:fireguard_app/features/feed/data/models/feed_article_model.dart';

enum FeedStatus { initial, loading, success, failure }

class FeedState extends Equatable {
  final FeedStatus status;
  final List<FeaturedStoryModel> featuredStories;
  final List<FeedArticleModel> articles;
  final String selectedCategory;
  final String searchQuery;
  final String? errorMessage;

  const FeedState({
    this.status = FeedStatus.initial,
    this.featuredStories = const [],
    this.articles = const [],
    this.selectedCategory = 'All',
    this.searchQuery = '',
    this.errorMessage,
  });

  FeedState copyWith({
    FeedStatus? status,
    List<FeaturedStoryModel>? featuredStories,
    List<FeedArticleModel>? articles,
    String? selectedCategory,
    String? searchQuery,
    String? errorMessage,
  }) {
    return FeedState(
      status: status ?? this.status,
      featuredStories: featuredStories ?? this.featuredStories,
      articles: articles ?? this.articles,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      searchQuery: searchQuery ?? this.searchQuery,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        featuredStories,
        articles,
        selectedCategory,
        searchQuery,
        errorMessage,
      ];
}
