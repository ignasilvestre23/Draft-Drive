// lib/models/sports_models.dart

// ============= FÚTBOL =============
class FootballMatch {
  final String id;
  final String homeTeam;
  final String awayTeam;
  final int homeScore;
  final int awayScore;
  final String status;
  final int minute;
  final String league;
  final DateTime matchDate;
  final List<String> homeGoalScorers;
  final List<String> awayGoalScorers;
  final String matchType;
  final bool isLive;
  final bool isFinished;

  FootballMatch({
    required this.id,
    required this.homeTeam,
    required this.awayTeam,
    required this.homeScore,
    required this.awayScore,
    required this.status,
    required this.minute,
    required this.league,
    required this.matchDate,
    required this.homeGoalScorers,
    required this.awayGoalScorers,
    required this.matchType,
    required this.isLive,
    required this.isFinished,
  });
}

class FootballTransfer {
  final String playerName;
  final String fromClub;
  final String toClub;
  final String fee;
  final String position;
  final String nationality;

  FootballTransfer({
    required this.playerName,
    required this.fromClub,
    required this.toClub,
    required this.fee,
    required this.position,
    required this.nationality,
  });
}

class FootballTeamStats {
  final String teamName;
  final int position;
  final int played;
  final int wins;
  final int draws;
  final int losses;
  final int points;
  final int goalsFor;
  final int goalsAgainst;
  final int goalDifference;

  FootballTeamStats({
    required this.teamName,
    required this.position,
    required this.played,
    required this.wins,
    required this.draws,
    required this.losses,
    required this.points,
    required this.goalsFor,
    required this.goalsAgainst,
    required this.goalDifference,
  });
}

class FootballLeague {
  final String id;
  final String name;
  final String country;
  final List<String> teams;

  FootballLeague({
    required this.id,
    required this.name,
    required this.country,
    required this.teams,
  });
}

class FootballNews {
  final String id;
  final String title;
  final String description;
  final DateTime date;
  final String category;

  FootballNews({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.category,
  });
}

// ============= NBA =============
class NBAGame {
  final String id;
  final String homeTeam;
  final String awayTeam;
  final int homeScore;
  final int awayScore;
  final String status;
  final int quarter;
  final String timeRemaining;
  final DateTime gameDate;

  NBAGame({
    required this.id,
    required this.homeTeam,
    required this.awayTeam,
    required this.homeScore,
    required this.awayScore,
    required this.status,
    required this.quarter,
    required this.timeRemaining,
    required this.gameDate,
  });
}

class NBADraft {
  final int year;
  final int round;
  final int pick;
  final String playerName;
  final String college;
  final String? nbaTeam;

  NBADraft({
    required this.year,
    required this.round,
    required this.pick,
    required this.playerName,
    required this.college,
    this.nbaTeam,
  });
}

class NBATransfer {
  final String playerName;
  final String fromTeam;
  final String toTeam;
  final DateTime date;
  final String? contractLength;
  final String? salary;

  NBATransfer({
    required this.playerName,
    required this.fromTeam,
    required this.toTeam,
    required this.date,
    this.contractLength,
    this.salary,
  });
}

class NBANews {
  final String id;
  final String title;
  final String description;
  final DateTime date;
  final String category;

  NBANews({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.category,
  });
}

// ============= NFL =============
class NFLGame {
  final String id;
  final String homeTeam;
  final String awayTeam;
  final int homeScore;
  final int awayScore;
  final String status;
  final int quarter;
  final int week;
  final DateTime date;
  final bool isLive;
  final bool isFinished;
  final String timeRemaining;

  NFLGame({
    required this.id,
    required this.homeTeam,
    required this.awayTeam,
    required this.homeScore,
    required this.awayScore,
    required this.status,
    required this.quarter,
    required this.week,
    required this.date,
    required this.isLive,
    required this.isFinished,
    required this.timeRemaining,
  });
}

class NFLTeam {
  final String id;
  final String name;
  final String conference;
  final String division;
  final int wins;
  final int losses;

  NFLTeam({
    required this.id,
    required this.name,
    required this.conference,
    required this.division,
    required this.wins,
    required this.losses,
  });
}

class NFLTransfer {
  final String playerName;
  final String fromTeam;
  final String toTeam;
  final String position;
  final String? salary;

  NFLTransfer({
    required this.playerName,
    required this.fromTeam,
    required this.toTeam,
    required this.position,
    this.salary,
  });
}

// ============= F1 =============
class F1Race {
  final String name;
  final String circuit;
  final String country;
  final String date;
  final int round;
  final String status;
  final int currentLap;
  final int totalLaps;
  final List<F1Result> results;

  F1Race({
    required this.name,
    required this.circuit,
    required this.country,
    required this.date,
    required this.round,
    required this.status,
    required this.currentLap,
    required this.totalLaps,
    required this.results,
  });
}

class F1Result {
  final int position;
  final String driverName;
  final int points;
  final String constructor;

  F1Result({
    required this.position,
    required this.driverName,
    required this.points,
    required this.constructor,
  });
}

class F1Driver {
  final String id;
  final String name;
  final int number;
  final String team;
  final int position;
  final int points;
  final int wins;
  final int podiums;

  F1Driver({
    required this.id,
    required this.name,
    required this.number,
    required this.team,
    required this.position,
    required this.points,
    required this.wins,
    required this.podiums,
  });
}

class F1Team {
  final String id;
  final String name;
  final String principal;
  final int points;
  final List<String> drivers;
  final int wins;

  F1Team({
    required this.id,
    required this.name,
    required this.principal,
    required this.points,
    required this.drivers,
    required this.wins,
  });
}

class F1News {
  final String id;
  final String title;
  final String description;
  final DateTime date;
  final String category;

  F1News({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.category,
  });
}

class F23Driver {
  final String id;
  final String name;
  final String team;
  final int number;
  final String category;
  final String country;
  final int wins;
  final int podiums;
  final int points;
  final int position;

  F23Driver({
    required this.id,
    required this.name,
    required this.team,
    required this.number,
    required this.category,
    required this.country,
    required this.wins,
    required this.podiums,
    required this.points,
    required this.position,
  });
}

class F1Transfer {
  final String driverName;
  final String fromTeam;
  final String toTeam;
  final DateTime date;
  final String? contractLength;
  final String? salary;

  F1Transfer({
    required this.driverName,
    required this.fromTeam,
    required this.toTeam,
    required this.date,
    this.contractLength,
    this.salary,
  });
}

// ============= RUGBY =============
class RugbyMatch {
  final String id;
  final String homeTeam;
  final String awayTeam;
  final int homeScore;
  final int awayScore;
  final String venue;
  final DateTime date;
  final String championship;
  final int minute;
  final bool isLive;
  final bool isFinished;

  RugbyMatch({
    required this.id,
    required this.homeTeam,
    required this.awayTeam,
    required this.homeScore,
    required this.awayScore,
    required this.venue,
    required this.date,
    required this.championship,
    required this.minute,
    required this.isLive,
    required this.isFinished,
  });
}

class RugbyTeam {
  final String id;
  final String name;
  final String country;
  final int worldRanking;
  final int points;
  final String? coach;
  final List<String> players;

  RugbyTeam({
    required this.id,
    required this.name,
    required this.country,
    required this.worldRanking,
    required this.points,
    this.coach,
    required this.players,
  });
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
