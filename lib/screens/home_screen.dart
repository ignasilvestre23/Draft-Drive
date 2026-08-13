//lib/screens/home_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'football/football_home_screen.dart';
import 'nba/nba_home_screen.dart';
import 'nfl/nfl_home_screen.dart';
import 'f1/f1_home_screen.dart';
import 'rugby/rugby_home_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            // Logo (si tienes imagen, usa Image.asset)
            Image.asset(
              'assets/images/logo.png',
              width: 50,
              height: 50,
              fit: BoxFit.contain,
            ),
            const SizedBox(width: 12),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'DRAFT & DRIVE',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Color(0xFFD4AF37),
                  ),
                ),
                Text(
                  'EN VIVO',
                  style: TextStyle(
                    fontSize: 10,
                    color: Color(0xFFD4AF37),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
        elevation: 8,
        shadowColor: Colors.black54,
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          indicatorColor: const Color(0xFFD4AF37),
          labelColor: const Color(0xFFD4AF37),
          unselectedLabelColor: Colors.white70,
          labelStyle: const TextStyle(fontWeight: FontWeight.w600),
          tabs: const [
            Tab(text: '⚽ Fútbol', icon: Icon(Icons.sports_soccer)),
            Tab(text: '🏀 NBA', icon: Icon(Icons.sports_basketball)),
            Tab(text: '🏈 NFL', icon: Icon(Icons.sports_football)),
            Tab(text: '🏎️ F1', icon: Icon(Icons.two_wheeler)),
            Tab(text: '🏉 Rugby', icon: Icon(Icons.sports_rugby)),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          FootballHomeScreen(),
          NBAHomeScreen(),
          NFLHomeScreen(),
          F1HomeScreen(),
          RugbyHomeScreen(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Draft & Drive - Datos EN VIVO 🔴'),
              duration: Duration(seconds: 2),
            ),
          );
        },
        backgroundColor: const Color(0xFFD4AF37),
        child: const Icon(Icons.refresh, color: Colors.black),
      ),
    );
  }
}
