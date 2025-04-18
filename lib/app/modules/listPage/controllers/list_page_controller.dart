import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../../../data/repos/api_repo.dart';

class ListPageController extends GetxController {
  RxList<dynamic> movies = <dynamic>[].obs;
  RxInt totalPages = 1.obs;
  late String title;
  late String type;
  late String endpoint;
  RxInt currentPage = 2.obs; // 2 becoz 1st page is already loaded
  RxBool isLoadingMore = false.obs;
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    movies = Get.arguments["show"];
    title = Get.arguments["title"];
    totalPages = Get.arguments["total_pages"];
    type = Get.arguments["type"];
    endpoint = Get.arguments["endpoint"];
  }

  Future<void> fetchCustom({bool isLoadMore = false}) async {
    if (isLoadMore && currentPage.value > totalPages.value) return;

    try {
      if (isLoadMore) {
        isLoadingMore.value = true;
      } else {
        isLoading.value = true;
      }

      final response = await ApiRepo().fetchCustom(page: currentPage.value, type: type, endpoint: endpoint);

      final tempMovies = response['results'] ?? [];
      final total = response['total_pages'] ?? 1;

      if (!isLoadMore) {
        movies.assignAll(tempMovies);
      } else {
        movies.addAll(tempMovies);
      }

      totalPages.value = total;

      if (currentPage.value <= totalPages.value) {
        currentPage.value += 1;
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching movies: $e");
      }
    } finally {
      isLoadingMore.value = false;
      isLoading.value = false;
    }
  }
}
