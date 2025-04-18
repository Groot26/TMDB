import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:tmdb/app/widgets/movie_card.dart';
import 'package:tmdb/utils/color_theme.dart';

import '../../../widgets/shimmer_image.dart';
import '../controllers/search_page_controller.dart';

class SearchPageView extends GetView<SearchPageController> {
  const SearchPageView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SearchPageController());
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Obx(
            () => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Search", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),

                      SizedBox(
                        width: 120,
                        child: AnimatedToggleSwitch<bool>.dual(
                          current: controller.isTVShow.value,
                          first: false,
                          second: true,
                          animationDuration: const Duration(milliseconds: 300),
                          height: 40,
                          fittingMode: FittingMode.preventHorizontalOverlapping,
                          style: ToggleStyle(
                            borderColor: theme.colorScheme.primary.withOpacity(0.4),
                            backgroundColor: theme.cardColor,
                            indicatorColor: theme.colorScheme.primary,
                            indicatorBorderRadius: BorderRadius.circular(25),
                            borderRadius: BorderRadius.circular(25),
                            boxShadow: [
                              BoxShadow(
                                color: theme.shadowColor.withOpacity(0.15),
                                blurRadius: 6,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          onChanged: (val) => controller.toggle(val),
                          iconBuilder:
                              (value) => Icon(value ? Icons.tv : Icons.movie, color: theme.colorScheme.onPrimary),
                          textBuilder:
                              (value) => Text(
                                value ? 'TV' : 'Movies',
                                style: theme.textTheme.labelLarge?.copyWith(
                                  color: theme.colorScheme.onPrimary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                        ),
                      ),
                    ],
                  ),
                ),

                TextFormField(
                  controller: controller.searchController,
                  onChanged: controller.onSearchChanged,
                  autofocus: false,
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    hintStyle: TextStyle(color: AppThemes.mutedText, fontSize: 16, fontWeight: FontWeight.bold),
                    hintText: 'Search movies, Tv shows, and more...',
                    labelStyle: TextStyle(color: Colors.black),
                    prefixIcon: Icon(Icons.search_rounded, size: 28, color: Colors.black),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide.none),
                    filled: true,
                    contentPadding: EdgeInsets.symmetric(horizontal: 16),
                    suffixIcon:
                        controller.searchController.text.isNotEmpty
                            ? IconButton(
                              icon: Icon(Icons.clear),
                              color: Colors.black,
                              onPressed: () {
                                controller.searchController.clear();
                              },
                            )
                            : SizedBox.shrink(),
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () => controller.onRefresh(),
                    child: GridView.builder(
                      controller: controller.scrollController,
                      itemCount: controller.movies.isNotEmpty ? controller.movies.length : 10,
                      shrinkWrap: true,
                      physics: const AlwaysScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                        childAspectRatio: 0.8,
                      ),
                      itemBuilder:
                          (context, index) =>
                              controller.movies.isNotEmpty
                                  ? movieCard(movie: controller.movies[index], context: context)
                                  : const ShimmerMovieCard(),
                    ),
                  ),
                ),
                Obx(
                  () =>
                      controller.isLoadingMore.value
                          ? const Padding(
                            padding: EdgeInsets.symmetric(vertical: 20),
                            child: Center(child: CircularProgressIndicator()),
                          )
                          : const SizedBox.shrink(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
