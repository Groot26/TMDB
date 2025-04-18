import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:tmdb/app/widgets/horizontal_movie_card.dart';
import 'package:tmdb/shared_pref_helper.dart';
import '../../../widgets/login_overlay.dart';
import '../controllers/watchlist_controller.dart';

class WatchlistView extends GetView<WatchlistController> {
  const WatchlistView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(WatchlistController());
    final isLoggedIn = SharedPreferencesHelper.isLoggedIn();

    return Scaffold(
      body: DefaultTabController(
        length: 2,
        child: SafeArea(
          child: Stack(
            children: [
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("My Watchlist", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                        SizedBox(
                          width: 200,
                          child: TabBar(
                            controller: controller.tabController,
                            dividerHeight: 0,
                            splashFactory: NoSplash.splashFactory,
                            tabs: const [Tab(text: "Movies"), Tab(text: "TV Shows")],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: TabBarView(
                      controller: controller.tabController,
                      children: [
                        Obx(
                          () => _buildWatchlistList(
                            isLoading: controller.isLoadingMovies.value,
                            items: controller.movies,
                            onRefresh: () async {
                              controller.currentMoviePage.value = 1;
                              await controller.fetchWatchlist(type: 'movies');
                            },
                          ),
                        ),
                        Obx(
                          () => _buildWatchlistList(
                            isLoading: controller.isLoadingTv.value,
                            items: controller.tvShows,
                            onRefresh: () async {
                              controller.currentTvPage.value = 1;
                              await controller.fetchWatchlist(type: 'tv');
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              if (!isLoggedIn) const LoginOverlay(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWatchlistList({
    required bool isLoading,
    required List items,
    required Future<void> Function() onRefresh,
  }) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child:
          isLoading
              ? ListView.builder(itemCount: 6, itemBuilder: (context, index) => const ShimmerHorizontalMovieCard())
              : items.isEmpty
              ? SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: SizedBox(
                  height: Get.height * 0.8,
                  child: Center(
                    child: Lottie.asset(
                      'assets/gif/empty-gif.json',
                      frameRate: FrameRate(60),
                      height: Get.height * 0.35,
                    ),
                  ),
                ),
              )
              : ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) => HorizontalMovieCard(movie: items[index]),
              ),
    );
  }
}
