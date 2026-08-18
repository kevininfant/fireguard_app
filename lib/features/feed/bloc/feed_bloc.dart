import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fireguard_app/features/feed/bloc/feed_event.dart';
import 'package:fireguard_app/features/feed/bloc/feed_state.dart';
import 'package:fireguard_app/features/feed/data/repositories/feed_repository.dart';

class FeedBloc extends Bloc<FeedEvent, FeedState> {
  final FeedRepository _feedRepository;

  FeedBloc({FeedRepository? feedRepository})
      : _feedRepository = feedRepository ?? FeedRepository(),
        super(const FeedState()) {
    on<FeedStarted>(_onStarted);
    on<FeedCategoryChanged>(_onCategoryChanged);
    on<FeedSearchQueryChanged>(_onSearchQueryChanged);
  }

  Future<void> _onStarted(
    FeedStarted event,
    Emitter<FeedState> emit,
  ) async {
    emit(state.copyWith(status: FeedStatus.loading));
    try {
      final stories = await _feedRepository.getFeaturedStories();
      final articles = await _feedRepository.getArticles(
        category: state.selectedCategory,
        searchQuery: state.searchQuery,
      );
      emit(state.copyWith(
        status: FeedStatus.success,
        featuredStories: stories,
        articles: articles,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: FeedStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onCategoryChanged(
    FeedCategoryChanged event,
    Emitter<FeedState> emit,
  ) async {
    emit(state.copyWith(selectedCategory: event.category));
    try {
      final articles = await _feedRepository.getArticles(
        category: event.category,
        searchQuery: state.searchQuery,
      );
      emit(state.copyWith(articles: articles));
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }

  Future<void> _onSearchQueryChanged(
    FeedSearchQueryChanged event,
    Emitter<FeedState> emit,
  ) async {
    emit(state.copyWith(searchQuery: event.query));
    try {
      final articles = await _feedRepository.getArticles(
        category: state.selectedCategory,
        searchQuery: event.query,
      );
      emit(state.copyWith(articles: articles));
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }
}
