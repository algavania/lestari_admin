import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lestari_admin/app/common/color_values.dart';
import 'package:lestari_admin/app/common/shared_code.dart';
import 'package:lestari_admin/app/repositories/repositories.dart';
import 'package:lestari_admin/app/ui/article_detail/article_removed_page.dart';
import 'package:lestari_admin/app/ui/article_form/article_form_page.dart';
import 'package:lestari_admin/app/ui/dashboard/dashboard_page.dart';
import 'package:lestari_admin/data/models/article_model.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:sizer/sizer.dart';

class ArticleDetailPage extends StatefulWidget {
  final ArticleModel articleModel;
  const ArticleDetailPage({Key? key, required this.articleModel}) : super(key: key);

  @override
  State<ArticleDetailPage> createState() => _ArticleDetailPageState();
}

class _ArticleDetailPageState extends State<ArticleDetailPage> {

  void _showMoreMenus(){
    showMenu<String>(
      context: context,
      position: RelativeRect.fromLTRB(100.w, 0.0, 0.0, 0.0),
      items: [
        const PopupMenuItem<String>(
          value: 'Edit',
          child: Text('Ubah Data'),
        ),
        const PopupMenuItem<String>(
          value: 'Delete',
          child: Text('Hapus Artikel'),
        ),
      ],
      elevation: 3.0,
    ).then((value) async {
      if (value == 'Edit') {
        SharedCode.navigatorPush(context, ArticleFormPage(articleModel: widget.articleModel));
      }
      if (value == 'Delete') {
        _deleteArticle();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        padding: SharedCode.defaultPagePadding,
        child: _buildArticle(),
      ),
    );
  }

  Widget _buildArticle() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(widget.articleModel.title, style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600)),
      const SizedBox(height: 10.0),
      Text(SharedCode.dateFormat.format(widget.articleModel.createdAt), style: GoogleFonts.poppins(fontSize: 14, color: ColorValues.grey)),
      const SizedBox(height: 25.0),
      ClipRRect(
          borderRadius: BorderRadius.circular(10.0),
          child: CachedNetworkImage(imageUrl: widget.articleModel.imageUrl, width: 100.w, height: 25.h, fit: BoxFit.cover)
      ),
      const SizedBox(height: 25.0),
      Text(widget.articleModel.description.replaceAll('+', '\n'), style: GoogleFonts.poppins(fontSize: 14), textAlign: TextAlign.justify),
    ]);
  }

  AppBar _buildAppBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      centerTitle: true,
      title: Text('Detail Artikel', style: GoogleFonts.poppins(fontSize: 18)),
      leading: GestureDetector(
        onTap: () => Navigator.of(context).pop(),
        child: const Icon(Icons.arrow_back_ios, size: 20.0, color: ColorValues.grey),
      ),
      actions: [Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: GestureDetector(
            onTap: _showMoreMenus,
            child: const Icon(Icons.more_vert_rounded)
        ),
      )],
    );
  }

  Future<void> _deleteArticle() async {
    SharedCode.showAlertDialog(context, 'Hapus Artikel', 'Yakin untuk menghapus artikel ini?', 'Hapus', () async {
      context.loaderOverlay.show();

      try {
        await ArticlesRepository().deleteArticle(widget.articleModel.id);

        Future.delayed(Duration.zero, () {
          context.loaderOverlay.hide();
          SharedCode.navigatorReplace(context, const ArticleRemovedPage());
        });
      } catch (e) {
        context.loaderOverlay.hide();
        SharedCode.navigatorReplace(context, const DashboardPage());
        SharedCode.showSnackBar(context, false, e.toString());
      }
    });
  }
}
