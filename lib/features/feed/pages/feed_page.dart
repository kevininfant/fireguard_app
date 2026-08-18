import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fireguard_app/core/constants/app_colors.dart';
import 'package:fireguard_app/core/widgets/loading_view.dart';
import 'package:fireguard_app/features/feed/bloc/feed_bloc.dart';
import 'package:fireguard_app/features/feed/bloc/feed_event.dart';
import 'package:fireguard_app/features/feed/bloc/feed_state.dart';
import 'package:fireguard_app/features/feed/widgets/featured_story_carousel.dart';
import 'package:fireguard_app/features/feed/widgets/category_filter_bar.dart';
import 'package:fireguard_app/features/feed/widgets/feed_article_card.dart';
import 'package:fireguard_app/features/feed/pages/article_detail_modal.dart';
import 'package:fireguard_app/features/feed/pages/story_detail_modal.dart';

class FeedPage extends StatefulWidget {
  const FeedPage({super.key});

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  final _searchController = TextEditingController();
  bool _showSearchBar = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FeedBloc, FeedState>(
      builder: (context, state) {
        if (state.status == FeedStatus.loading && state.articles.isEmpty) {
          return const LoadingView(message: 'Loading Knowledge Feed...');
        }

        return RefreshIndicator(
          onRefresh: () async {
            context.read<FeedBloc>().add(FeedStarted());
          },
          color: AppColors.industrialOrange,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header & Search Toggle Row
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'FEATURED SPOTLIGHTS',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.0,
                          color: AppColors.onSurfaceVariantText,
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          _showSearchBar ? Icons.close : Icons.search,
                          color: AppColors.industrialOrange,
                          size: 20,
                        ),
                        onPressed: () {
                          setState(() {
                            _showSearchBar = !_showSearchBar;
                            if (!_showSearchBar) {
                              _searchController.clear();
                              context.read<FeedBloc>().add(const FeedSearchQueryChanged(''));
                            }
                          });
                        },
                      ),
                    ],
                  ),
                ),

                // Search Input (Conditional)
                if (_showSearchBar) ...[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                    child: TextField(
                      controller: _searchController,
                      style: const TextStyle(color: AppColors.onSurfaceText, fontSize: 13),
                      decoration: InputDecoration(
                        hintText: 'Search code updates, drills, authors...',
                        prefixIcon: const Icon(Icons.search, color: AppColors.industrialOrange, size: 20),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        filled: true,
                        fillColor: AppColors.surfaceContainerHigh,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: AppColors.outlineVariantColor),
                        ),
                      ),
                      onChanged: (query) {
                        context.read<FeedBloc>().add(FeedSearchQueryChanged(query));
                      },
                    ),
                  ),
                ],

                // Featured Stories Carousel
                FeaturedStoryCarousel(
                  stories: state.featuredStories,
                  onStoryClick: (story) {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (_) => StoryDetailModal(story: story),
                    );
                  },
                ),
                const SizedBox(height: 20),

                // Category Filter Bar
                CategoryFilterBar(
                  selectedCategory: state.selectedCategory,
                  onCategorySelected: (cat) {
                    context.read<FeedBloc>().add(FeedCategoryChanged(cat));
                  },
                ),
                const SizedBox(height: 16),

                // Articles Feed Section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: const Text(
                    'LATEST COMPLIANCE & SAFETY ARTICLES',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.0,
                      color: AppColors.onSurfaceVariantText,
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                if (state.articles.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(32),
                    child: Center(
                      child: Text(
                        'No articles found for this category or search.',
                        style: TextStyle(color: AppColors.onSurfaceVariantText),
                      ),
                    ),
                  )
                else
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: state.articles.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 14),
                    itemBuilder: (context, index) {
                      final article = state.articles[index];
                      return FeedArticleCard(
                        article: article,
                        onReadMore: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (_) => ArticleDetailModal(article: article),
                          );
                        },
                      );
                    },
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
