import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lestari_admin/app/common/shared_code.dart';
import 'package:lestari_admin/app/ui/dashboard/dashboard_page.dart';
import 'package:lestari_admin/app/ui/login/login_page.dart';
import 'package:sizer/sizer.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  Future<void> _navigateToOnboard() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      Future.delayed(const Duration(seconds: 3), () {
        SharedCode.navigatorReplace(context, const DashboardPage());
      });
    } else {
      Future.delayed(const Duration(seconds: 3), () {
        SharedCode.navigatorReplace(context, const LoginPage());
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _navigateToOnboard();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(child: Image.asset('assets/logo_letter.png', width: 70.w, height: 30.h,)),
      ),
    );
  }
}
