import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lestari_admin/app/common/shared_code.dart';
import 'package:lestari_admin/app/ui/dashboard/dashboard_page.dart';
import 'package:sizer/sizer.dart';

class AnimalAddedPage extends StatefulWidget {
  final bool isEdit;
  const AnimalAddedPage({Key? key, required this.isEdit}) : super(key: key);

  @override
  State<AnimalAddedPage> createState() => _AnimalAddedPageState();
}

class _AnimalAddedPageState extends State<AnimalAddedPage> {
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
          ? Text('Hewan Ditambahkan', textAlign: TextAlign.center, style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 20))
          : Text('Data Diperbarui', textAlign: TextAlign.center, style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 20)),
          const SizedBox(height: 10.0),
          !widget.isEdit
          ? Text('Hewan berhasil ditambahkan. Kamu bisa menemukan hewan yang ditambahkan di halaman “Hewan”', textAlign: TextAlign.center, style: GoogleFonts.poppins(fontSize: 14))
          : Text('Data hewan berhasil diperbarui. Kamu bisa menemukan daftar hewan-hewan yang ada di halaman “Hewan”', textAlign: TextAlign.center, style: GoogleFonts.poppins(fontSize: 14)),
        ]),
      ),
    );
  }
}
