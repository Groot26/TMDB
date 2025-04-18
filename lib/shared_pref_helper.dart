import 'package:shared_preferences/shared_preferences.dart';

import 'main.dart';

class SharedPreferencesHelper {
  static final SharedPreferencesHelper _instance = SharedPreferencesHelper._ctor();

  factory SharedPreferencesHelper() {
    return _instance;
  }

  SharedPreferencesHelper._ctor();

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static late SharedPreferences _prefs;

  // Save access token
  static void setAccessToken({required String accessToken}) {
    _prefs.setString("accessToken", accessToken);
  }

  static String getAccessToken() {
    return _prefs.getString("accessToken") ?? "";
  }

  // Save session ID
  static void setSessionID({required String sessionID}) {
    _prefs.setString("sessionID", sessionID);
  }

  static void setGuestSessionID({required String guestSessionID}) {
    _prefs.setString("guestSessionID", guestSessionID);
  }

  static String getSessionID() {
    return _prefs.getString("sessionID") ?? "";
  }

  static void setUserDetails({
    required String name,
    required int id,
    required String username,
    required bool includeAdult,
    required String avatarPath,
  }) {
    const String baseUrl = "https://image.tmdb.org/t/p/w500";
    _prefs.setString("name", name);
    _prefs.setInt("id", id);
    _prefs.setString("username", username);
    _prefs.setBool("includeAdult", includeAdult);
    _prefs.setString("avatarPath", avatarPath.isNotEmpty ? baseUrl + avatarPath : "");
    _prefs.setBool("isLoggedIn", true);
  }

  // Get user details
  static String getName() {
    return _prefs.getString("name") ?? "no name";
  }

  static int getAccountId() {
    return _prefs.getInt("id") ?? 0;
  }

  static String getUsername() {
    return _prefs.getString("username") ?? "";
  }

  static bool getIncludeAdult() {
    return _prefs.getBool("includeAdult") ?? false;
  }

  static String getAvatarPath() {
    return _prefs.getString("avatarPath") ?? "";
  }

  // Check if user is logged in
  static bool isLoggedIn() {
    return _prefs.getBool("isLoggedIn") ?? false;
  }

  //Logout
  static Future<void> logout() async {
    _prefs.remove("accessToken");
    _prefs.remove("sessionID");
    _prefs.remove("guestSessionID");
    _prefs.remove("name");
    _prefs.remove("username");
    _prefs.remove("includeAdult");
    _prefs.remove("avatarPath");
    _prefs.setBool("isLoggedIn", false);
    await _prefs.clear();
    await box.clear();
  }
}
