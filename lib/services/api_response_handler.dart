import 'package:dio/dio.dart';
import '../models/draft_models.dart';

class ApiResponseHandler {
  // 🔴 RECIBE DATOS EN VIVO DE FÚTBOL Y RESPONDE
  static List<FootballMatch> parseFootballMatches(Response response) {
    try {
      final List matches = response.data['response'] ?? [];

      return matches.map((match) {
        return FootballMatch(
          id: match['fixture']['id'].toString(),
          homeTeam: match['teams']['home']['name'] ?? 'Unknown',
          awayTeam: match['teams']['away']['name'] ?? 'Unknown',
          homeScore: match['goals']['home'] ?? 0,
          awayScore: match['goals']['away'] ?? 0,
          status: match['fixture']['status']['short'] ?? 'NS',
          minute: match['fixture']['status']['elapsed'] ?? 0,
          league: match['league']['name'] ?? 'Unknown',
          matchDate: DateTime.parse(
              match['fixture']['date'] ?? DateTime.now().toString()),
          homeGoalScorers: _parseGoals(match, 'home'),
          awayGoalScorers: _parseGoals(match, 'away'),
          matchType: 'league',
          isLive: match['fixture']['status']['short'] == 'LIV',
          isFinished: match['fixture']['status']['short'] == 'FT',
        );
      }).toList();
    } catch (e) {
      print('❌ Error parsing football matches: $e');
      return [];
    }
  }

  static List<String> _parseGoals(dynamic match, String team) {
    try {
      final List events = match['events'] ?? [];
      final teamId = match['teams'][team]['id'];

      return events
          .where((e) => e['type'] == 'Goal' && e['team']['id'] == teamId)
          .map((e) => '${e['player']['name']} (${e["time"]["elapsed"]}\')')
          .toList()
          .cast<String>();
    } catch (e) {
      return [];
    }
  }

  // 🔴 RECIBE DATOS EN VIVO DE NBA Y RESPONDE
  static List<NBAGame> parseNBAGames(Response response) {
    try {
      final List games = response.data['resultSets'][0]['rowSet'] ?? [];

      return games.map((game) {
        return NBAGame(
          id: game[2].toString(),
          homeTeam: game[6] ?? 'Unknown',
          awayTeam: game[7] ?? 'Unknown',
          homeScore: game[23] ?? 0,
          awayScore: game[24] ?? 0,
          status: _getNBAStatus(game[4]),
          quarter: game[8] ?? 0,
          timeRemaining: game[9]?.toString() ?? '0:00',
          gameDate: DateTime.now(),
        );
      }).toList();
    } catch (e) {
      print('❌ Error parsing NBA games: $e');
      return [];
    }
  }

  static String _getNBAStatus(int statusCode) {
    switch (statusCode) {
      case 1:
        return 'Scheduled';
      case 2:
        return 'In Progress';
      case 3:
        return 'Final';
      default:
        return 'Unknown';
    }
  }

  // 🔴 RECIBE DATOS EN VIVO DE NFL Y RESPONDE
  static List<NFLGame> parseNFLGames(Response response) {
    try {
      final List events = response.data['events'] ?? [];

      return events
          .map((event) {
            final competitions = event['competitions'] as List;
            if (competitions.isEmpty) return null;

            final comp = competitions[0];
            final competitors = comp['competitors'] as List;

            return NFLGame(
              id: event['id'],
              homeTeam: competitors.isNotEmpty
                  ? competitors[0]['team']['displayName']
                  : 'Unknown',
              awayTeam: competitors.length > 1
                  ? competitors[1]['team']['displayName']
                  : 'Unknown',
              homeScore: int.parse(competitors.isNotEmpty
                  ? competitors[0]['score'].toString()
                  : '0'),
              awayScore: int.parse(competitors.length > 1
                  ? competitors[1]['score'].toString()
                  : '0'),
              status: comp['status']['type']['name'] ?? 'SCHEDULED',
              quarter: int.parse(comp['status']['period']?.toString() ?? '0'),
              week: comp['week']?['number'] ?? 0,
              date: DateTime.parse(event['date'] ?? DateTime.now().toString()),
              isLive: comp['status']['type']['name'] == 'STATUS_IN_PROGRESS',
              isFinished: comp['status']['type']['name'] == 'STATUS_FINAL',
              timeRemaining: comp['status']['displayClock'] ?? '0:00',
            );
          })
          .whereType<NFLGame>()
          .toList();
    } catch (e) {
      print('❌ Error parsing NFL games: $e');
      return [];
    }
  }

