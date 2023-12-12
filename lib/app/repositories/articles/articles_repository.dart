import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:lestari_admin/app/repositories/articles/base_articles_repository.dart';
import 'package:lestari_admin/data/models/article_model.dart';

class ArticlesRepository extends BaseArticlesRepository {
  CollectionReference articlesRef = FirebaseFirestore.instance.collection('articles');

  @override
  Future<List<ArticleModel>> getArticles() async {
    List<ArticleModel> models = [];
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('articles').orderBy('created_at', descending: true).get();
      for (var element in snapshot.docs) {
        Map<String, dynamic> map = element.data() as Map<String, dynamic>;
        map['id'] = element.id;
        ArticleModel model = ArticleModel.fromMap(map);
        models.add(model);
      }
      return models;
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Future<DocumentReference> addArticle(ArticleModel articleModel) async {
    Map<String, Object?> json = articleModel.toMap();
    return await articlesRef.add(json);
  }

  @override
  Future<void> updateArticle(ArticleModel articleModel) async {
    await articlesRef.doc(articleModel.id).update(articleModel.toMap());
  }

  @override
  Future<void> deleteArticle(String articleId) async {
    await articlesRef.doc(articleId).delete();
    await FirebaseStorage.instance.ref('articles/$articleId').listAll().then((value) {
      for (Reference element in value.items) {
        FirebaseStorage.instance.ref(element.fullPath).delete();
      }
    });
  }

  @override
  Future<List<ArticleModel>> getArticlesByKeyword(String keyword) async {
    print(keyword);
    List<ArticleModel> models = [];
    keyword = keyword.toUpperCase();
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('articles')
          .where('searchable_title', isGreaterThanOrEqualTo: keyword)
          .where('searchable_title', isLessThanOrEqualTo: "$keyword\uf7ff")
          .get();
      for (var element in snapshot.docs) {
        Map<String, dynamic> map = element.data() as Map<String, dynamic>;
        map['id'] = element.id;
        ArticleModel model = ArticleModel.fromMap(map);
        models.add(model);
      }
      return models;
    } catch (e) {
      throw e.toString();
    }
  }
}