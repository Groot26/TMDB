import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/intl.dart';

import '../../core/api.dart';
import '../../core/api_value.dart';
import '../../shared_pref_helper.dart';

class ApiRepo {
  final Api api = Api();

  final TMBD_API_KEY = dotenv.env['TMBD_API_KEY'];

  Future<String?> createGuestSession() async {
    final response = await api.sendRequest.get(
      'authentication/guest_session/new',
      queryParameters: {"api_key": TMBD_API_KEY},
    );

    if (response.statusCode == 200 && response.data['success']) {
      SharedPreferencesHelper.setGuestSessionID(guestSessionID: response.data["guest_session_id"]);

      return response.data['guest_session_id'];
    }
    return null;
  }

  Future<String?> getRequestToken() async {
    try {
      Response response = await api.sendRequest.get(
        ApiValue.createRequestToken,
        queryParameters: {"api_key": TMBD_API_KEY},
      );

      if (response.statusCode == 200 && response.data["success"] == true) {
        SharedPreferencesHelper.setAccessToken(accessToken: response.data["request_token"]);
        return response.data["request_token"];
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error getting request token: $e");
      }
    }
    return null;
  }

  Future<Map<String, dynamic>?> searchShow({required String query, required String type, int page = 1}) async {
    try {
      Response response = await api.sendRequest.get(
        "search/$type",
        queryParameters: {'language': 'en-US', "api_key": TMBD_API_KEY, 'query': query, 'page': page},
      );

      if (response.statusCode == 200) {
        return response.data;
      }
      return null;
    } catch (e) {
      if (kDebugMode) {
        print('API search error: $e');
      }
      return null;
    }
  }

  Future<Map<String, dynamic>?> getPopularMovies({int page = 1}) async {
    try {
      Response response = await api.sendRequest.get(
        ApiValue.getPopularMovies,
        queryParameters: {'language': 'en-US', "api_key": TMBD_API_KEY, 'page': page},
      );

      if (response.statusCode == 200) {
        return response.data;
      }
      return null;
    } catch (e) {
      if (kDebugMode) {
        print('API search error: $e');
      }
      return null;
    }
  }

  Future<bool> validateLogin(String username, String password, String requestToken) async {
    try {
      Response response = await api.sendRequest.post(
        ApiValue.validateWithLogin,
        queryParameters: {"api_key": TMBD_API_KEY},
        data: {"username": username, "password": password, "request_token": requestToken},
      );

      return response.statusCode == 200 && response.data["success"] == true;
    } catch (e) {
      if (kDebugMode) {
        print("Error validating login: $e");
      }
      return false;
    }
  }

  Future<String?> createSession(String requestToken) async {
    try {
      Response response = await api.sendRequest.post(
        ApiValue.createSession,
        queryParameters: {"api_key": TMBD_API_KEY},
        data: {"request_token": requestToken},
      );

      if (response.statusCode == 200 && response.data["success"] == true) {
        SharedPreferencesHelper.setSessionID(sessionID: response.data["session_id"]);
        return response.data["session_id"];
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error creating session: $e");
      }
    }
    return null;
  }

  Future<Map<String, dynamic>?> getAccountDetails(String sessionId) async {
    try {
      Response response = await api.sendRequest.get(
        ApiValue.getAccountDetails,
        queryParameters: {"api_key": TMBD_API_KEY, "session_id": sessionId},
      );

      if (response.statusCode == 200 && response.data != null) {
        // Save important user details
        SharedPreferencesHelper.setUserDetails(
          name: response.data["name"] ?? "",
          id: response.data["id"] ?? "",
          username: response.data["username"] ?? "",
          includeAdult: response.data["include_adult"] ?? false,
          avatarPath: response.data["avatar"]?["tmdb"]?["avatar_path"] ?? "",
        );

        return response.data;
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching account details: $e");
      }
    }
    return null;
  }

