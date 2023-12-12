import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lestari_admin/app/blocs/user/user_bloc.dart';
import 'package:lestari_admin/app/common/color_values.dart';
import 'package:lestari_admin/app/common/shared_code.dart';
import 'package:lestari_admin/app/repositories/user/user_repository.dart';
import 'package:lestari_admin/app/ui/campaign_archive/campaign_archive_page.dart';
import 'package:lestari_admin/app/ui/login/login_page.dart';
import 'package:lestari_admin/data/models/user_model.dart';
import 'package:lestari_admin/widgets/custom_loading.dart';
import 'package:sizer/sizer.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late UserModel _userModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Padding(
        padding: EdgeInsets.all(15.0),
        child: Text('Profil'),
      )),
      body: BlocProvider(
        create: (context) =>
        UserBloc(RepositoryProvider.of<UserRepository>(context))
          ..add(const GetUserByIdEvent('CURRENT_USER')),
        child: BlocBuilder<UserBloc, UserState>(
            builder: (context, state) {
              if (state is UserLoading) {
                return const CustomLoading();
              }
              if (state is UserInitial) {
                return Container();
              }
              if (state is UserError) {
                return Center(child: Text(state.message));
              }
              if (state is UserLoaded) {
                _userModel = state.userModel;
                return _buildPage();
              }
              return Container();
            }
        ),
      ),
    );
  }

  Widget _buildPage() {
    return SingleChildScrollView(
      child: Padding(
        padding: SharedCode.altPagePadding,
        child: Column(children: [
          _buildProfile(),
          const SizedBox(height: 50.0),
          _buildMenu('Arsip Kampanye', Icons.archive_outlined, () {
            SharedCode.navigatorPush(context, const CampaignArchivePage());
          }),
          _buildMenu('Keluar', Icons.logout, () async {
            SharedCode.showAlertDialog(context, 'Konfirmasi', 'Apakah kamu yakin ingin keluar dari Lestari?', 'Ya', () async {
              await SharedCode.logout();
              SharedCode.navigatorReplace(context, const LoginPage());
            });
          }),
        ]),
      ),
    );
  }

  Widget _buildProfile() {
    return Column(children: [
      Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(100.0),
          child: CachedNetworkImage(imageUrl: 
            _userModel.imageUrl,
            width: 22.w,
            height: 22.w,
          ),
        ),
      ),
      const SizedBox(height: 15.0),
      Text(_userModel.name, style: GoogleFonts.poppins(
          fontSize: 18, fontWeight: FontWeight.w500)),
      Text(_userModel.email, style: GoogleFonts.poppins(fontSize: 14,
          fontWeight: FontWeight.w500,
          color: ColorValues.grey)),
    ]);
  }

  Widget _buildMenu(String title, IconData iconData, Function() onTap) {
    Color color = ColorValues.onyx;
    if (title == 'Keluar') color = ColorValues.universityRed;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
          onTap: onTap,
          child: Row(children: [
            Icon(iconData, color: color),
            Expanded(child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
              child: Text(title, style: GoogleFonts.poppins(fontSize: 14, color: color)),
            )),
            Icon(Icons.chevron_right, color: color),
          ])
      ),
    );
  }
}
