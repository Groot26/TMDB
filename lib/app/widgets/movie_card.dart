import 'package:bounce/bounce.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../../core/api_value.dart';
import '../modules/moviePage/views/movie_page_view.dart';
import 'network_image.dart';

Widget movieCard({required Map movie, required BuildContext context}) {
  String imageUrl = "${ApiValue.imageBaseUrl}${movie['poster_path']}";
  String title = movie['title'] ?? '';
  // String releaseDate = movie['release_date'] ?? '';
  double rating = (movie['vote_average'] ?? 0).toDouble();
  bool adult = movie['adult'];

  return Bounce(
    onTap: () {
      FocusScope.of(context).unfocus(); // Dismiss keyboard
      Get.to(() => MoviePageView(), arguments: movie);
    },
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 8, offset: Offset(0, 4))],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [
            Positioned.fill(child: NetImage(imageUrl: imageUrl)),

            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.transparent, Colors.black.withOpacity(0.8)],
                    begin: Alignment.center,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ),

            // Rating badge
            Positioned(
              top: 8,
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
                        radius: 18,
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

            // Adult badge (circular, bold and modern)
            adult
                ? Positioned(
                  top: 8,
                  right: 8,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.red.shade800,
                          border: Border.all(color: Colors.white, width: 2),
                          boxShadow: [
                            BoxShadow(color: Colors.red.shade900.withOpacity(0.6), blurRadius: 6, offset: Offset(0, 2)),
                          ],
                        ),
                        child: Stack(
                          children: [
                            // Diagonal Stroke (wider and inside circle)
                            Center(
                              child: Transform.rotate(
                                angle: -0.8,
                                child: Container(
                                  width: 2, // Wider stroke
                                  height: 36, // Fits inside the circle
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.8),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                              ),
                            ),
                            Center(
                              child: Text(
                                '18+',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 14,
                                  letterSpacing: 1,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
                : SizedBox(),

            Positioned(
              bottom: 10,
              left: 8,
              right: 8,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Color getRatingColor(double rating) {
  if (rating <= 4.0) {
    return Colors.red;
  } else if (rating < 7.0) {
    return Colors.yellow;
  } else {
    return Colors.green;
  }
}
