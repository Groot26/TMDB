import 'package:bounce/bounce.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tmdb/app/widgets/network_image.dart';
import 'package:tmdb/utils/color_theme.dart';

import '../modules/moviePage/views/movie_page_view.dart';

class HorizontalMovieCard extends StatelessWidget {
  final Map movie;

  const HorizontalMovieCard({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);

    final String posterPath =
        movie['poster_path'] != null ? 'https://image.tmdb.org/t/p/w500${movie['poster_path']}' : '';
    // final String backdropPath =
    //     movie['backdrop_path'] != null
    //         ? 'https://image.tmdb.org/t/p/w500${movie['backdrop_path']}'
    //         : '';

    final double imageHeight = size.height * 0.23;
    final double imageWidth = size.width * 0.35;

    return Bounce(
      // onTap: () => Get.to(() => MoviePageView(), arguments: movie),
      onTap: () {
        FocusScope.of(context).unfocus(); // Dismiss keyboard
        Get.to(() => MoviePageView(), arguments: movie);
      },
      filterQuality: FilterQuality.high,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
        child: Card(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Poster Image
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: NetImage(imageUrl: posterPath, height: imageHeight, width: imageWidth),
              ),

              // Movie Details
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        movie['original_name'] ?? movie['original_title'] ?? "No title",
                        style: TextStyle(fontWeight: FontWeight.w700, fontSize: 24),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),

                      Text(
                        movie['release'] ?? 'June 25, 2015',
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 14, color: AppThemes.mutedText),
                      ),

                      const SizedBox(height: 6),
                      Text(
                        movie['overview'] ?? 'No description available.',
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 14),
                      ),

                      // IconButton(
                      //   onPressed: () {},
                      //   icon: Icon(Icons.close),
                      //   iconSize: 30,
                      //   splashColor: Colors.transparent,
                      //   highlightColor: Colors.transparent,
                      // ),

                      // Wrap(
                      //   spacing: 8,
                      //   runSpacing: 8,
                      //   children: List.generate(2, (index) {
                      //     return IconButton(
                      //       onPressed: () {},
                      //       icon: const Icon(Icons.ac_unit),
                      //       tooltip: 'Button $index',
                      //     );
                      //   }),
                      // ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ShimmerHorizontalMovieCard extends StatelessWidget {
  const ShimmerHorizontalMovieCard({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final double imageHeight = size.height * 0.23;
    final double imageWidth = size.width * 0.35;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
      child: Card(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Shimmer Poster Image
            Shimmer.fromColors(
              baseColor: Colors.grey[800]!,
              highlightColor: Colors.grey[700]!,
              child: Container(
                height: imageHeight,
                width: imageWidth,
                decoration: BoxDecoration(color: Colors.grey[800], borderRadius: BorderRadius.circular(10)),
              ),
            ),
            const SizedBox(width: 8),

            // Shimmer Text Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    shimmerBox(width: size.width * 0.4, height: 20),
                    const SizedBox(height: 10),
                    shimmerBox(width: size.width * 0.3, height: 14),
                    const SizedBox(height: 10),
                    shimmerBox(width: size.width * 0.45, height: 14),
                    const SizedBox(height: 6),
                    shimmerBox(width: size.width * 0.35, height: 14),
                    const SizedBox(height: 6),
                    shimmerBox(width: size.width * 0.3, height: 14),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget shimmerBox({required double width, required double height}) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[800]!,
      highlightColor: Colors.grey[700]!,
      child: Container(width: width, height: height, color: Colors.grey[800]),
    );
  }
}
