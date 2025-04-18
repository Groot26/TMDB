import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/api_value.dart';
import '../controllers/home_controller.dart';
import 'package:shimmer/shimmer.dart';

class HeroSection extends StatelessWidget {
  final HomeController controller = Get.find<HomeController>();

  HeroSection({super.key});

  @override
  Widget build(BuildContext context) {

    return Obx(() {
      if (controller.trendingMovies.isEmpty) {
        return Shimmer.fromColors(
          baseColor: Colors.grey.shade800,
          highlightColor: Colors.grey.shade700,
          child: Container(
            height: 300,
            width: double.infinity,
            color: Colors.grey.shade800,
            alignment: Alignment.bottomLeft,
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(height: 40, width: 200, color: Colors.grey),
                const SizedBox(height: 10),
                Container(height: 20, width: 300, color: Colors.grey),
              ],
            ),
          ),
        );
      }

      final imageUrl =
          "${ApiValue.imageBaseUrl}${controller.trendingMovies[controller.currentBackdropIndex.value]['backdrop_path']}";

      return Stack(
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 800),
            child: Image.network(
              imageUrl,
              key: ValueKey(imageUrl),
              width: double.infinity,
              height: 300,
              fit: BoxFit.cover,
            ),
          ),

          Container(
            height: 300,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.black.withOpacity(0.8), Colors.black.withOpacity(0.4), Colors.transparent],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
            ),
          ),

          Positioned(
            bottom: 30,
            left: 20,
            right: 20,
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "Welcome.\n",
                    style: GoogleFonts.bebasNeue(fontSize: 46, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  TextSpan(
                    text: "Millions of movies, TV shows and people to discover. Explore now.",
                    style: GoogleFonts.bebasNeue(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    });
  }
}
