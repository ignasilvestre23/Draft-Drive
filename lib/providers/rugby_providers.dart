// lib/providers/rugby_providers.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/draft_models.dart';
import '../services/http_service.dart';
import 'dart:async';

// ============= RUGBY MATCHES =============
final rugbyMatchesProvider =
    FutureProvider.family<List<RugbyMatch>, String>((ref, teamId) async {
  final httpService = ref.watch(httpServiceProvider);

  try {
    final response = await httpService.getRugbyMatches(teamId: teamId);

    final events = response.data['events'] as List;
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
    print('Error fetching rugby matches: $e');
    return [];
  }
});

// ============= RUGBY TEAMS (SELECCIONES) =============
final rugbyTeamsProvider = FutureProvider<List<RugbyTeam>>((ref) async {
  // Datos estáticos de selecciones principales
  return [
    RugbyTeam(
      id: '1',
      name: 'All Blacks',
      country: 'Nueva Zelanda',
      worldRanking: 1,
      points: 91,
      coach: 'Scott Robertson',
      players: ['Rieko Ioane', 'Beauden Barrett', 'Sam Cane', 'Aaron Smith'],
    ),
    RugbyTeam(
      id: '2',
      name: 'Springboks',
      country: 'Sudáfrica',
      worldRanking: 2,
      points: 90,
      coach: 'Jacques Nienaber',
      players: [
        'Siya Kolisi',
        'Handré Pollard',
        'Faf de Klerk',
        'Damian Willemse'
      ],
    ),
    RugbyTeam(
      id: '3',
      name: 'England',
      country: 'Inglaterra',
      worldRanking: 3,
      points: 88,
      coach: 'Steve Borthwick',
      players: ['Owen Farrell', 'Maro Itoje', 'Ellis Genge', 'Dan Sheehan'],
    ),
    RugbyTeam(
      id: '4',
      name: 'France',
      country: 'Francia',
      worldRanking: 4,
      points: 86,
      coach: 'Fabien Galthié',
      players: [
        'Antoine Dupont',
        'Romain Ntamack',
        'Grégory Alldritt',
        'Thibault Flament'
      ],
    ),
    RugbyTeam(
      id: '5',
      name: 'Ireland',
      country: 'Irlanda',
      worldRanking: 5,
      points: 85,
      coach: 'Andy Farrell',
      players: ['Johnny Sexton', 'Peter OMahony', 'James Lowe', 'Dan Sheehan'],
    ),
    RugbyTeam(
      id: '6',
      name: 'Australia',
      country: 'Australia',
      worldRanking: 6,
      points: 83,
      coach: 'Joe Schmidt',
      players: [
        'Michael Hooper',
        'Bernard Foley',
        'Israel Folau',
        'Tate McDermott'
      ],
    ),
    RugbyTeam(
      id: '7',
      name: 'Argentina',
      country: 'Argentina',
      worldRanking: 7,
      points: 81,
      coach: 'Felipe Contepomi',
      players: [
        'Juan Martin Gonzalez',
        'Nicolas Sanchez',
        'Santiago Carreras',
        'Matías Moroni'
      ],
    ),
  ];
});

// ============= RUGBY TEAM STATS =============
final rugbyTeamStatsProvider =
    FutureProvider.family<RugbyTeamStats, String>((ref, teamId) async {
  // Fetch from API or use static data
  return RugbyTeamStats(
    teamName: 'Team Name',
    worldRanking: 0,
    played: 0,
    wins: 0,
    losses: 0,
    draws: 0,
    pointsFor: 0,
    pointsAgainst: 0,
    pointDifference: 0,
    tries: 0,
    conversions: 0,
    penalties: 0,
  );
});

// ============= RUGBY NEWS =============
final rugbyNewsProvider =
    FutureProvider.family<List<RugbyNews>, String>((ref, teamId) async {
  // Aquí irían noticias reales de una API
  return [
    RugbyNews(
      id: '1',
      title: 'All Blacks vence a Springboks en thriller',
      description: 'Nueva Zelanda se lleva una victoria 24-22 en Johannesburgo',
      date: DateTime.now().subtract(Duration(hours: 2)),
      category: 'Test Match',
    ),
    RugbyNews(
      id: '2',
      title: 'Francia prepara equipo para Six Nations',
      description: 'Galthié anuncia plantilla de 42 jugadores',
      date: DateTime.now().subtract(Duration(days: 1)),
      category: 'Selección',
    ),
  ];
});

// ============= AUTO REFRESH =============
class RugbyRefreshService {
  static Timer? _timer;

  static void startAutoRefresh(WidgetRef ref) {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 10), (timer) {
      ref.refresh(rugbyMatchesProvider('1'));
    });
  }

  static void stopAutoRefresh() {
    _timer?.cancel();
    _timer = null;
  }
}

class RugbyTeamStats {
  final String teamName;
  final int worldRanking;
  final int played;
  final int wins;
  final int losses;
  final int draws;
  final int pointsFor;
  final int pointsAgainst;
  final int pointDifference;
  final int tries;
  final int conversions;
  final int penalties;

  RugbyTeamStats({
    required this.teamName,
    required this.worldRanking,
    required this.played,
    required this.wins,
    required this.losses,
    required this.draws,
    required this.pointsFor,
    required this.pointsAgainst,
    required this.pointDifference,
    required this.tries,
    required this.conversions,
    required this.penalties,
  });
}

class RugbyNews {
  final String id;
  final String title;
  final String description;
  final DateTime date;
  final String category;

  RugbyNews({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.category,
  });
}
