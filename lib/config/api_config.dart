// lib/config/api_config.dart

class ApiConfig {
  // ============= FOOTBALL API =============
  static const String footballApiKey = 'TU_API_KEY_AQUI'; // api-football.com
  static const String footballBaseUrl = 'https://v3.football.api-sports.io';

  // Ligas principales
  static const Map<String, String> leagues = {
    'premier': '39', // Premier League
    'laliga': '140', // La Liga
    'seriea': '135', // Serie A
    'bundesliga': '78', // Bundesliga
    'ligue1': '61', // Ligue 1
    'eredivisie': '88', // Eredivisie
    'argentina': '128', // Superliga Argentina
    'brasil': '71', // Brasileirão
  };

  // ============= NBA API =============
  static const String nbaBaseUrl = 'https://stats.nba.com/stats';
  // NO necesita API key

  // ============= NFL API =============
  static const String nflBaseUrl =
      'https://site.api.espn.com/apis/site/v2/sports/football/nfl';
  // NO necesita API key

  // ============= F1 API =============
  static const String f1BaseUrl = 'http://ergast.com/api/f1';
  // GRATIS y NO necesita API key

  // ============= RUGBY API =============
  static const String rugbyBaseUrl =
      'https://site.api.espn.com/apis/site/v2/sports/rugby';
  // NO necesita API key

  // ============= TIMEOUT Y RETRY =============
  static const Duration connectionTimeout = Duration(seconds: 10);
  static const Duration receiveTimeout = Duration(seconds: 10);
  static const int maxRetries = 3;
  static const Duration retryDelay = Duration(seconds: 2);

  // ============= CACHE =============
  static const Duration cacheDuration = Duration(minutes: 10);
  static const Duration liveDataRefreshDuration = Duration(seconds: 10);
}
