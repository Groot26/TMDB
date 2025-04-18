import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../shared_pref_helper.dart';
import '../../../../utils/color_theme.dart';
import '../controllers/dashboard_controller.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  final DashboardController controller = Get.put(DashboardController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.checkMotionPermission(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DoubleBackToCloseApp(
        snackBar: SnackBar(
          content: const Text('Press back again to exit', style: TextStyle(color: Colors.white)),
          showCloseIcon: true,
          backgroundColor: Colors.black87,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          margin: const EdgeInsets.all(16),
          elevation: 6,
        ),

        child: PageView(
          controller: controller.pageController,
          physics: const ClampingScrollPhysics(),
          onPageChanged: controller.changePage,
          children: controller.navItems.map((item) => item.page).toList(),
        ),
      ),

      bottomNavigationBar: Obx(() {
        return BottomNavigationBar(
          currentIndex: controller.currentIndex.value,
          onTap: controller.changePage,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: AppThemes.primary,
          unselectedItemColor: AppThemes.mutedText,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          items:
              controller.navItems
                  .map(
                    (item) => BottomNavigationBarItem(
                      icon:
                          item.label == "Profile" &&
                                  SharedPreferencesHelper.isLoggedIn() &&
                                  SharedPreferencesHelper.getAvatarPath().isNotEmpty
                              ? CircleAvatar(
                                backgroundColor: AppThemes.secondary,
                                backgroundImage: NetworkImage(SharedPreferencesHelper.getAvatarPath()),
                                radius: 12,
                              )
                              : Icon(item.icon),
                      label: item.label,
                    ),
                  )
                  .toList(),
        );
      }),
    );
  }
}
