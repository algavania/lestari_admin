import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lestari_admin/app/blocs/auth/auth_bloc.dart';
import 'package:lestari_admin/app/common/shared_code.dart';
import 'package:lestari_admin/app/repositories/auth/auth_repository.dart';
import 'package:lestari_admin/app/ui/dashboard/dashboard_page.dart';
import 'package:lestari_admin/widgets/custom_text_field.dart';
import 'package:sizer/sizer.dart';
import 'package:loader_overlay/loader_overlay.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  late BuildContext _context;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc(AuthRepository()),
      child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            _context = context;
            if (state is AuthLoading) {
              context.loaderOverlay.show();
              return _buildContent();
            }
            if (state is AuthInitial) {
              context.loaderOverlay.hide();
              return _buildContent();
            }
            if (state is AuthError) {
              context.loaderOverlay.hide();

              String snackBarText;
              switch (state.message) {
                case 'user-not-found':
                  snackBarText = 'Akun tidak ditemukan.';
                  break;
                case 'wrong-password':
                  snackBarText = 'Password salah.';
                  break;
                case 'not-admin':
                  snackBarText = 'Akun bukanlah akun admin.';
                  break;
                default:
                  snackBarText = 'Terjadi kesalahan.';
                  break;
              }

              SchedulerBinding.instance.addPostFrameCallback((_) {
                SharedCode.showSnackBar(context, false, snackBarText);
              });

              return _buildContent();
            }
            if (state is AuthLoaded) {
              context.loaderOverlay.hide();
              Future.delayed(Duration.zero, () {
                SharedCode.navigatorReplace(context, const DashboardPage());
              });
              return _buildContent();
            }
            return Container();
          }
      ),
    );
  }

  Widget _buildContent() {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: SharedCode.altPagePadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Image.asset('assets/login.png', width: 80.w,
                    height: 40.h,
                    fit: BoxFit.contain),
              ),
              Text(
                  'Selamat Datang',
                  style: GoogleFonts.poppins(
                      fontSize: 20, fontWeight: FontWeight.w600)
              ),
              const SizedBox(height: 8.0),
              Text('Masukkan akun Anda untuk melanjutkan.',
                  style: GoogleFonts.poppins(fontSize: 16)),
              const SizedBox(height: 15.0),
              CustomTextField(
                hintText: 'Email*',
                controller: _emailController,
                isRequired: true,
              ),
              const SizedBox(height: 10.0),
              CustomTextField(
                hintText: 'Password*',
                controller: _passwordController,
                isRequired: true,
                isPassword: true,
              ),
              // const SizedBox(height: 15.0),
              // Align(
              //   alignment: Alignment.centerRight,
              //   child: GestureDetector(
              //     onTap: () {
              //       SharedCode.navigatorPush(
              //           context, const ForgotPasswordInputPage());
              //     },
              //     child: Text('Lupa Password?', style: GoogleFonts.poppins(
              //         color: ColorValues.accentGreen, fontSize: 14)),
              //   ),
              // ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomWidget(),
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
              BlocProvider.of<AuthBloc>(_context).add(LoginEvent(_emailController.text, _passwordController.text));
            },
            child: const Text('Masuk')
        ),
    );
  }
}
