import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerMovieCard extends StatelessWidget {
  const ShimmerMovieCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 8, offset: const Offset(0, 4))],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Shimmer.fromColors(
          baseColor: Colors.grey[800]!,
          highlightColor: Colors.grey[700]!,
          child: Container(padding: const EdgeInsets.all(8), color: Colors.grey[850]),
        ),
      ),
    );
  }
}
