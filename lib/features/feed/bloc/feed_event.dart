import 'package:equatable/equatable.dart';

abstract class FeedEvent extends Equatable {
  const FeedEvent();
  @override
  List<Object?> get props => [];
}

class FeedStarted extends FeedEvent {}

class FeedCategoryChanged extends FeedEvent {
  final String category;
  const FeedCategoryChanged(this.category);

  @override
  List<Object?> get props => [category];
}

class FeedSearchQueryChanged extends FeedEvent {
  final String query;
  const FeedSearchQueryChanged(this.query);

  @override
  List<Object?> get props => [query];
}
