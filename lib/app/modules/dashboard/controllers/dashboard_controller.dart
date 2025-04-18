import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:motion/motion.dart';
import 'package:tmdb/app/modules/searchPage/views/search_page_view.dart';
import 'package:tmdb/app/modules/watchlist/views/watchlist_view.dart';
import '../../../../data/models/ui_models.dart';
import '../../../../shared_pref_helper.dart';
import '../../../widgets/custom_dialogbox.dart';
import '../../home/views/home_view.dart';
import '../../profile/views/profile_view.dart';

class DashboardController extends GetxController {
  var currentIndex = 0.obs;
  final PageController pageController = PageController();

  void checkMotionPermission(BuildContext context) {
    if (Motion.instance.isPermissionRequired && !Motion.instance.isPermissionGranted) {
      showDialog(
        context: context,
        builder:
            (_) => CustomDialog(
              title: "Permission Needed",
              message: "This feature requires motion sensor permission. Please allow it.",
              confirmText: "Allow",
              onConfirm: () {
                Motion.instance.requestPermission();
              },
            ),
      );
    }
  }

  final List<NavItem> navItems = [
    NavItem(page: const HomeView(), icon: Icons.home, label: 'Home'),
    NavItem(page: const SearchPageView(), icon: Icons.search, label: 'Search'),
    NavItem(page: const WatchlistView(), icon: Icons.bookmark, label: 'Watchlist'),

    NavItem(
      page: const ProfileView(),
      icon: SharedPreferencesHelper.isLoggedIn() ? null : Icons.person,
      label: 'Profile',
      avatarUrl:
          SharedPreferencesHelper.isLoggedIn()
              ? SharedPreferencesHelper.getAvatarPath()
              : null, // No avatar for guest users
    ),
  ];

  void changePage(int index) {
    currentIndex.value = index;
    pageController.jumpToPage(index);
  }

  void updatePage(int index) {
    currentIndex.value = index;
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}
