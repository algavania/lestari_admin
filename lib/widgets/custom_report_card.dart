import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lestari_admin/app/common/color_values.dart';
import 'package:lestari_admin/app/ui/report_detail/report_detail.dart';
import 'package:lestari_admin/data/models/report_model.dart';
import '../app/common/shared_code.dart';

class CustomReportCard extends StatelessWidget {
  final ReportModel reportModel;
  final int? index;
  const CustomReportCard({Key? key, required this.reportModel, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String category = '';
    Color color = const Color(0xFF000000);
    switch (reportModel.category) {
      case 'animals':
        category = 'Hewan';
        color = ColorValues.primaryYellow;
        break;
      case 'campaigns':
        category = 'Kampanye';
        color = const Color(0xFF0787A3);
        break;
      case 'Articles':
        category = 'Artikel';
        color = ColorValues.accentGreen;
        break;
    }

    return Container(
      width: MediaQuery.of(context).size.width,
      padding: SharedCode.defaultPagePadding,
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: ColorValues.lightGrey, width: 1),
        ),
      ),
     child: InkWell(
       onTap: () {
         SharedCode.navigatorPush(context, ReportDetailPage(reportModel: reportModel, index: index,));
       },
       child: Column(
         crossAxisAlignment: CrossAxisAlignment.start,
         children: <Widget>[
           Row(
             mainAxisAlignment: MainAxisAlignment.spaceBetween,
             children: <Widget> [
               Text(SharedCode.dateFormat.format(reportModel.createdAt), style: GoogleFonts.poppins(color: const Color(0xff83858D), fontWeight: FontWeight.w400, fontSize: 14),),
               Text(category, style: GoogleFonts.poppins(color: color, fontWeight: FontWeight.w400, fontSize: 14),),
             ],
           ),
           const SizedBox(height: 10.0),
           Text(reportModel.title, style: GoogleFonts.poppins(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 18),),
           const SizedBox(height: 3.0),
           Text(reportModel.subject, style: GoogleFonts.poppins(color: Colors.black87, fontWeight: FontWeight.w400, fontSize: 14),),
         ],
       ),
     ),
    );
  }
}
