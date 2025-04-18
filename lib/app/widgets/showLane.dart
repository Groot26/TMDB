import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tmdb/app/modules/listPage/views/list_page_view.dart';
import 'package:tmdb/app/widgets/shimmer_image.dart';
import 'package:tmdb/app/widgets/show_card.dart';
import '../../utils/color_theme.dart';
import '../modules/listPage/bindings/list_page_binding.dart';

Widget showLane({
  required String title,
  required RxList movies,
  required RxBool isLoading,
  required RxInt totalPages,
  required String type,
  String endpoint = "",
  bool background = false,
  Widget filter = const SizedBox(),
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            // SizedBox(width: 20),
            filter,
          ],
        ),
      ),

      if (totalPages.value > 1)
        Align(
          alignment: Alignment.topRight,
          child: GestureDetector(
            onTap:
                () => Get.to(
                  () => ListPageView(),
                  binding: ListPageBinding(),
                  arguments: {
                    "title": title,
                    "show": movies,
                    'total_pages': totalPages,
                    'type': type,
                    'endpoint': endpoint,
                  },
                ),
            child: Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Text("View All", style: const TextStyle(fontSize: 14, fontWeight: FontWeight.normal)),
            ),
          ),
        ),

      // Reactive loading & list builder
      SizedBox(
        height: 290,
        child: Stack(
          children: [
            // Background Image
            if (background) Positioned.fill(child: Image.asset("assets/images/background_ui.png", fit: BoxFit.cover)),

            // Blur Gradient
            if (background)
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.transparent, AppThemes.background.withOpacity(.8)],
                      begin: Alignment.center,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ),

            // Movie list
            Obx(
              () => Positioned.fill(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                  scrollDirection: Axis.horizontal,
                  itemCount: isLoading.value ? 4 : movies.length,
                  itemBuilder:
                      (context, index) => Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child:
                            isLoading.value
                                ? SizedBox(width: 150, child: ShimmerMovieCard())
                                : showCard(movie: movies[index]),
                      ),
                ),
              ),
            ),
          ],
        ),
      ),
    ],
  );
}
