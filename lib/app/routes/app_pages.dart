import 'package:get/get.dart';

import '../modules/dashboard/bindings/dashboard_binding.dart';
import '../modules/dashboard/views/dashboard_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/listPage/bindings/list_page_binding.dart';
import '../modules/listPage/views/list_page_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/moviePage/bindings/movie_page_binding.dart';
import '../modules/moviePage/views/movie_page_view.dart';
import '../modules/profile/bindings/profile_binding.dart';
import '../modules/profile/views/profile_view.dart';
import '../modules/searchPage/bindings/search_page_binding.dart';
import '../modules/searchPage/views/search_page_view.dart';
import '../modules/watchlist/bindings/watchlist_binding.dart';
import '../modules/watchlist/views/watchlist_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.DASHBOARD;

  static final routes = [
    GetPage(name: _Paths.HOME, page: () => HomeView(), binding: HomeBinding()),
    GetPage(name: _Paths.DASHBOARD, page: () => const DashboardView(), binding: DashboardBinding()),
    GetPage(name: _Paths.PROFILE, page: () => const ProfileView(), binding: ProfileBinding()),
    GetPage(name: _Paths.LOGIN, page: () => const LoginView(), binding: LoginBinding()),
    GetPage(name: _Paths.SEARCH_PAGE, page: () => const SearchPageView(), binding: SearchPageBinding()),
    GetPage(name: _Paths.WATCHLIST, page: () => const WatchlistView(), binding: WatchlistBinding()),
    GetPage(name: _Paths.MOVIE_PAGE, page: () => const MoviePageView(), binding: MoviePageBinding()),
    GetPage(name: _Paths.LIST_PAGE, page: () => const ListPageView(), binding: ListPageBinding()),
    GetPage(name: _Paths.HOME, page: () => const HomeView(), binding: HomeBinding()),
  ];
}
