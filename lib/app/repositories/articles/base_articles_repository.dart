import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lestari_admin/data/models/article_model.dart';

abstract class BaseArticlesRepository {
  Future<List<ArticleModel>> getArticles();
  Future<List<ArticleModel>> getArticlesByKeyword(String keyword);
  Future<DocumentReference> addArticle(ArticleModel articleModel);
  Future<void> updateArticle(ArticleModel articleModel);
  Future<void> deleteArticle(String articleId);
}