import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../../../data/repos/api_repo.dart';
import '../../../../shared_pref_helper.dart';

class ProfileController extends GetxController {
  /// Favorite
  // Movies
  RxList<dynamic> favoriteMovies = <dynamic>[].obs;
  RxInt totalFavoriteMoviePages = 1.obs;
  RxBool isLoadingFavoriteMovies = false.obs;

  // TV Shows
  RxList<dynamic> favoriteTvShows = <dynamic>[].obs;
  RxInt totalFavoriteTvPages = 1.obs;
  RxBool isLoadingFavoriteTv = false.obs;

  /// Rated
  // Movies
  RxList<dynamic> ratedMovies = <dynamic>[].obs;
  RxInt totalRatedMoviePages = 1.obs;
  RxBool isLoadingRatedMovies = false.obs;

  // TV Shows
  RxList<dynamic> ratedTvShows = <dynamic>[].obs;
  RxInt totalRatedTvPages = 1.obs;
  RxBool isLoadingRatedTv = false.obs;

  @override
  void onInit() {
    super.onInit();
    getData();
  }

  String name = "";
  String imageUrl = "";
  String userName = "";

  void getData() {
    name = SharedPreferencesHelper.getName();
    imageUrl = SharedPreferencesHelper.getAvatarPath();
    userName = SharedPreferencesHelper.getUsername();

    fetchFavorite(type: 'movies');
    fetchFavorite(type: 'tv');
    fetchRatedShow(type: 'movies');
    fetchRatedShow(type: 'tv');
  }

  Future<void> fetchFavorite({required String type}) async {
    final isMovie = type == 'movies';

    try {
      if (isMovie) {
        isLoadingFavoriteMovies.value = true;
      } else {
        isLoadingFavoriteTv.value = true;
      }

      final response = await ApiRepo().fetchFavorite(page: 1, type: type);

      final results = response['results'] ?? [];
      final total = response['total_pages'] ?? 1;

      if (isMovie) {
        favoriteMovies.assignAll(results);
        totalFavoriteMoviePages.value = total;
      } else {
        favoriteTvShows.assignAll(results);
        totalFavoriteTvPages.value = total;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error Fetching Favorite: $e');
      }
    } finally {
      if (isMovie) {
        isLoadingFavoriteMovies.value = false;
      } else {
        isLoadingFavoriteTv.value = false;
      }
    }
  }

  Future<void> fetchRatedShow({required String type}) async {
    final isMovie = type == 'movies';

    try {
      if (isMovie) {
        isLoadingRatedMovies.value = true;
      } else {
        isLoadingRatedTv.value = true;
      }

      final response = await ApiRepo().fetchCustom(page: 1, type: type, endpoint: 'rated');

      final results = response['results'] ?? [];
      final total = response['total_pages'] ?? 1;

      if (isMovie) {
        ratedMovies.assignAll(results);
        totalRatedMoviePages.value = total;
      } else {
        ratedTvShows.assignAll(results);
        totalRatedTvPages.value = total;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error Fetching Favorite: $e');
      }
    } finally {
      if (isMovie) {
        isLoadingRatedMovies.value = false;
      } else {
        isLoadingRatedTv.value = false;
      }
    }
  }
}
