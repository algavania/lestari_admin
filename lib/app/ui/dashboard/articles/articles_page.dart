import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lestari_admin/app/blocs/articles/articles_bloc.dart';
import 'package:lestari_admin/app/common/shared_code.dart';
import 'package:lestari_admin/app/repositories/articles/articles_repository.dart';
import 'package:lestari_admin/data/models/article_model.dart';
import 'package:lestari_admin/widgets/custom_article_card.dart';
import 'package:lestari_admin/widgets/custom_loading.dart';

class ArticlesPage extends StatefulWidget {
  const ArticlesPage({Key? key}) : super(key: key);

  @override
  State<ArticlesPage> createState() => _ArticlesPageState();
}

class _ArticlesPageState extends State<ArticlesPage> {
  bool _isSearching = false;
  late BuildContext _context;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildSearchAppBar(),
      body: BlocProvider(
        create: (context) =>
        ArticlesBloc(RepositoryProvider.of<ArticlesRepository>(context))
          ..add(const GetArticlesEvent()),
        child: RefreshIndicator(
          onRefresh: () async {
            await _refreshPage();
          },
          child: BlocBuilder<ArticlesBloc, ArticlesState>(
              builder: (context, state) {
                _context = context;
                if (state is ArticlesLoading) {
                  if (!_isSearching) {
                    return const CustomLoading();
                  } else {
                    _isSearching = false;
                    return const SizedBox.shrink();
                  }
                }
                if (state is ArticlesInitial) {
                  return const SizedBox.shrink();
                }
                if (state is ArticlesError) {
                  return Center(child: Text(state.message));
                }
                if (state is ArticlesLoaded) {
                  return _buildArticleList(state.articleModels);
                }
                return Container();
              }
          ),
        ),
      ),
    );
  }

  Widget _buildArticleList(List<ArticleModel> articleModels) {
    return ListView.separated(
        primary: false,
        shrinkWrap: true,
        padding: SharedCode.defaultPagePadding,
        itemBuilder: (_, i) {
          return CustomArticleCard(articleModel: articleModels[i]);
        },
        separatorBuilder: (_, __) => const SizedBox(height: 25.0),
        itemCount: articleModels.length
    );
  }

  Future<void> _refreshPage() async {
    BlocProvider.of<ArticlesBloc>(_context).add(const GetArticlesEvent());
  }

  AppBar _buildSearchAppBar() {
    return SharedCode.buildSearchAppBar(context: context, searchHint: 'Cari artikel', title: 'List Artikel', onChanged: (s) {
      _isSearching = true;
      if (s == null || s.isEmpty) {
        _refreshPage();
      } else {
        BlocProvider.of<ArticlesBloc>(_context).add(SearchArticlesEvent(s));
      }
    });
  }
}