import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../../../data/repos/api_repo.dart';

class HomeController extends GetxController {
  RxList trendingMovies = [].obs;
  RxList topRatedMovies = [].obs;
  RxList freeToWatch = [].obs;

  RxBool isTrendingLoading = false.obs;
  RxBool isFreeLoading = false.obs;
  RxBool isTopRatedLoading = false.obs;

  RxBool isWeekly = false.obs;
  RxBool isFreeToWatchTv = false.obs;
  RxBool isTopRatedTv = false.obs;

  RxInt currentBackdropIndex = 0.obs;
  Timer _timer = Timer(Duration.zero, () {});

  @override
  void onInit() {
    super.onInit();
    getShow();
  }

  void getShow() {
    fetchTrendingMovies();
    freeToWatchMovies();
    fetchTopRatedMovies();
  }

  void toggleTrending(bool value) async {
    if (isWeekly.value != value) {
      isWeekly.value = value;
      await fetchTrendingMovies();
    }
  }

  void toggleFreeToWatch(bool value) async {
    if (isFreeToWatchTv.value != value) {
      isFreeToWatchTv.value = value;
      await freeToWatchMovies();
    }
  }

  void toggleTopRated(bool value) async {
    if (isTopRatedTv.value != value) {
      isTopRatedTv.value = value;
      await fetchTopRatedMovies();
    }
  }

  Future<void> fetchTrendingMovies() async {
    try {
      isTrendingLoading.value = true;

      _timer.cancel();

      var response = await ApiRepo().fetchTrendingMovies(timeWindow: isWeekly.value ? 'week' : 'day');

      trendingMovies.assignAll(response["results"]);

      _startBackdropRotation();
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    } finally {
      isTrendingLoading.value = false;
    }
  }

  void _startBackdropRotation() {
    _timer.cancel();

    _timer = Timer.periodic(const Duration(seconds: 5), (_) {
      if (trendingMovies.isNotEmpty) {
        currentBackdropIndex.value = (currentBackdropIndex.value + 1) % trendingMovies.length;
      }
    });
  }

  Future<void> freeToWatchMovies() async {
    try {
      isFreeLoading.value = true;

      var response = await ApiRepo().fetchFreeToWatchMovies(
        type: isFreeToWatchTv.value ? 'tv' : 'movie', // movies or tv
      );
      freeToWatch.assignAll(response["results"]);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    } finally {
      isFreeLoading.value = false;
    }
  }

  Future<void> fetchTopRatedMovies() async {
    try {
      isTopRatedLoading.value = true;

      var response = await ApiRepo().fetchTopRatedShow(
        type: isTopRatedTv.value ? 'tv' : 'movie', // movies or tv
      );
      topRatedMovies.assignAll(response["results"]);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    } finally {
      isTopRatedLoading.value = false;
    }
  }

  @override
  void onClose() {
    _timer.cancel();
    super.onClose();
  }
}
