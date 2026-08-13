// lib/services/http_service.dart

import 'package:dio/dio.dart';
import '../config/api_config.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final httpServiceProvider = Provider<HttpService>((ref) => HttpService());

class HttpService {
  static final HttpService _instance = HttpService._internal();

  late Dio _dio;
  late Dio _footballDio;

  factory HttpService() {
    return _instance;
  }

  HttpService._internal() {
    _initDio();
  }

  void _initDio() {
    // Dio para APIs que NO necesitan key
    _dio = Dio(
      BaseOptions(
        connectTimeout: ApiConfig.connectionTimeout,
        receiveTimeout: ApiConfig.receiveTimeout,
        contentType: Headers.jsonContentType,
        responseType: ResponseType.json,
      ),
    );

    // Dio especial para Football API (con key)
    _footballDio = Dio(
      BaseOptions(
        connectTimeout: ApiConfig.connectionTimeout,
        receiveTimeout: ApiConfig.receiveTimeout,
        contentType: Headers.jsonContentType,
        responseType: ResponseType.json,
        headers: {
          'x-apisports-key': ApiConfig.footballApiKey,
        },
      ),
    );

    // Interceptors
    _dio.interceptors.add(LoggingInterceptor());
    _footballDio.interceptors.add(LoggingInterceptor());
  }

  // ============= FOOTBALL =============
  Future<Response> getFootballLiveMatches({
    required String leagueId,
    String? status = 'live',
  }) async {
    try {
      final response = await _footballDio.get(
        '${ApiConfig.footballBaseUrl}/fixtures',
        queryParameters: {
          'league': leagueId,
          'season': DateTime.now().year,
          'status': status,
        },
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> getFootballTeamMatches({
    required String teamId,
    String? status,
  }) async {
    try {
      final response = await _footballDio.get(
        '${ApiConfig.footballBaseUrl}/fixtures',
        queryParameters: {
          'team': teamId,
          'season': DateTime.now().year,
          if (status != null) 'status': status,
          'next': 50,
        },
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> getFootballStandings({
    required String leagueId,
  }) async {
    try {
      final response = await _footballDio.get(
        '${ApiConfig.footballBaseUrl}/standings',
        queryParameters: {
          'league': leagueId,
          'season': DateTime.now().year,
        },
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> getFootballTeamTransfers({
    required String teamId,
  }) async {
    try {
      final response = await _footballDio.get(
        '${ApiConfig.footballBaseUrl}/transfers',
        queryParameters: {
          'team': teamId,
        },
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // ============= NBA =============
  Future<Response> getNBAScoreboard({
    required String gameDate, // yyyy-MM-dd
  }) async {
    try {
      final response = await _dio.get(
        '${ApiConfig.nbaBaseUrl}/scoreboard',
        queryParameters: {
          'LeagueID': '00',
          'GameDate': gameDate,
        },
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> getNBAStandings() async {
    try {
      final response = await _dio.get(
        '${ApiConfig.nbaBaseUrl}/leaguestandingsv3',
        queryParameters: {
          'LeagueID': '00',
        },
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> getNBADraft({
    required int year,
  }) async {
    try {
      final response = await _dio.get(
        '${ApiConfig.nbaBaseUrl}/drafthistory',
        queryParameters: {
          'Season': year,
        },
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // ============= NFL =============
  Future<Response> getNFLScoreboard() async {
    try {
      final response = await _dio.get(
        '${ApiConfig.nflBaseUrl}/scoreboard',
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> getNFLTeamSchedule({
    required String teamId,
  }) async {
    try {
      final response = await _dio.get(
        '${ApiConfig.nflBaseUrl}/teams/$teamId/schedule',
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> getNFLStandings() async {
    try {
      final response = await _dio.get(
        '${ApiConfig.nflBaseUrl}/standings',
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // ============= F1 =============
  Future<Response> getF1Races({
    int? year,
  }) async {
    try {
      final targetYear = year ?? DateTime.now().year;
      final response = await _dio.get(
        '${ApiConfig.f1BaseUrl}/$targetYear.json',
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> getF1Standings({
    int? year,
  }) async {
    try {
      final targetYear = year ?? DateTime.now().year;
      final response = await _dio.get(
        '${ApiConfig.f1BaseUrl}/$targetYear/driverStandings.json',
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> getF1ConstructorStandings({
    int? year,
  }) async {
    try {
      final targetYear = year ?? DateTime.now().year;
      final response = await _dio.get(
        '${ApiConfig.f1BaseUrl}/$targetYear/constructorStandings.json',
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // ============= RUGBY =============
  Future<Response> getRugbyMatches({
    String? teamId,
  }) async {
    try {
      final url = teamId != null
          ? '${ApiConfig.rugbyBaseUrl}/teams/$teamId/schedule'
          : '${ApiConfig.rugbyBaseUrl}/scoreboard';

      final response = await _dio.get(url);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> getRugbyRankings() async {
    try {
      final response = await _dio.get(
        '${ApiConfig.rugbyBaseUrl}/rankings',
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }
}

// ============= LOGGING INTERCEPTOR =============
class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    print('🌐 REQUEST: ${options.method} ${options.path}');
    print('📦 Query Params: ${options.queryParameters}');
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    print('✅ RESPONSE: ${response.statusCode} ${response.requestOptions.path}');
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    print('❌ ERROR: ${err.message}');
    print('   URL: ${err.requestOptions.path}');
    super.onError(err, handler);
  }
}
