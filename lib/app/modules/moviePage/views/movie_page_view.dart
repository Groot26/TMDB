import 'package:flutter/material.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:get/get.dart';
import 'package:like_button/like_button.dart';
import 'package:motion/motion.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:tmdb/app/modules/watchlist/controllers/watchlist_controller.dart';
import 'package:tmdb/utils/color_theme.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../widgets/movie_card.dart';
import '../../../widgets/network_image.dart';
import '../controllers/movie_page_controller.dart';

class MoviePageView extends GetView<MoviePageController> {
  const MoviePageView({super.key});

  @override
  Widget build(BuildContext context) {
    MoviePageController controller = Get.put(MoviePageController());
    WatchlistController watchlistController = Get.put(WatchlistController());
    Size size = MediaQuery.of(context).size;

    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) {
          final hasRated = controller.rating['rated'] != false && controller.rating['rated'] != null;
          final isInWatchlist = controller.rating['watchlist'] == true;

          if (hasRated || !isInWatchlist) {
            await watchlistController.fetchAtInit();
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(controller.show['original_name'] ?? controller.show['original_title'] ?? "No title"),
          centerTitle: true,
        ),

        bottomNavigationBar: BottomAppBar(
          // height: 60,
          height: size.height * 0.075,
          child: Obx(
            () => Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                LikeButton(
                  isLiked: controller.rating['watchlist'] ?? false,
                  circleColor: CircleColor(start: Color(0xffffa4a2), end: Color(0xffe53935)),
                  bubblesColor: BubblesColor(dotPrimaryColor: Color(0xffff5252), dotSecondaryColor: Color(0xffc62828)),
                  likeBuilder: (bool isLiked) {
                    return Icon(size: 24, Icons.bookmark, color: isLiked ? Colors.red.shade900 : Colors.grey);
                  },
                  onTap: (isLiked) => controller.addToWatchlist(isLiked),
                ),

                Container(height: 40, width: 1, color: Colors.white),

                LikeButton(
                  isLiked: controller.rating['favorite'] ?? false,
                  size: 24,
                  circleColor: CircleColor(start: Color(0xffffc1e3), end: Color(0xfff06292)),
                  bubblesColor: BubblesColor(dotPrimaryColor: Color(0xffff80ab), dotSecondaryColor: Color(0xffec407a)),
                  onTap: (isLiked) => controller.addFavorite(isLiked),
                ),
              ],
            ),
          ),
        ),
        body: SafeArea(
          child: Obx(() {
            double score = (controller.showDetails.value?.voteAverage ?? 0).toDouble();

            if (controller.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }

            final show = controller.showDetails.value;

            if (show == null) {
              return const Center(child: Text("Something went wrong!"));
            }

            return RefreshIndicator(
              onRefresh: () async => controller.getData(),
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.zero, // optional
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          Stack(
                            children: [
                              show.backdropPath != null
                                  ? NetImage(
                                    imageUrl: 'https://image.tmdb.org/t/p/w500${show.backdropPath}',
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    height: MediaQuery.of(context).size.height * 0.26,
                                  )
                                  : NetImage(
                                    imageUrl: 'https://image.tmdb.org/t/p/w500${show.posterPath}',
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    height: MediaQuery.of(context).size.height * 0.26,
                                  ),

                              Container(
                                width: double.infinity,

                                height: MediaQuery.of(context).size.height * 0.26,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.centerLeft,
                                    end: Alignment.center,
                                    colors: [
                                      Colors.black.withOpacity(0.7),
                                      // Start dark
                                      Colors.transparent,
                                      // Fade to transparent
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),

                          Positioned(
                            top: 25,
                            left: 16,
                            child: LayoutBuilder(
                              builder: (context, constraints) {
                                double screenWidth = MediaQuery.of(context).size.width;
                                double imageWidth = screenWidth * 0.28;
                                double imageHeight = imageWidth * 1.5;

                                return Motion.elevated(
                                  elevation: 40,
                                  borderRadius: BorderRadius.circular(10),
                                  filterQuality: FilterQuality.high,
                                  glare: true,
                                  shadow: true,
                                  // shadowColor: Colors.black26,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: NetImage(
                                      imageUrl: 'https://image.tmdb.org/t/p/w500${show.posterPath}',
                                      fit: BoxFit.cover,
                                      width: imageWidth,
                                      height: imageHeight,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 16),
                            Center(
                              child: Text(show.name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                            ),

                            Padding(
                              padding: const EdgeInsets.all(16),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Row(
                                      children: [
                                        TweenAnimationBuilder<double>(
                                          tween: Tween(begin: 0, end: score / 10),
                                          duration: const Duration(milliseconds: 1200),
                                          curve: Curves.easeOutCubic,
                                          builder: (context, value, _) {
                                            return ClipOval(
                                              child: Container(
                                                color: Colors.black,
                                                padding: const EdgeInsets.all(0),
                                                child: CircularPercentIndicator(
                                                  radius: 28,
                                                  lineWidth: 4.5,
                                                  percent: value,
                                                  center: Text(
                                                    "${score.toStringAsFixed(1)}%",
                                                    style: const TextStyle(
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.white,
                                                      fontStyle: FontStyle.italic,
                                                      fontFamily: 'RobotoMono',
                                                    ),
                                                  ),
                                                  restartAnimation: true,
                                                  progressColor: getRatingColor(score),
                                                  backgroundColor: getRatingColor(score).withAlpha(80),
                                                  circularStrokeCap: CircularStrokeCap.round,
                                                ),
                                              ),
                                            );
                                          },
                                        ),

                                        SizedBox(width: 20),

                                        Text(
                                          "User\nScore",
                                          style: Theme.of(
                                            context,
                                          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ),

                                  Container(height: 40, width: 1, color: Colors.white),

                                  Expanded(
                                    child: Column(
                                      children: [
                                        RatingStars(
                                          value:
                                              controller.rating['rated'] is Map
                                                  ? controller.rating['rated']['value']
                                                  : 0.0,
                                          maxValueVisibility: true,
                                          starCount: 5,
                                          maxValue: 10,
                                          starSize: 20,
                                          animationDuration: Duration(seconds: 1),
                                          valueLabelVisibility: false,
                                          onValueChanged: (value) => controller.addRating(context, value),
                                        ),
                                        SizedBox(height: 10),
                                        Text(
                                          "Your Rating",
                                          style: Theme.of(
                                            context,
                                          ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.normal),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            SizedBox(height: 20),

                            Text(
                              show.tagline,
                              style: TextStyle(fontSize: 20, color: AppThemes.mutedText, fontWeight: FontWeight.normal),
                            ),
                            SizedBox(height: 20),
                            if (show.overview.isNotEmpty)
                              Text(
                                "Overview",
                                style: TextStyle(
                                  fontSize: 24,
                                  // color: AppThemes.mutedText,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                            Text(
                              show.overview,
                              style: TextStyle(fontSize: 16, color: AppThemes.mutedText, fontWeight: FontWeight.normal),
                            ),

                            SizedBox(height: 50),

                            Obx(() {
                              if (controller.providers.isEmpty) {
                                return Text(
                                  "No providers available",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: AppThemes.mutedText,
                                    fontWeight: FontWeight.normal,
                                  ),
                                );
                              }

                              return Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Now Streaming On', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                                  WatchProvidersWidget(providers: controller.providers),

                                  SizedBox(height: 50),

                                  Align(
                                    alignment: Alignment.bottomRight,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text('Data provided by ', style: TextStyle(fontSize: 12, color: Colors.grey)),
                                        Text(
                                          'JustWatch',
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            }),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}

class WatchProvidersWidget extends StatelessWidget {
  final Map<String, dynamic> providers;

  const WatchProvidersWidget({super.key, required this.providers});

  @override
  Widget build(BuildContext context) {
    if (providers.isEmpty) {
      return const Text("No providers available in your region.");
    }

    final types = ['flatrate', 'buy', 'rent', 'ads', 'free'];
    final link = providers['link'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children:
          types
              .where((type) => providers.containsKey(type) && providers[type] != null)
              .map(
                (type) =>
                    ProviderTypeRow(type: type, items: List<Map<String, dynamic>>.from(providers[type]), link: link),
              )
              .toList(),
    );
  }
}

class ProviderTypeRow extends StatelessWidget {
  final String type;
  final List<Map<String, dynamic>> items;
  final String? link;

  const ProviderTypeRow({super.key, required this.type, required this.items, this.link});

  String getTypeLabel(String type) {
    switch (type) {
      case 'flatrate':
        return "Stream with Subscription";
      case 'buy':
        return "Buy";
      case 'rent':
        return "Rent";
      case 'ads':
        return "Free with Ads";
      case 'free':
        return "Free";
      default:
        return type;
    }
  }

  void launchExternalUrl(String url) async {
    final uri = Uri.tryParse(url);
    if (uri == null) {
      debugPrint('Invalid URL: $url');
      return;
    }

    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      debugPrint('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        Text(
          getTypeLabel(type),
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppThemes.mutedText),
        ),
        const SizedBox(height: 8),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children:
                items
                    .map(
                      (provider) => Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: GestureDetector(
                          onTap: () => launchExternalUrl(link!),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              "https://image.tmdb.org/t/p/w92${provider['logo_path']}",
                              height: 40,
                              width: 40,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => const Icon(Icons.broken_image),
                            ),
                          ),
                        ),
                      ),
                    )
                    .toList(),
          ),
        ),
      ],
    );
  }
}