  // 🔴 RECIBE DATOS EN VIVO DE F1 Y RESPONDE
  static List<F1Race> parseF1Races(Response response) {
    try {
      final List races = response.data['MRData']['RaceTable']['Races'] ?? [];

      return races.map((race) {
        final results = race['Results'] as List?;

        return F1Race(
          name: race['name'] ?? 'Unknown',
          circuit: race['Circuit']['circuitName'] ?? 'Unknown',
          country: race['Circuit']['Location']['country'] ?? 'Unknown',
          date: race['date'] ?? 'Unknown',
          round: int.parse(race['round']?.toString() ?? '0'),
          status:
              results != null && results.isNotEmpty ? 'FINISHED' : 'SCHEDULED',
          currentLap: 0,
          totalLaps: int.parse(race['Circuit']['totalLaps']?.toString() ?? '0'),
          results: (results ?? [])
              .map((result) => F1Result(
                    position: int.parse(result['position']?.toString() ?? '0'),
                    driverName: result['Driver']['surname'] ?? 'Unknown',
                    points: int.parse(result['points']?.toString() ?? '0'),
                    constructor: result['Constructor']['name'] ?? 'Unknown',
                  ))
              .toList(),
        );
      }).toList();
    } catch (e) {
      print('❌ Error parsing F1 races: $e');
      return [];
    }
  }

  static List<F1Driver> parseF1Standings(Response response) {
    try {
      final List standings = response.data['MRData']['StandingsTable']
              ['StandingsList'][0]['DriverStandings'] ??
          [];

      return standings
          .map((driver) => F1Driver(
                id: driver['Driver']['driverId'] ?? 'Unknown',
                name:
                    '${driver['Driver']['givenName']} ${driver['Driver']['familyName']}',
                number: int.parse(
                    driver['Driver']['permanentNumber']?.toString() ?? '0'),
                team: driver['Constructors'][0]['name'] ?? 'Unknown',
                position: int.parse(driver['position']?.toString() ?? '0'),
                points: int.parse(driver['points']?.toString() ?? '0'),
                wins: int.parse(driver['wins']?.toString() ?? '0'),
                podiums: 0,
              ))
          .toList();
    } catch (e) {
      print('❌ Error parsing F1 standings: $e');
      return [];
    }
  }

  // 🔴 RECIBE DATOS EN VIVO DE RUGBY Y RESPONDE
  static List<RugbyMatch> parseRugbyMatches(Response response) {
    try {
      final List events = response.data['events'] ?? [];

      return events
          .map((event) {
            final competitions = event['competitions'] as List;
            if (competitions.isEmpty) return null;

            final comp = competitions[0];
            final competitors = comp['competitors'] as List;

            return RugbyMatch(
              id: event['id'],
              homeTeam: competitors.isNotEmpty
                  ? competitors[0]['team']['displayName']
                  : 'Unknown',
              awayTeam: competitors.length > 1
                  ? competitors[1]['team']['displayName']
                  : 'Unknown',
              homeScore: int.parse(competitors.isNotEmpty
                  ? competitors[0]['score'].toString()
                  : '0'),
              awayScore: int.parse(competitors.length > 1
                  ? competitors[1]['score'].toString()
                  : '0'),
              venue: comp['venue']?['fullName'] ?? 'Unknown',
              date: DateTime.parse(event['date'] ?? DateTime.now().toString()),
              championship: comp['league']['name'] ?? 'Unknown',
              minute:
                  int.parse(comp['status']['displayClock']?.toString() ?? '0'),
              isLive: comp['status']['type']['name'] == 'STATUS_IN_PROGRESS',
              isFinished: comp['status']['type']['name'] == 'STATUS_FINAL',
            );
          })
          .whereType<RugbyMatch>()
          .toList();
    } catch (e) {
      print('❌ Error parsing rugby matches: $e');
      return [];
    }
  }

  // ❌ MANEJO DE ERRORES
  static void handleApiError(dynamic error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
          print('❌ Error: Timeout de conexión');
          break;
        case DioExceptionType.sendTimeout:
          print('❌ Error: Timeout al enviar datos');
          break;
        case DioExceptionType.receiveTimeout:
          print('❌ Error: Timeout al recibir datos');
          break;
        case DioExceptionType.badResponse:
          print('❌ Error HTTP: ${error.response?.statusCode}');
          if (error.response?.statusCode == 401) {
            print('⚠️  API Key inválida o expirada');
          }
          break;
        case DioExceptionType.cancel:
          print('❌ Error: Solicitud cancelada');
          break;
        case DioExceptionType.unknown:
          print('❌ Error desconocido: ${error.message}');
          break;
        default:
          print('❌ Error: ${error.message}');
      }
    }
  }

  // ✅ VALIDACIÓN DE RESPUESTA
  static bool isValidResponse(Response response) {
    try {
      return response.statusCode == 200 && response.data != null;
    } catch (e) {
      return false;
    }
  }
}
