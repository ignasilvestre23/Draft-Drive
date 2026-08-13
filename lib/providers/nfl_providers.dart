// lib/providers/nfl_providers.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/draft_models.dart';
import '../services/http_service.dart';
import 'dart:async';

// ============= NFL GAMES (EN VIVO) =============
final nflGamesProvider =
    FutureProvider.family<List<NFLGame>, String>((ref, teamId) async {
  final httpService = ref.watch(httpServiceProvider);

  try {
    final response = await httpService.getNFLTeamSchedule(teamId: teamId);

    final events = response.data['events'] as List;
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
    print('Error fetching NFL games: $e');
    return [];
  }
});

// ============= NFL STANDINGS =============
final nflStandingsProvider =
    FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final httpService = ref.watch(httpServiceProvider);

  try {
    final response = await httpService.getNFLStandings();

    final standings = response.data['standings'] as List;
    return standings
        .map((team) => {
              'name': team['team']['displayName'],
              'wins': team['stats'][0]['value'],
              'losses': team['stats'][1]['value'],
              'division': team['division'],
              'conference': team['conference'],
            })
        .toList();
  } catch (e) {
    print('Error fetching NFL standings: $e');
    return [];
  }
});

// ============= NFL TEAMS =============
final nflTeamsProvider = FutureProvider<List<NFLTeam>>((ref) async {
  // Datos estáticos de equipos NFL (no cambian)
  return [
    // AFC EAST
    NFLTeam(
      id: 'buf',
      name: 'Buffalo Bills',
      conference: 'AFC',
      division: 'East',
      wins: 0,
      losses: 0,
    ),
    NFLTeam(
      id: 'mia',
      name: 'Miami Dolphins',
      conference: 'AFC',
      division: 'East',
      wins: 0,
      losses: 0,
    ),
    NFLTeam(
      id: 'ne',
      name: 'New England Patriots',
      conference: 'AFC',
      division: 'East',
      wins: 0,
      losses: 0,
    ),
    NFLTeam(
      id: 'nyj',
      name: 'New York Jets',
      conference: 'AFC',
      division: 'East',
      wins: 0,
      losses: 0,
    ),

    // AFC SOUTH
    NFLTeam(
      id: 'hou',
      name: 'Houston Texans',
      conference: 'AFC',
      division: 'South',
      wins: 0,
      losses: 0,
    ),
    NFLTeam(
      id: 'ind',
      name: 'Indianapolis Colts',
      conference: 'AFC',
      division: 'South',
      wins: 0,
      losses: 0,
    ),
    NFLTeam(
      id: 'jax',
      name: 'Jacksonville Jaguars',
      conference: 'AFC',
      division: 'South',
      wins: 0,
      losses: 0,
    ),
    NFLTeam(
      id: 'ten',
      name: 'Tennessee Titans',
      conference: 'AFC',
      division: 'South',
      wins: 0,
      losses: 0,
    ),

    // AFC WEST
    NFLTeam(
      id: 'kc',
      name: 'Kansas City Chiefs',
      conference: 'AFC',
      division: 'West',
      wins: 0,
      losses: 0,
    ),
    NFLTeam(
      id: 'lv',
      name: 'Las Vegas Raiders',
      conference: 'AFC',
      division: 'West',
      wins: 0,
      losses: 0,
    ),
    NFLTeam(
      id: 'lar',
      name: 'Los Angeles Chargers',
      conference: 'AFC',
      division: 'West',
      wins: 0,
      losses: 0,
    ),
    NFLTeam(
      id: 'den',
      name: 'Denver Broncos',
      conference: 'AFC',
      division: 'West',
      wins: 0,
      losses: 0,
    ),

    // NFC EAST
    NFLTeam(
      id: 'dal',
      name: 'Dallas Cowboys',
      conference: 'NFC',
      division: 'East',
      wins: 0,
      losses: 0,
    ),
    NFLTeam(
      id: 'phi',
      name: 'Philadelphia Eagles',
      conference: 'NFC',
      division: 'East',
      wins: 0,
      losses: 0,
    ),
    NFLTeam(
      id: 'wsh',
      name: 'Washington Commanders',
      conference: 'NFC',
      division: 'East',
      wins: 0,
      losses: 0,
    ),
    NFLTeam(
      id: 'nyg',
      name: 'New York Giants',
      conference: 'NFC',
      division: 'East',
      wins: 0,
      losses: 0,
    ),

    // NFC SOUTH
    NFLTeam(
      id: 'atl',
      name: 'Atlanta Falcons',
      conference: 'NFC',
      division: 'South',
      wins: 0,
      losses: 0,
    ),
    NFLTeam(
      id: 'car',
      name: 'Carolina Panthers',
      conference: 'NFC',
      division: 'South',
      wins: 0,
      losses: 0,
    ),
    NFLTeam(
      id: 'no',
      name: 'New Orleans Saints',
      conference: 'NFC',
      division: 'South',
      wins: 0,
      losses: 0,
    ),
    NFLTeam(
      id: 'tb',
      name: 'Tampa Bay Buccaneers',
      conference: 'NFC',
      division: 'South',
      wins: 0,
      losses: 0,
    ),

    // NFC NORTH
    NFLTeam(
      id: 'chi',
      name: 'Chicago Bears',
      conference: 'NFC',
      division: 'North',
      wins: 0,
      losses: 0,
    ),
    NFLTeam(
      id: 'det',
      name: 'Detroit Lions',
      conference: 'NFC',
      division: 'North',
      wins: 0,
      losses: 0,
    ),
    NFLTeam(
      id: 'gb',
      name: 'Green Bay Packers',
      conference: 'NFC',
      division: 'North',
      wins: 0,
      losses: 0,
    ),
    NFLTeam(
      id: 'min',
      name: 'Minnesota Vikings',
      conference: 'NFC',
      division: 'North',
      wins: 0,
      losses: 0,
    ),

    // NFC WEST
    NFLTeam(
      id: 'ari',
      name: 'Arizona Cardinals',
      conference: 'NFC',
      division: 'West',
      wins: 0,
      losses: 0,
    ),
    NFLTeam(
      id: 'lary',
      name: 'Los Angeles Rams',
      conference: 'NFC',
      division: 'West',
      wins: 0,
      losses: 0,
    ),
    NFLTeam(
      id: 'sf',
      name: 'San Francisco 49ers',
      conference: 'NFC',
      division: 'West',
      wins: 0,
      losses: 0,
    ),
    NFLTeam(
      id: 'sea',
      name: 'Seattle Seahawks',
      conference: 'NFC',
      division: 'West',
      wins: 0,
      losses: 0,
    ),
  ];
});

// ============= AUTO REFRESH =============
class NFLRefreshService {
  static Timer? _timer;

  static void startAutoRefresh(WidgetRef ref) {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 10), (timer) {
      ref.refresh(nflStandingsProvider);
    });
  }

  static void stopAutoRefresh() {
    _timer?.cancel();
    _timer = null;
  }
}
