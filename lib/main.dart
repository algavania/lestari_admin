import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lestari_admin/app/common/app_theme_data.dart';
import 'package:lestari_admin/app/common/color_values.dart';
import 'package:lestari_admin/app/ui/splash/splash_page.dart';
import 'package:sizer/sizer.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'app/repositories/repositories.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await initializeDateFormatting('id_ID', null).then((_) => runApp(const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (context) => AnimalsRepository()),
        RepositoryProvider(create: (context) => ArticlesRepository()),
        RepositoryProvider(create: (context) => AuthRepository()),
        RepositoryProvider(create: (context) => CampaignsRepository()),
        RepositoryProvider(create: (context) => NotificationsRepository()),
        RepositoryProvider(create: (context) => ReportsRepository()),
        RepositoryProvider(create: (context) => UserRepository()),
      ],
      child: Sizer(
          builder: (_, __, ___) {
            return GlobalLoaderOverlay(
              useDefaultLoading: false,
              overlayWidget: const Center(child: SpinKitChasingDots(color: ColorValues.primaryYellow, size: 50.0)),
              child: MaterialApp(
                title: 'Lestari Admin',
                theme: AppThemeData.getTheme(context),
                home: const SplashPage(),
                debugShowCheckedModeBanner: false,
              ),
            );
          }
      ),
    );
  }
}