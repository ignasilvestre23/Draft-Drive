// lib/providers/f1_providers.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/draft_models.dart';
import '../services/http_service.dart';
import 'dart:async';

// ============= F1 RACES =============
final f1RacesProvider = FutureProvider<List<F1Race>>((ref) async {
  final httpService = ref.watch(httpServiceProvider);

  try {
    final year = DateTime.now().year;
    final response = await httpService.getF1Races(year: year);

    final races = response.data['MRData']['RaceTable']['Races'] as List;
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
    print('Error fetching F1 races: $e');
    return [];
  }
});

// ============= F1 DRIVER STANDINGS =============
final f1DriverStandingsProvider = FutureProvider<List<F1Driver>>((ref) async {
  final httpService = ref.watch(httpServiceProvider);

  try {
    final year = DateTime.now().year;
    final response = await httpService.getF1Standings(year: year);

    final standings = response.data['MRData']['StandingsTable']['StandingsList']
        [0]['DriverStandings'] as List;

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
              podiums: 0, // Calcular desde resultados
            ))
        .toList();
  } catch (e) {
    print('Error fetching F1 standings: $e');
    return [];
  }
});

// ============= F1 CONSTRUCTOR STANDINGS =============
final f1ConstructorStandingsProvider =
    FutureProvider<List<F1Team>>((ref) async {
  final httpService = ref.watch(httpServiceProvider);

  try {
    final year = DateTime.now().year;
    final response = await httpService.getF1ConstructorStandings(year: year);

    final standings = response.data['MRData']['StandingsTable']['StandingsList']
        [0]['ConstructorStandings'] as List;

    return standings
        .map((constructor) => F1Team(
              id: constructor['Constructor']['constructorId'] ?? 'Unknown',
              name: constructor['Constructor']['name'] ?? 'Unknown',
              principal: '', // No disponible en API
              points: int.parse(constructor['points']?.toString() ?? '0'),
              drivers: [], // Obtener de drivers standings
              wins: int.parse(constructor['wins']?.toString() ?? '0'),
            ))
        .toList();
  } catch (e) {
    print('Error fetching F1 constructor standings: $e');
    return [];
  }
});

// ============= F1 TEAMS =============
final f1TeamsProvider = FutureProvider<List<F1Team>>((ref) async {
  final constructorStandings = ref.watch(f1ConstructorStandingsProvider);

  return constructorStandings.when(
    data: (teams) => teams,
    loading: () => [],
    error: (err, stack) => [],
  );
});

// ============= F1 DRIVERS =============
final f1DriversProvider = FutureProvider<List<F1Driver>>((ref) async {
  final driverStandings = ref.watch(f1DriverStandingsProvider);

  return driverStandings.when(
    data: (drivers) => drivers,
    loading: () => [],
    error: (err, stack) => [],
  );
});

// ============= AUTO REFRESH =============
class F1RefreshService {
  static Timer? _timer;

  static void startAutoRefresh(WidgetRef ref) {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 30), (timer) {
      // Refresh menos frecuente para F1 (no hay cambios cada 10s)
      ref.refresh(f1RacesProvider);
      ref.refresh(f1DriverStandingsProvider);
      ref.refresh(f1ConstructorStandingsProvider);
    });
  }

  static void stopAutoRefresh() {
    _timer?.cancel();
    _timer = null;
  }
}
