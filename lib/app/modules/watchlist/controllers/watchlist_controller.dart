import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../data/repos/api_repo.dart';

class WatchlistController extends GetxController with GetTickerProviderStateMixin {
  // Movies
  RxList<dynamic> movies = <dynamic>[].obs;
  RxInt currentMoviePage = 1.obs;
  int totalMoviePages = 1;
  RxBool isLoadingMovies = false.obs;
  RxBool isLoadingMoreMovies = false.obs;

  // TV Shows
  RxList<dynamic> tvShows = <dynamic>[].obs;
  RxInt currentTvPage = 1.obs;
  int totalTvPages = 1;
  RxBool isLoadingTv = false.obs;
  RxBool isLoadingMoreTv = false.obs;

  late TabController tabController;

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 2, vsync: this);
    fetchAtInit();
  }

  fetchAtInit() {
    fetchWatchlist(type: 'movies');
    fetchWatchlist(type: 'tv');
  }

  Future<void> fetchWatchlist({required String type, bool isLoadMore = false}) async {
    final isMovie = type == 'movies';

    final page = isMovie ? currentMoviePage.value : currentTvPage.value;
    final totalPages = isMovie ? totalMoviePages : totalTvPages;

    if (isLoadMore && page > totalPages) return;

    try {
      if (isMovie) {
        isLoadMore ? isLoadingMoreMovies.value = true : isLoadingMovies.value = true;
      } else {
        isLoadMore ? isLoadingMoreTv.value = true : isLoadingTv.value = true;
      }

      final response = await ApiRepo().fetchWatchlist(page: page, type: type);

      final results = response['results'] ?? [];
      final total = response['total_pages'] ?? 1;

      if (isMovie) {
        if (isLoadMore) {
          movies.addAll(results);
        } else {
          movies.assignAll(results);
        }
        totalMoviePages = total;
        if (currentMoviePage.value < totalMoviePages) {
          currentMoviePage.value += 1;
        }
      } else {
        if (isLoadMore) {
          tvShows.addAll(results);
        } else {
          tvShows.assignAll(results);
        }
        totalTvPages = total;
        if (currentTvPage.value < totalTvPages) {
          currentTvPage.value += 1;
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error: $e');
      }
    } finally {
      if (isMovie) {
        isLoadingMovies.value = false;
        isLoadingMoreMovies.value = false;
      } else {
        isLoadingTv.value = false;
        isLoadingMoreTv.value = false;
      }
    }
  }
}
