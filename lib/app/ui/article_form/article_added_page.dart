import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lestari_admin/app/common/shared_code.dart';
import 'package:lestari_admin/app/ui/dashboard/dashboard_page.dart';
import 'package:sizer/sizer.dart';

class ArticleAddedPage extends StatefulWidget {
  final bool isEdit;
  const ArticleAddedPage({Key? key, required this.isEdit}) : super(key: key);

  @override
  State<ArticleAddedPage> createState() => _ArticleAddedPageState();
}

class _ArticleAddedPageState extends State<ArticleAddedPage> {
  Future<void> _navigateToDashboard() async {
    await Future.delayed(const Duration(seconds: 3));
    SharedCode.navigatorReplace(context, const DashboardPage());
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _navigateToDashboard();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: SharedCode.defaultPagePadding,
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Center(child: Image.asset('assets/icon_check.png', width: 25.w, height: 20.h, fit: BoxFit.contain)),
          !widget.isEdit
          ? Text('Artikel Diunggah', textAlign: TextAlign.center, style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 20))
          : Text('Artikel Diperbarui', textAlign: TextAlign.center, style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 20)),
          const SizedBox(height: 10.0),
          !widget.isEdit
          ? Text('Artikel berhasil dibuat. Kamu bisa menemukan artikel buatanmu di halaman “Artikel”', textAlign: TextAlign.center, style: GoogleFonts.poppins(fontSize: 14))
          : Text('Artikel berhasil diperbarui. Kamu bisa menemukan daftar artikel di halaman "Artikel”', textAlign: TextAlign.center, style: GoogleFonts.poppins(fontSize: 14)),
        ]),
      ),
    );
  }
}
