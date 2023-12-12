import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:lestari_admin/app/repositories/articles/articles_repository.dart';
import 'package:lestari_admin/data/models/article_model.dart';

part 'articles_event.dart';
part 'articles_state.dart';

class ArticlesBloc extends Bloc<ArticlesEvent, ArticlesState> {
  final ArticlesRepository _repository;

  ArticlesBloc(this._repository) : super(ArticlesInitial()) {
    on<GetArticlesEvent>(_getArticles);
    on<SearchArticlesEvent>(_getArticlesByKeyword);
  }

  Future<void> _getArticles(GetArticlesEvent event, Emitter<ArticlesState> emit) async {
    emit(ArticlesLoading());
    try {
      List<ArticleModel> model = await _repository.getArticles();
      emit(ArticlesLoaded(model));
    } catch (e) {
      emit(ArticlesError(e.toString()));
    }
  }

  Future<void> _getArticlesByKeyword(SearchArticlesEvent event, Emitter<ArticlesState> emit) async {
    emit(ArticlesLoading());
    try {
      List<ArticleModel> model = await _repository.getArticlesByKeyword(event.keyword);
      emit(ArticlesLoaded(model));
    } catch (e) {
      emit(ArticlesError(e.toString()));
    }
  }
}
