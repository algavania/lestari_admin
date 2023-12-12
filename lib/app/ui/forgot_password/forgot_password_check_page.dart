import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lestari_admin/app/common/color_values.dart';
import 'package:lestari_admin/app/common/shared_code.dart';
import 'package:sizer/sizer.dart';

class ForgotPasswordCheckPage extends StatefulWidget {
  const ForgotPasswordCheckPage({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordCheckPage> createState() => _ForgotPasswordCheckPageState();
}

class _ForgotPasswordCheckPageState extends State<ForgotPasswordCheckPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar('Lupa Password'),
      body: Padding(
        padding: SharedCode.defaultPagePadding,
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Center(child: Image.asset('assets/icon_gmail.png', width: 25.w, height: 20.h, fit: BoxFit.contain)),
          Text('Cek Inbox Email Anda', textAlign: TextAlign.center, style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 20)),
          const SizedBox(height: 10.0),
          Text('Cek email dan ikuti instruksi untuk konfirmasi password baru.', textAlign: TextAlign.center, style: GoogleFonts.poppins(fontSize: 14)),
        ]),
      ),
    );
  }

  AppBar _buildAppBar(String title) {
    return AppBar(
      title: Text(title),
      automaticallyImplyLeading: false,
      leading: GestureDetector(
        onTap: () => Navigator.of(context).pop(),
        child: const Icon(Icons.arrow_back_ios, size: 20.0, color: ColorValues.grey),
      ),
      elevation: 0,
    );
  }
}
