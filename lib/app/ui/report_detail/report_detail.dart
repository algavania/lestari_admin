import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lestari_admin/app/ui/report_form/report_close_case_form.dart';
import 'package:lestari_admin/data/models/report_model.dart';
import 'package:sizer/sizer.dart';
import '../../common/color_values.dart';
import '../../common/shared_code.dart';

class ReportDetailPage extends StatefulWidget {
  final ReportModel reportModel;
  final int? index;
  const ReportDetailPage({Key? key, required this.reportModel, required this.index}) : super(key: key);

  @override
  State<ReportDetailPage> createState() => _ReportDetailPageState();
}

class _ReportDetailPageState extends State<ReportDetailPage> {
  final ValueNotifier<int> _selectedIndex = ValueNotifier(0);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: _selectedIndex,
        builder: (context, _, __){
          return Scaffold(
            appBar: _buildAppBar(),
            body: SingleChildScrollView(
              padding: SharedCode.defaultPagePadding,
              child: _ReportOpened(_selectedIndex.value),
            ),
          );
        });
  }

  _ReportOpened(int index) {
    bool isClosed = false;
    if(widget.index  == 1){
      isClosed = true;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children:  [
            Text(SharedCode.dateFormat.format(widget.reportModel.createdAt), style: GoogleFonts.poppins(color: const Color(0xff83858D), fontWeight: FontWeight.w400, fontSize: 11),),
            Text(widget.reportModel.category, style: GoogleFonts.poppins(color: const Color(0xff0787A3), fontWeight: FontWeight.w400, fontSize: 11),),
          ],
        ),
        const SizedBox(height: 25),
        Text(widget.reportModel.title, style: GoogleFonts.poppins(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 20),),
        const SizedBox(height: 25),
        Text('Status Kasus', style: GoogleFonts.poppins(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 14),),
        const SizedBox(height: 6),
        Text(widget.reportModel.isOpenIssue ? 'Terbuka' : 'Selesai', style: GoogleFonts.poppins(color: widget.reportModel.isOpenIssue ? ColorValues.universityRed : ColorValues.accentGreen, fontWeight: FontWeight.w400, fontSize: 14),),
        const SizedBox(height: 15),
        Text('Subjek', style: GoogleFonts.poppins(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 14),),
        const SizedBox(height: 6),
        Text(widget.reportModel.subject, style: GoogleFonts.poppins(color: Colors.black, fontWeight: FontWeight.w400, fontSize: 14),),
        const SizedBox(height: 15),
        Text('Deskripsi', style: GoogleFonts.poppins(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 14),),
        const SizedBox(height: 6),
        Text(widget.reportModel.description, style: GoogleFonts.poppins(color: Colors.black, fontWeight: FontWeight.w400, fontSize: 14),),
        const SizedBox(height: 15),
        Text('Bukti Gambar', style: GoogleFonts.poppins(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 14),),
        const SizedBox(height: 6),
        GridView.builder(
            shrinkWrap: true,
            itemCount: 5,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, childAspectRatio: 48.w / 20.h, mainAxisSpacing: 8.0, crossAxisSpacing: 4.0),
            itemBuilder: (BuildContext context, int index){
              return Card(
                child: Center(
                  child: CachedNetworkImage(imageUrl: widget.reportModel.imageUrls[index], fit: BoxFit.cover),),
              );
            }
        ),
        const SizedBox(height: 20),
        isClosed
            ? Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Detail Hasil Laporan', style: GoogleFonts.poppins(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 15),),
            const SizedBox(height: 20),
            Text('Tindakan yang dilakukan', style: GoogleFonts.poppins(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 14),),
            const SizedBox(height: 6),
            Text(widget.reportModel.action, style: GoogleFonts.poppins(color: Colors.black, fontWeight: FontWeight.w400, fontSize: 14),),
            const SizedBox(height: 15),
            Text('Alasan pemberlakuan tindakan', style: GoogleFonts.poppins(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 14),),
            const SizedBox(height: 6),
            Text(widget.reportModel.reason, style: GoogleFonts.poppins(color: Colors.black, fontWeight: FontWeight.w400, fontSize: 14),),
          ],
        ) : Container(
          width: 100.w,
          padding: const EdgeInsets.all(15.0),
          decoration: BoxDecoration(color: Colors.white, boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ]),
          child: ConstrainedBox(
            constraints: const BoxConstraints.expand( height: 100 ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    side: const BorderSide(width: 1, color: Colors.black),
                    primary: Colors.white,
                  ),
                  onPressed: () {
                  },
                  child:
                  Text('ke Detail Hewan' ),
                ),
                ElevatedButton(
                  onPressed: () {
                    SharedCode.navigatorPush(context, const ReportCloseCaseFormPage());
                  },
                  child:
                  Text('Tutup Kasus' ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
  AppBar _buildAppBar() {
    return AppBar(
      title: const Text('Detail Laporan'),
      automaticallyImplyLeading: false,
      leading: GestureDetector(
        onTap: () => Navigator.of(context).pop(),
        child: const Icon(Icons.arrow_back_ios, size: 20.0, color: ColorValues.grey),
      ),
    );
  }
  }





