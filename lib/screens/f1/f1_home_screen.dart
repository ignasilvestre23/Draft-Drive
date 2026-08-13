// lib/screens/f1/f1_home_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/f1_providers.dart';

class F1HomeScreen extends ConsumerWidget {
  const F1HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final racesAsync = ref.watch(f1RacesProvider);
    final standingsAsync = ref.watch(f1DriverStandingsProvider);

    return RefreshIndicator(
      onRefresh: () async {
        ref.refresh(f1RacesProvider);
        ref.refresh(f1DriverStandingsProvider);
      },
      child: racesAsync.when(
        data: (races) {
          return standingsAsync.when(
            data: (standings) {
              return ListView(
                padding: const EdgeInsets.all(12),
                children: [
                  const Text(
                    'Próximas Carreras',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...races.take(3).map((race) {
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              race.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '🏁 ${race.circuit} - ${race.country}',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                            Text(
                              'Fecha: ${race.date}',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                  const SizedBox(height: 20),
                  const Text(
                    'Standings de Pilotos',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Card(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        columns: const [
                          DataColumn(label: Text('Pos')),
                          DataColumn(label: Text('Piloto')),
                          DataColumn(label: Text('Equipo')),
                          DataColumn(label: Text('Pts')),
                        ],
                        rows: List.generate(
                          standings.take(10).length,
                          (index) {
                            final driver = standings[index];
                            return DataRow(cells: [
                              DataCell(Text('${driver.position}')),
                              DataCell(
                                Text(
                                  driver.name.split(' ').last,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              DataCell(
                                Text(
                                  driver.team.split(' ').last,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              DataCell(Text('${driver.points}')),
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
            error: (err, stack) => Center(child: Text('Error: $err')),
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
                onPressed: () => ref.refresh(f1RacesProvider),
                child: const Text('Reintentar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
