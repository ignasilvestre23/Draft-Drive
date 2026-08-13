// lib/screens/nfl/nfl_home_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/nfl_providers.dart';

class NFLHomeScreen extends ConsumerWidget {
  const NFLHomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final standingsAsync = ref.watch(nflStandingsProvider);

    return RefreshIndicator(
      onRefresh: () async {
        ref.refresh(nflStandingsProvider);
      },
      child: standingsAsync.when(
        data: (standings) {
          if (standings.isEmpty) {
            return const Center(
              child: Text('No hay datos disponibles'),
            );
          }

          return ListView(
            padding: const EdgeInsets.all(12),
            children: [
              const Text(
                'Standings NFL 2024',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 12),
              Card(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columns: const [
                      DataColumn(label: Text('Equipo')),
                      DataColumn(label: Text('G')),
                      DataColumn(label: Text('P')),
                      DataColumn(label: Text('%')),
                    ],
                    rows: List.generate(
                      standings.length,
                      (index) {
                        final team = standings[index];
                        final wins = team['wins'] ?? 0;
                        final losses = team['losses'] ?? 0;
                        final total = wins + losses;
                        final pct = total > 0
                            ? (wins / total * 100).toStringAsFixed(1)
                            : '0.0';

                        return DataRow(cells: [
                          DataCell(
                            Text(
                              team['name'] ?? 'Unknown',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          DataCell(Text('$wins')),
                          DataCell(Text('$losses')),
                          DataCell(Text(pct)),
                        ]);
                      },
                    ),
                  ),
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text('Error: $err'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.refresh(nflStandingsProvider),
                child: const Text('Reintentar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
