import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:motion/motion.dart';
import 'package:tmdb/shared_pref_helper.dart';
import 'package:tmdb/utils/color_theme.dart';

import 'app/modules/dashboard/bindings/dashboard_binding.dart';
import 'app/modules/dashboard/views/dashboard_view.dart';
import 'app/modules/login/bindings/login_binding.dart';
import 'app/modules/login/views/login_view.dart';
import 'app/routes/app_pages.dart';
import 'controller/theme_controller.dart';

late Box box;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Motion.instance.initialize();
  Motion.instance.setUpdateInterval(60.fps);

  await SharedPreferencesHelper.init();
  await dotenv.load(fileName: ".env");
  await Hive.initFlutter().then((_) async {
    await Hive.openBox('myBox').then((value) => box = Hive.box('myBox'));
  });

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final ThemeController themeController = Get.put(ThemeController());

  bool isLoggedIn = SharedPreferencesHelper.isLoggedIn();

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => GetMaterialApp(
        title: 'Movie WishList',
        debugShowCheckedModeBanner: false,
        transitionDuration: const Duration(milliseconds: 500),
        defaultTransition: Transition.rightToLeft,
        getPages: AppPages.routes,
        home: isLoggedIn ? DashboardView() : LoginView(),
        initialBinding: isLoggedIn ? DashboardBinding() : LoginBinding(),
        theme: AppThemes.darkTheme,
        darkTheme: AppThemes.darkTheme,
        themeMode: themeController.isDarkMode.value ? ThemeMode.dark : ThemeMode.light,
      ),
    );
  }
}
