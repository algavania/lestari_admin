part of 'articles_bloc.dart';

abstract class ArticlesEvent extends Equatable {
  const ArticlesEvent();
}

class GetArticlesEvent extends ArticlesEvent {
  const GetArticlesEvent();

  @override
  List<Object?> get props => [];
}

class SearchArticlesEvent extends ArticlesEvent {
  const SearchArticlesEvent(this.keyword);
  final String keyword;

  @override
  List<Object?> get props => [keyword];
}