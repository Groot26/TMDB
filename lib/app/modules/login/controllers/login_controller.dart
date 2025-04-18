import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../../data/repos/api_repo.dart';

class LoginController extends GetxController {
  RxBool isLoading = false.obs;
  final ApiRepo apiRepo = ApiRepo();
  RxBool isScaledUp = false.obs;
  final TextEditingController username = TextEditingController();
  final TextEditingController password = TextEditingController();

  void loginAsGuest() async {
    isLoading.value = true;
    final guestSessionId = await apiRepo.createGuestSession();
    if (guestSessionId != null) {
      Get.offAllNamed('/dashboard');
    } else {
      Get.snackbar("Error", "Failed to create guest session");
    }
    isLoading.value = false;
  }

  void loginWithCredentials() async {
    isLoading.value = true;

    final username = this.username.text.trim();
    final password = this.password.text.trim();

    final requestToken = await apiRepo.getRequestToken();

    if (requestToken == null) {
      Get.snackbar("Error", "Could not get request token");
      isLoading.value = false;
      return;
    }

    final validated = await apiRepo.validateLogin(username, password, requestToken);
    if (!validated) {
      Get.snackbar("Login Failed", "Invalid credentials");
      isLoading.value = false;
      return;
    }

    final sessionId = await apiRepo.createSession(requestToken);
    if (sessionId == null) {
      Get.snackbar("Error", "Could not create session");
      isLoading.value = false;
      return;
    }

    await apiRepo.getAccountDetails(sessionId);
    isLoading.value = false;
    Get.offAllNamed('/dashboard');
  }

  void loginWithTMDB() async {
    isLoading.value = true;

    String? requestToken = await apiRepo.getRequestToken();
    if (requestToken == null) {
      Get.snackbar("Error", "Failed to get request token");
      isLoading.value = false;
      return;
    }

    // Open TMDB authentication page in browser
    final authUrl = "https://www.themoviedb.org/authenticate/$requestToken";
    await launchUrlString(authUrl, mode: LaunchMode.externalApplication);

    // Wait for user to authorize
    await Future.delayed(const Duration(seconds: 10)); // Simulating user action

    // Create session after authentication
    String? sessionId = await apiRepo.createSession(requestToken);
    if (sessionId == null) {
      Get.snackbar("Error", "Failed to create session");
      isLoading.value = false;
      return;
    }

    // Fetch user details
    await apiRepo.getAccountDetails(sessionId);

    isLoading.value = false;
    Get.offAllNamed('/dashboard');
  }

  void toggleScale() {
    isScaledUp.value = !isScaledUp.value;
    update();
  }
}
