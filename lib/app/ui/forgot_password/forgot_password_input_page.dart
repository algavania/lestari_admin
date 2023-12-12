import 'package:flutter/material.dart';
import 'package:lestari_admin/app/common/color_values.dart';
import 'package:lestari_admin/app/common/shared_code.dart';
import 'package:lestari_admin/widgets/custom_text_field.dart';
import 'package:lestari_admin/app/ui/forgot_password/forgot_password_check_page.dart';
import 'package:sizer/sizer.dart';

class ForgotPasswordInputPage extends StatefulWidget {
  const ForgotPasswordInputPage({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordInputPage> createState() => _ForgotPasswordInputPageState();
}

class _ForgotPasswordInputPageState extends State<ForgotPasswordInputPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar('Lupa Password'),
      body: SingleChildScrollView(
        padding: SharedCode.defaultPagePadding,
        child: Column(children: const [
          Text('Masukkan email akun Anda untuk me-reset password.'),
          SizedBox(height: 25.0),
          CustomTextField(labelText: 'Email', isRequired: true),
        ]),
      ),
      bottomNavigationBar: _buildBottomWidget(),
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

  Widget _buildBottomWidget() {
    return Container(
      width: 100.w,
      padding: const EdgeInsets.all(15.0),
      decoration: BoxDecoration(color:Colors.white, boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          spreadRadius: 5,
          blurRadius: 7,
          offset: const Offset(0, 3), // changes position of shadow
        ),
      ]),
      child: ElevatedButton(
        onPressed: () {
          SharedCode.navigatorPush(context, const ForgotPasswordCheckPage());
        },
        child: const Text('Lanjutkan'),
      ),
    );
  }
}
