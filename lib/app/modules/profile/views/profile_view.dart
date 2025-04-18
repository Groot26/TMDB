import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tmdb/utils/color_theme.dart';

import '../../../../shared_pref_helper.dart';
import '../../../widgets/login_overlay.dart';
import '../../../widgets/showLane.dart';
import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    ProfileController controller = Get.put(ProfileController());
    final isLoggedIn = SharedPreferencesHelper.isLoggedIn();

    return Scaffold(
      body: Stack(
        children: [
          RefreshIndicator(
            onRefresh: () async => controller.getData(),
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 220,
                    child: Stack(
                      children: [
                        Container(width: double.infinity, height: 150, color: AppThemes.card),

                        Positioned(
                          right: 10,
                          top: 30,
                          child: IconButton(
                            onPressed: () async {
                              await SharedPreferencesHelper.logout();
                              Get.offAllNamed('/login');
                            },
                            icon: Icon(Icons.logout),
                            tooltip: "Logout",
                          ),
                        ),

                        Positioned(
                          bottom: 0,
                          left: MediaQuery.sizeOf(context).width * 0.5 - 70, // 50 is the radius
                          child: CircleAvatar(
                            backgroundColor: Colors.black,
                            backgroundImage: NetworkImage(SharedPreferencesHelper.getAvatarPath()),
                            radius: 70,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Center(child: Text(controller.name, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
                  Center(child: Text(controller.userName, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),

                  SizedBox(height: 20),

                  if (isLoggedIn)
                    Obx(
                      () => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          showLane(
                            title: "Favorite Movies",
                            movies: controller.favoriteMovies,
                            isLoading: controller.isLoadingFavoriteMovies,
                            totalPages: controller.totalFavoriteMoviePages,
                            type: 'movies',
                            endpoint: 'favorite',
                          ),

                          SizedBox(height: 20),

                          showLane(
                            title: "Favorite TV show",
                            movies: controller.favoriteTvShows,
                            isLoading: controller.isLoadingFavoriteTv,
                            totalPages: controller.totalFavoriteTvPages,
                            type: 'tv',
                            endpoint: 'favorite',
                          ),

                          SizedBox(height: 20),

                          showLane(
                            title: "Rated Movies",
                            movies: controller.ratedMovies,
                            isLoading: controller.isLoadingRatedMovies,
                            totalPages: controller.totalRatedMoviePages,
                            type: 'movies',
                            endpoint: 'rated',
                          ),

                          SizedBox(height: 20),

                          showLane(
                            title: "Rated Tv Shows",
                            movies: controller.ratedTvShows,
                            isLoading: controller.isLoadingRatedTv,
                            totalPages: controller.totalRatedTvPages,
                            type: 'tv',
                            endpoint: 'rated',
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),

          if (!isLoggedIn) const LoginOverlay(),
        ],
      ),
    );
  }
}
