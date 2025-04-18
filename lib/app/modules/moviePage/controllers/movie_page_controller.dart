import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tmdb/data/models/show_model.dart';
import 'package:tmdb/shared_pref_helper.dart';

import '../../../../data/repos/api_repo.dart';

class MoviePageController extends GetxController {
  Map show = {};
  RxMap<String, dynamic> rating = <String, dynamic>{}.obs;

  RxBool isLoading = false.obs;
  Rxn<ShowDetails> showDetails = Rxn<ShowDetails>();
  RxMap<String, dynamic> providers = <String, dynamic>{}.obs;

  @override
  void onInit() {
    super.onInit();
    show = Get.arguments;
    getData();
  }

  void getData() {
    fetchMovieDetails();
    fetchShowRating();
    fetchProviders();
  }

  void fetchMovieDetails() async {
    isLoading.value = true;
    bool isTv = show.containsKey("original_name");

    // fetchShowRating();

    showDetails.value = null;
    final response = await ApiRepo().fetchMovieDetails(id: show['id'], type: isTv ? 'tv' : 'movie');

    final show1 = ShowDetails.fromJson(response);
    showDetails.value = show1;

    isLoading.value = false;
  }

  Future<void> fetchProviders() async {
    bool isTv = show.containsKey("original_name");
    final response = await ApiRepo().fetchShowProvider(id: show['id'], type: isTv ? 'tv' : 'movie');
    providers.value = response;
  }

  fetchShowRating() async {
    if (!SharedPreferencesHelper.isLoggedIn()) {
      return null;
    }
    bool isTv = show.containsKey("original_name");
    final response = await ApiRepo().fetchShowRating(id: show['id'], type: isTv ? 'tv' : 'movie');
    rating.value = response;
  }

  void addRating(BuildContext context, double rating) async {
    if (!SharedPreferencesHelper.isLoggedIn()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please log in to rate', style: TextStyle(color: Colors.white)),
          action: SnackBarAction(
            label: 'Login',
            onPressed: () async {
              await SharedPreferencesHelper.logout();
              Get.offAllNamed('/login');
            },
          ),
          showCloseIcon: true,
          backgroundColor: Colors.black87,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          margin: const EdgeInsets.all(16),
          elevation: 6,
        ),
      );

      return null;
    }
    bool isTv = show.containsKey("original_name");
    await ApiRepo().addRating(id: show['id'], type: isTv ? 'tv' : 'movie', rating: rating);

    await Future.delayed(Duration(seconds: 1));

    fetchShowRating();
  }

  Future<bool?> addFavorite(bool isFavorite) async {
    if (!SharedPreferencesHelper.isLoggedIn()) {
      return null;
    }
    bool isTv = show.containsKey("original_name");

    await ApiRepo().addFavorite(id: show['id'], type: isTv ? 'tv' : 'movie', isFavorite: !isFavorite);
    await Future.delayed(Duration(milliseconds: 500));
    await fetchShowRating();
    return !isFavorite;
  }

  Future<bool?> addToWatchlist(bool isWatchlist) async {
    if (!SharedPreferencesHelper.isLoggedIn()) {
      return null;
    }
    bool isTv = show.containsKey("original_name");

    await ApiRepo().addToWatchlist(id: show['id'], type: isTv ? 'tv' : 'movie', isWatchlist: !isWatchlist);
    await Future.delayed(Duration(milliseconds: 500));
    await fetchShowRating();
    return !isWatchlist;
  }
}
