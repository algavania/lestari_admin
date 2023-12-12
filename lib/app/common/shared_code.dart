import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lestari_admin/app/common/color_values.dart';
import 'package:lestari_admin/widgets/custom_text_field.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedCode {
  static EdgeInsets defaultPagePadding = const EdgeInsets.symmetric(vertical: 20.0, horizontal: 15.0);
  static EdgeInsets altPagePadding = const EdgeInsets.symmetric(vertical: 25.0, horizontal: 20.0);
  static DateFormat dateFormat = DateFormat('d MMMM yyyy', 'id_ID');
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  static void navigatorPush(BuildContext context, Widget widget) {
    Navigator.push(context, MaterialPageRoute(builder: (c) => widget));
  }

  static void navigatorReplace(BuildContext context, Widget widget) {
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (c) => widget), (route) => false);
  }

  static void showSnackBar(BuildContext context, bool isSuccess, String content) {
    SnackBar snackBar = SnackBar(
      content: Text(content, style: const TextStyle(color: Colors.white)),
      backgroundColor: isSuccess ? null : ColorValues.universityRed,
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  static void showAlertDialog(BuildContext context, String title, String description, String yesButton, Function() yesAction) {
    Widget cancelButton = TextButton(
      child: Text('Batal', style: GoogleFonts.poppins(color: ColorValues.accentGreen)),
      onPressed:  () => Navigator.of(context).pop(),
    );

    Widget continueButton = TextButton(
      onPressed: yesAction,
      child: Text(yesButton, style: GoogleFonts.poppins(color: ColorValues.accentGreen)),
    );

    AlertDialog alert = AlertDialog(
      title: Text(title, style: GoogleFonts.poppins(fontWeight: FontWeight.w500)),
      content: Text(description),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  static AppBar buildSearchAppBar({bool isWithLeading = false, required BuildContext context, required String searchHint, required String title, void Function(String?)? onChanged, void Function()? onTap}) {
    return AppBar(
      automaticallyImplyLeading: !isWithLeading,
      toolbarHeight: 115,
      flexibleSpace: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  if (isWithLeading) GestureDetector(onTap: () => Navigator.of(context).pop(), child: const Icon(Icons.arrow_back_ios, color: ColorValues.grey, size: 20.0,)),
                  if (isWithLeading)const SizedBox(width: 8.0),
                  Text(title, style: GoogleFonts.poppins(fontWeight: FontWeight.w500, fontSize: 18)),
                ],
              ),
              const SizedBox(height: 10.0),
              Row(children: [
                Expanded(
                    child: CustomTextField(
                      verticalPadding: 10.0,
                      prefixIcon: const Icon(Icons.search, size: 22.0),
                      hintText: searchHint,
                      fontSize: 14,
                      onChanged: onChanged,
                    )
                ),
                // const SizedBox(width: 10.0),
                // InkWell(
                //   onTap: () {
                //     onTap?.call();
                //   },
                //   child: Container(
                //     width: 41.0,
                //     height: 41.0,
                //     decoration: BoxDecoration(border: Border.all(color: ColorValues.lightGrey), borderRadius: BorderRadius.circular(10.0)),
                //     child: Icon(Icons.filter_alt, color: Theme.of(context).primaryColor,),
                //   ),
                // )
              ]),
            ],
          ),
        ),
      ),
    );
  }

  static Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    await FirebaseAuth.instance.signOut();
  }
}