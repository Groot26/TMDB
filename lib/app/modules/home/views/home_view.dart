import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tmdb/app/modules/home/views/hero.dart';
import 'package:tmdb/app/widgets/small_switch.dart';
import '../../../widgets/showLane.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    HomeController controller = Get.put(HomeController());
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async => controller.getShow(),
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                HeroSection(),

                SizedBox(height: 20),

                Obx(
                  () => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      showLane(
                        title: "Trending Movies",
                        movies: controller.trendingMovies,
                        isLoading: controller.isTrendingLoading,
                        background: true,
                        totalPages: 1.obs,
                        type: 'movies',
                        filter: smallSwitch(
                          current: controller.isWeekly.value,
                          firstIcon: Icons.calendar_month,
                          secondIcon: Icons.today,
                          onChanged: controller.toggleTrending,
                        ),
                      ),

                      SizedBox(height: 20),

                      showLane(
                        title: "Free to Watch",
                        movies: controller.freeToWatch,
                        isLoading: controller.isFreeLoading,
                        background: true,
                        totalPages: 1.obs,
                        type: 'movies',
                        filter: smallSwitch(
                          current: controller.isFreeToWatchTv.value,
                          firstIcon: Icons.movie,
                          secondIcon: Icons.tv,
                          onChanged: controller.toggleFreeToWatch,
                        ),
                      ),

                      SizedBox(height: 20),

                      showLane(
                        title: "Top Rated",
                        movies: controller.topRatedMovies,
                        isLoading: controller.isTopRatedLoading,
                        background: true,
                        totalPages: 1.obs,
                        type: 'movies',
                        filter: smallSwitch(
                          current: controller.isTopRatedTv.value,
                          firstIcon: Icons.movie,
                          secondIcon: Icons.tv,
                          onChanged: controller.toggleTopRated,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
