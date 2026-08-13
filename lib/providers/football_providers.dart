// lib/providers/football_providers.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import '../models/draft_models.dart';
import '../services/http_service.dart';

final httpServiceProvider = Provider((ref) => HttpService());

// ============= FOOTBALL MATCHES (EN VIVO) =============
final footballLiveMatchesProvider =
    FutureProvider.family<List<FootballMatch>, String>((ref, leagueId) async {
  final httpService = ref.watch(httpServiceProvider);

  try {
    final response = await httpService.getFootballLiveMatches(
      leagueId: leagueId,
      status: 'live',
    );

    final matches = response.data['response'] as List;
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
        homeGoalScorers: List<String>.from(
          (match['events'] as List?)
                  ?.where((e) =>
                      e['type'] == 'Goal' &&
                      e['team']['id'] == match['teams']['home']['id'])
                  .map((e) =>
                      '${e['player']['name']} (${e["time"]["elapsed"]}\')')
                  .toList() ??
              [],
        ),
        awayGoalScorers: List<String>.from(
          (match['events'] as List?)
                  ?.where((e) =>
                      e['type'] == 'Goal' &&
                      e['team']['id'] == match['teams']['away']['id'])
                  .map((e) =>
                      '${e['player']['name']} (${e["time"]["elapsed"]}\')')
                  .toList() ??
              [],
        ),
        matchType: 'league',
        isLive: match['fixture']['status']['short'] == 'LIV',
        isFinished: match['fixture']['status']['short'] == 'FT',
      );
    }).toList();
  } catch (e) {
    print('Error fetching live matches: $e');
    return [];
  }
});

// ============= FOOTBALL FIXTURES (PRÓXIMOS PARTIDOS) =============
final footballFixturesProvider =
    FutureProvider.family<List<FootballMatch>, String>((ref, leagueId) async {
  final httpService = ref.watch(httpServiceProvider);

  try {
    final response = await httpService.getFootballLiveMatches(
      leagueId: leagueId,
      status: 'scheduled',
    );

    final matches = response.data['response'] as List;
    return matches.map((match) {
      return FootballMatch(
        id: match['fixture']['id'].toString(),
        homeTeam: match['teams']['home']['name'] ?? 'Unknown',
        awayTeam: match['teams']['away']['name'] ?? 'Unknown',
        homeScore: 0,
        awayScore: 0,
        status: 'SCHEDULED',
        minute: 0,
        league: match['league']['name'] ?? 'Unknown',
        matchDate: DateTime.parse(
            match['fixture']['date'] ?? DateTime.now().toString()),
        homeGoalScorers: [],
        awayGoalScorers: [],
        matchType: 'league',
        isLive: false,
        isFinished: false,
      );
    }).toList();
  } catch (e) {
    print('Error fetching fixtures: $e');
    return [];
  }
});

// ============= FOOTBALL STANDINGS =============
final footballStandingsProvider =
    FutureProvider.family<List<Map<String, dynamic>>, String>(
        (ref, leagueId) async {
  final httpService = ref.watch(httpServiceProvider);

  try {
    final response = await httpService.getFootballStandings(leagueId: leagueId);

    final standings =
        response.data['response'][0]['league']['standings'][0] as List;
    return standings.cast<Map<String, dynamic>>();
  } catch (e) {
    print('Error fetching standings: $e');
    return [];
  }
});

// ============= FOOTBALL TRANSFERS (FICHAJES) =============
final footballTransfersProvider =
    FutureProvider.family<List<FootballTransfer>, String>((ref, teamId) async {
  final httpService = ref.watch(httpServiceProvider);

  try {
    final response = await httpService.getFootballTeamTransfers(teamId: teamId);

    final transfers = response.data['response'] as List;
    return transfers.map((transfer) {
      return FootballTransfer(
        playerName: transfer['player']['name'] ?? 'Unknown',
        fromClub: transfer['transfers'][0]['from'] ?? 'Unknown',
        toClub: transfer['transfers'][0]['to'] ?? 'Unknown',
        fee: transfer['transfers'][0]['transfer']['transfer_in'] ?? 'Free',
        position: transfer['player']['position'] ?? 'N/A',
        nationality: transfer['player']['nationality'] ?? 'Unknown',
      );
    }).toList();
  } catch (e) {
    print('Error fetching transfers: $e');
    return [];
  }
});

// ============= AUTO REFRESH (Actualizar cada 10 segundos) =============
class FootballRefreshService {
  static Timer? _timer;

  static void startAutoRefresh(WidgetRef ref) {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 10), (timer) {
      // Refrescar todas las pantallas en vivo
      ref.refresh(footballLiveMatchesProvider('39')); // Premier
      ref.refresh(footballLiveMatchesProvider('140')); // La Liga
      ref.refresh(footballLiveMatchesProvider('135')); // Serie A
      ref.refresh(footballLiveMatchesProvider('78')); // Bundesliga
    });
  }

  static void stopAutoRefresh() {
    _timer?.cancel();
    _timer = null;
  }
}
