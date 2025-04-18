import 'package:bounce/bounce.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../../core/api_value.dart';
import '../modules/moviePage/views/movie_page_view.dart';
import 'movie_card.dart';
import 'network_image.dart';

Widget showCard({required Map movie}) {
  String imageUrl = "${ApiValue.imageBaseUrl}${movie['poster_path']}";
  String title = movie['original_name'] ?? movie['original_title'];
  double rating = (movie['vote_average'] ?? 0).toDouble();

  return SizedBox(
    width: 150,
    child: Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 200,
              width: 140,
              child: Bounce(
                onTap: () => Get.to(MoviePageView(), arguments: movie),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 8, offset: Offset(0, 4))],
                  ),
                  child: ClipRRect(borderRadius: BorderRadius.circular(12), child: NetImage(imageUrl: imageUrl)),
                ),
              ),
            ),
            SizedBox(height: 16),
            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ],
        ),
        Positioned(
          bottom: 35,
          left: 8,
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: rating / 10),
            duration: const Duration(milliseconds: 1200),
            curve: Curves.easeOutCubic, // Fast start, slow end
            builder: (context, value, _) {
              return ClipOval(
                child: Container(
                  color: Colors.black, // This will now be truly circular
                  padding: const EdgeInsets.all(0),
                  child: CircularPercentIndicator(
                    radius: 20,
                    lineWidth: 3.5,
                    percent: value,
                    center: Text(
                      rating.toStringAsFixed(1),
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    restartAnimation: true,
                    progressColor: getRatingColor(rating),
                    backgroundColor: getRatingColor(rating).withAlpha(80),
                    // backgroundColor: Colors.transparent, // fully black
                    circularStrokeCap: CircularStrokeCap.round,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    ),
  );
}
