import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../data/repos/api_repo.dart';

class SearchPageController extends GetxController {
  TextEditingController searchController = TextEditingController();

  final RxList<dynamic> movies = <dynamic>[].obs;
  final ScrollController scrollController = ScrollController();

  RxBool isLoading = false.obs;
  RxBool isLoadingMore = false.obs;

  RxInt searchPage = 1.obs;
  int searchTotalPages = 1;

  Timer? _debounce;

  var isTVShow = false.obs;

  void toggle(bool value) {
    isTVShow.value = value;
    searchPage.value = 1;
    searchMovies(isPopular: searchController.text.isEmpty);
  }

  @override
  void onInit() {
    searchMovies(isPopular: true);
    scrollController.addListener(_scrollListener);
    super.onInit();
  }

  void _scrollListener() {
    if (scrollController.position.pixels >= scrollController.position.maxScrollExtent - 200 &&
        !isLoadingMore.value &&
        searchPage.value < searchTotalPages) {
      searchMovies(isLoadMore: true, isPopular: searchController.text.isEmpty);
    }
  }

  void onSearchChanged(String value) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      searchPage.value = 1;
      searchMovies();
    });
  }

  Future<void> onRefresh() async {
    searchPage.value = 1;
    searchMovies(isPopular: searchController.text.isEmpty);
    return;
  }

  Future<void> searchMovies({bool isLoadMore = false, bool isPopular = false}) async {
    final query = searchController.text.trim();
    if (isLoadMore && searchPage.value > searchTotalPages) return;

    try {
      if (isLoadMore) {
        isLoadingMore.value = true;
      } else {
        isLoading.value = true;
      }

      Map<String, dynamic>? response;

      if (isPopular) {
        response = await ApiRepo().getPopularMovies(page: searchPage.value);
      } else {
        response = await ApiRepo().searchShow(
          query: query,
          page: searchPage.value,
          type: isTVShow.value ? 'tv' : 'movie',
        );
      }

      if (response != null && response['results'] != null) {
        final results = response['results'];
        final total = response['total_pages'] ?? 1;

        if (!isLoadMore) {
          movies.assignAll(results);

          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (scrollController.hasClients && scrollController.position.hasContentDimensions) {
              scrollController.animateTo(0, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
            }
          });
        } else {
          movies.addAll(results);
        }

        searchTotalPages = total;
        if (searchPage.value < searchTotalPages) {
          searchPage.value += 1;
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Search error: $e');
      }
      if (!isLoadMore) movies.clear();
    } finally {
      isLoading.value = false;
      isLoadingMore.value = false;
    }
  }

  @override
  void onClose() {
    scrollController.dispose();
    searchController.dispose();
    _debounce?.cancel();
    super.onClose();
  }
}
