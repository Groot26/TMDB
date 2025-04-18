import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../widgets/movie_card.dart';
import '../../../widgets/shimmer_image.dart';
import '../controllers/list_page_controller.dart';

class ListPageView extends GetView<ListPageController> {
  const ListPageView({super.key});

  @override
  Widget build(BuildContext context) {
    final ScrollController scrollController = ScrollController();
    Size size = MediaQuery.of(context).size;

    scrollController.addListener(() {
      if (scrollController.position.pixels >= scrollController.position.maxScrollExtent - 200 &&
          !controller.isLoadingMore.value &&
          controller.currentPage.value <= controller.totalPages.value) {
        controller.fetchCustom(isLoadMore: true);
      }
    });

    return Scaffold(
      appBar: AppBar(title: Text(controller.title), centerTitle: true),
      body: SafeArea(
        child: Obx(() {
          return Column(
            children: [
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    controller.currentPage.value = 1;
                    await controller.fetchCustom();
                  },
                  child:
                      controller.isLoading.value
                          ? GridView.builder(
                            padding: const EdgeInsets.all(8.0),
                            itemCount: 6,
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: size.width > 600 ? 3 : 2,
                              crossAxisSpacing: 8,
                              mainAxisSpacing: 8,
                              childAspectRatio: 0.8,
                            ),
                            itemBuilder: (context, index) {
                              return const ShimmerMovieCard();
                            },
                          )
                          : LayoutBuilder(
                            builder: (context, constraints) {
                              int crossAxisCount = constraints.maxWidth > 600 ? 3 : 2;

                              return GridView.builder(
                                controller: scrollController,
                                padding: const EdgeInsets.all(8.0),
                                itemCount: controller.movies.length,
                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: crossAxisCount,
                                  crossAxisSpacing: 8,
                                  mainAxisSpacing: 8,
                                  childAspectRatio: 0.8,
                                ),
                                itemBuilder: (context, index) {
                                  return movieCard(movie: controller.movies[index], context: context);
                                },
                              );
                            },
                          ),
                ),
              ),

              // Bottom loader
              Obx(
                () =>
                    controller.isLoadingMore.value
                        ? const Padding(padding: EdgeInsets.symmetric(vertical: 20), child: CircularProgressIndicator())
                        : const SizedBox.shrink(),
              ),
            ],
          );
        }),
      ),
    );
  }
}
