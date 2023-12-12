import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lestari_admin/app/common/shared_code.dart';
import 'package:lestari_admin/data/models/article_model.dart';
import 'package:lestari_admin/app/ui/article_detail/article_detail.dart';
import 'package:sizer/sizer.dart';

class CustomArticleCard extends StatelessWidget {
  final ArticleModel articleModel;
  const CustomArticleCard({Key? key, required this.articleModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100.w,
      height: 37.h,
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: InkWell(
        onTap: () {
          SharedCode.navigatorPush(context, ArticleDetailPage(articleModel: articleModel));
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(5.0),
                  child: CachedNetworkImage(imageUrl: articleModel.imageUrl, fit: BoxFit.cover, width: 100.w)
              ),
            ),
            const SizedBox(height: 7.0),
            Text(articleModel.title, maxLines: 2, overflow: TextOverflow.ellipsis, style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 5.0),
            Text(articleModel.description, maxLines: 2, overflow: TextOverflow.ellipsis, style: GoogleFonts.poppins(fontSize: 12)),
            const SizedBox(height: 10.0),
            Text(SharedCode.dateFormat.format(articleModel.createdAt), style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }
}