  Future<Map<String, dynamic>> fetchLatestMovies({int page = 1, String? withGenres}) async {
    try {
      Response response = await api.sendRequest.get(
        ApiValue.getNowMovies,
        // 'discover/movie',
        queryParameters: {
          "api_key": TMBD_API_KEY,
          'language': 'en-US',
          'page': page,
          'sort_by': 'popularity.desc',
          'with_genres': withGenres,
          'watch_region': 'IN',
          'certification_country': 'IN',
          'release_date.lte': DateFormat('yyyy-MM-dd').format(DateTime.now()),
        },
      );

      if (response.statusCode == 200) {
        return response.data as Map<String, dynamic>;
      } else {
        throw Exception("Failed to fetch movies");
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching latest movies: $e");
      }
      return {"results": [], "total_pages": 1};
    }
  }

  Future<Map<String, dynamic>> fetchWatchlist({required int page, required String type}) async {
    final accountID = SharedPreferencesHelper.getAccountId();
    final sessionId = SharedPreferencesHelper.getSessionID();
    final endpoint = 'account/$accountID/watchlist/$type';
    // final endpoint = 'account/$accountID/favorite/tv';
    try {
      final response = await api.sendRequest.get(
        endpoint,
        queryParameters: {
          "api_key": TMBD_API_KEY,
          "session_id": sessionId,
          'language': 'en-US',
          'sort_by': 'popularity.desc',
          'page': page,
          'watch_region': 'IN',
          'certification_country': 'IN',
          'release_date.lte': DateFormat('yyyy-MM-dd').format(DateTime.now()),
        },
      );

      if (response.statusCode == 200) {
        return response.data as Map<String, dynamic>;
      } else {
        throw Exception("Failed to fetch $type watchlist");
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching $type watchlist: $e");
      }
      return {"results": [], "total_pages": 1};
    }
  }

  fetchMovieDetails({required int id, required String type}) async {
    final sessionId = SharedPreferencesHelper.getSessionID();
    final endpoint = '$type/$id';
    try {
      final response = await api.sendRequest.get(
        endpoint,
        queryParameters: {"api_key": TMBD_API_KEY, "session_id": sessionId, 'language': 'en-US'},
      );

      if (response.statusCode == 200) {
        return response.data;
        // return response.data as Map<String, dynamic>;
      } else {
        throw Exception("Failed to fetch $type Show");
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching $type Show: $e");
      }
      return {};
    }
  }

