part of 'articles_bloc.dart';

abstract class ArticlesState extends Equatable {
  const ArticlesState();
}

class ArticlesInitial extends ArticlesState {
  @override
  List<Object> get props => [];
}
class ArticlesLoading extends ArticlesState {
  @override
  List<Object> get props => [];
}

class ArticlesLoaded extends ArticlesState {
  final List<ArticleModel> articleModels;

  const ArticlesLoaded(this.articleModels);

  @override
  List<Object> get props => [articleModels];
}

class ArticlesError extends ArticlesState {
  final String message;

  const ArticlesError(this.message);

  @override
  List<Object> get props => [message];
}