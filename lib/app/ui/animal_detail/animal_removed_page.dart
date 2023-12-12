import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lestari_admin/app/common/shared_code.dart';
import 'package:lestari_admin/app/ui/dashboard/dashboard_page.dart';
import 'package:sizer/sizer.dart';

class AnimalRemovedPage extends StatefulWidget {
  const AnimalRemovedPage({Key? key}) : super(key: key);

  @override
  State<AnimalRemovedPage> createState() => _AnimalRemovedPageState();
}

class _AnimalRemovedPageState extends State<AnimalRemovedPage> {
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
          Center(child: Image.asset('assets/icon_remove.png', width: 25.w, height: 20.h, fit: BoxFit.contain)),
          Text('Hewan Dihapus', textAlign: TextAlign.center, style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 20)),
        ]),
      ),
    );
  }
}