  fetchShowRating({required int id, required String type}) async {
    final sessionId = SharedPreferencesHelper.getSessionID();
    final endpoint = '$type/$id/account_states';
    try {
      final response = await api.sendRequest.get(
        endpoint,
        queryParameters: {
          "api_key": TMBD_API_KEY,
          "session_id": sessionId,
          "guest_session_id": sessionId,
          'language': 'en-US',
        },
      );

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception("Failed to fetch $type Rating");
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching $type Rating: $e");
      }
      return {};
    }
  }

  addRating({required int id, required String type, required double rating}) async {
    final sessionId = SharedPreferencesHelper.getSessionID();
    final endpoint = '$type/$id/rating';
    try {
      final response = await api.sendRequest.post(
        endpoint,
        queryParameters: {
          "api_key": TMBD_API_KEY,
          "session_id": sessionId,
          "guest_session_id": sessionId,
          'language': 'en-US',
        },
        data: {"value": rating},
      );

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception("Failed to fetch $type Rating");
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching $type Rating: $e");
      }
      return {};
    }
  }

  addFavorite({required int id, required String type, required bool isFavorite}) async {
    final sessionId = SharedPreferencesHelper.getSessionID();
    final accountID = SharedPreferencesHelper.getAccountId();
    final endpoint = 'account/$accountID/favorite';
    try {
      final response = await api.sendRequest.post(
        endpoint,
        queryParameters: {
          "api_key": TMBD_API_KEY,
          "session_id": sessionId,
          "guest_session_id": sessionId,
          'language': 'en-US',
        },
        data: {"media_type": type, "media_id": id, "favorite": isFavorite},
      );

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception("Failed to fetch $type Rating");
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching $type Rating: $e");
      }
      return {};
    }
  }

  addToWatchlist({required int id, required String type, required bool isWatchlist}) async {
    final sessionId = SharedPreferencesHelper.getSessionID();
    final accountID = SharedPreferencesHelper.getAccountId();
    final endpoint = 'account/$accountID/watchlist';
    try {
      final response = await api.sendRequest.post(
        endpoint,
        queryParameters: {
          "api_key": TMBD_API_KEY,
          "session_id": sessionId,
          "guest_session_id": sessionId,
          'language': 'en-US',
        },
        data: {"media_type": type, "media_id": id, "watchlist": isWatchlist},
      );

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception("Failed to fetch $type Rating");
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching $type Rating: $e");
      }
      return {};
    }
  }

  Future<Map<String, dynamic>> fetchFavorite({int page = 1, required String type}) async {
    final accountID = SharedPreferencesHelper.getAccountId();
    final sessionId = SharedPreferencesHelper.getSessionID();
    final endpoint = 'account/$accountID/favorite/$type';
    try {
      final response = await api.sendRequest.get(
        endpoint,
        queryParameters: {"api_key": TMBD_API_KEY, "session_id": sessionId, 'sort_by': 'created_at.asc', 'page': page},
      );

      if (response.statusCode == 200) {
        return response.data as Map<String, dynamic>;
      } else {
        throw Exception("Failed to fetch $type watchlist");
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching $type watchlist: $e");
      }
      return {"results": [], "total_pages": 1};
    }
  }

  Future<Map<String, dynamic>> fetchCustom({
    int page = 1,
    required String type,
    required String endpoint, //favorite or rated
  }) async {
    final accountID = SharedPreferencesHelper.getAccountId();
    final sessionId = SharedPreferencesHelper.getSessionID();

    try {
      Response response = await api.sendRequest.get(
        "account/$accountID/$endpoint/$type",
        queryParameters: {
          "api_key": TMBD_API_KEY,
          "session_id": sessionId,
          'language': 'en-US',
          'page': page,
          'sort_by': 'popularity.desc',
        },
      );

      if (response.statusCode == 200) {
        return response.data as Map<String, dynamic>;
      } else {
        throw Exception("Failed to fetch movies");
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching custom $endpoint $type: $e");
      }
      return {"results": [], "total_pages": 1};
    }
  }

  Future<Map<String, dynamic>> fetchTrendingMovies({int page = 1, required String timeWindow}) async {
    try {
      Response response = await api.sendRequest.get(
        'trending/all/$timeWindow',
        queryParameters: {"api_key": TMBD_API_KEY, 'language': 'en-US', 'page': page},
      );

      if (response.statusCode == 200) {
        return response.data as Map<String, dynamic>;
      } else {
        throw Exception("Failed to fetch movies");
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching latest movies: $e");
      }
      return {"results": [], "total_pages": 1};
    }
  }

  Future<Map<String, dynamic>> fetchFreeToWatchMovies({int page = 1, required String type}) async {
    try {
      Response response = await api.sendRequest.get(
        'discover/$type',
        queryParameters: {
          "api_key": TMBD_API_KEY,
          'language': 'en-US',
          'with_watch_monetization_types': 'free',
          'page': page,
          'sort_by': 'popularity.desc',
          'watch_region': 'IN',
          'certification_country': 'IN',
          'release_date.lte': DateFormat('yyyy-MM-dd').format(DateTime.now()),
        },
      );

      if (response.statusCode == 200) {
        return response.data as Map<String, dynamic>;
      } else {
        throw Exception("Failed to fetch free $type");
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching Free $type: $e");
      }
      return {"results": [], "total_pages": 1};
    }
  }

  Future<Map<String, dynamic>> fetchShowProvider({required String type, required int id}) async {
    try {
      Response response = await api.sendRequest.get(
        '$type/$id/watch/providers',
        queryParameters: {"api_key": TMBD_API_KEY},
      );

      if (response.statusCode == 200) {
        return (response.data['results']['IN'] ?? {}) as Map<String, dynamic>;
      } else {
        throw Exception("Failed to fetch watch providers");
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching watch providers: $e");
      }
      return {};
    }
  }

  Future<Map<String, dynamic>> fetchTopRatedShow({int page = 1, required String type}) async {
    try {
      Response response = await api.sendRequest.get(
        '$type/top_rated',
        queryParameters: {"api_key": TMBD_API_KEY, 'language': 'en-US', 'page': page},
      );

      if (response.statusCode == 200) {
        return response.data as Map<String, dynamic>;
      } else {
        throw Exception("Failed to Top Rated $type");
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching Top Rated $type: $e");
      }
      return {"results": [], "total_pages": 1};
    }
  }
}
