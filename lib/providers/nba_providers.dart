// lib/providers/nba_providers.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../models/draft_models.dart';
import '../services/http_service.dart';
import 'dart:async';

// ============= NBA GAMES (EN VIVO) =============
final nbaGamesProvider =
    FutureProvider.family<List<NBAGame>, String>((ref, date) async {
  final httpService = ref.watch(httpServiceProvider);

  try {
    // Si no pasa fecha, usar hoy
    final gameDate =
        date.isEmpty ? DateFormat('yyyy-MM-dd').format(DateTime.now()) : date;

    final response = await httpService.getNBAScoreboard(gameDate: gameDate);

    final resultSets = response.data['resultSets'] as List;
    if (resultSets.isEmpty) return [];

    final games = resultSets[0]['rowSet'] as List;
    return games.map((game) {
      return NBAGame(
        id: game[2].toString(),
        homeTeam: game[6] ?? 'Unknown',
        awayTeam: game[7] ?? 'Unknown',
        homeScore: game[23] ?? 0,
        awayScore: game[24] ?? 0,
        status: _getNBAGameStatus(game[4]),
        quarter: game[8] ?? 0,
        timeRemaining: game[9]?.toString() ?? '0:00',
        gameDate: DateTime.parse(gameDate),
      );
    }).toList();
  } catch (e) {
    print('Error fetching NBA games: $e');
    return [];
  }
});

// ============= NBA STANDINGS =============
final nbaStandingsEastProvider =
    FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final httpService = ref.watch(httpServiceProvider);

  try {
    final response = await httpService.getNBAStandings();

    // Filtrar solo conferencia ESTE
    final standings = response.data['resultSets'][0]['rowSet'] as List;
    return standings
        .where((team) => team[3] == 'East') // Conferencia ESTE
        .map((team) => {
              'rank': team[1],
              'teamName': team[2],
              'wins': team[4],
              'losses': team[5],
              'winPct': team[6],
            })
        .toList();
  } catch (e) {
    print('Error fetching NBA standings East: $e');
    return [];
  }
});

final nbaStandingsWestProvider =
    FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final httpService = ref.watch(httpServiceProvider);

  try {
    final response = await httpService.getNBAStandings();

    // Filtrar solo conferencia OESTE
    final standings = response.data['resultSets'][0]['rowSet'] as List;
    return standings
        .where((team) => team[3] == 'West') // Conferencia OESTE
        .map((team) => {
              'rank': team[1],
              'teamName': team[2],
              'wins': team[4],
              'losses': team[5],
              'winPct': team[6],
            })
        .toList();
  } catch (e) {
    print('Error fetching NBA standings West: $e');
    return [];
  }
});

// ============= NBA DRAFT =============
final nbaDraftProvider =
    FutureProvider.family<List<NBADraft>, int>((ref, year) async {
  final httpService = ref.watch(httpServiceProvider);

  try {
    final response = await httpService.getNBADraft(year: year);

    final picks = response.data['resultSets'][0]['rowSet'] as List;
    return picks.map((pick) {
      return NBADraft(
        year: pick[0],
        round: pick[1],
        pick: pick[2],
        playerName: pick[3] ?? 'Unknown',
        college: pick[5] ?? 'Unknown',
        nbaTeam: pick[4],
      );
    }).toList();
  } catch (e) {
    print('Error fetching NBA draft: $e');
    return [];
  }
});

// ============= HELPER FUNCTIONS =============
String _getNBAGameStatus(int statusCode) {
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

// ============= AUTO REFRESH (Actualizar cada 10 segundos) =============
class NBARefreshService {
  static Timer? _timer;

  static void startAutoRefresh(WidgetRef ref) {
    _timer?.cancel();
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    _timer = Timer.periodic(const Duration(seconds: 10), (timer) {
      ref.refresh(nbaGamesProvider(today));
      ref.refresh(nbaStandingsEastProvider);
      ref.refresh(nbaStandingsWestProvider);
    });
  }

  static void stopAutoRefresh() {
    _timer?.cancel();
    _timer = null;
  }
}
