class RevenueData {
  final String id;
  final String season;
  final double ticketSales;
  final double merchandise;
  final double sponsorships;
  final double advertising;
  final double totalRevenue;
  final DateTime date;
  final String teamId;

  RevenueData({
    required this.id,
    required this.season,
    required this.ticketSales,
    required this.merchandise,
    required this.sponsorships,
    required this.advertising,
    required this.totalRevenue,
    required this.date,
    required this.teamId,
  });

  factory RevenueData.fromJson(Map<String, dynamic> json) {
    return RevenueData(
      id: json['id'],
      season: json['season'],
      ticketSales: json['ticketSales'].toDouble(),
      merchandise: json['merchandise'].toDouble(),
      sponsorships: json['sponsorships']?.toDouble() ?? 0.0,
      advertising: json['advertising'].toDouble(),
      totalRevenue: json['totalRevenue'].toDouble(),
      date: DateTime.parse(json['date']),
      teamId: json['teamId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'season': season,
      'ticketSales': ticketSales,
      'merchandise': merchandise,
      'sponsorships': sponsorships,
      'advertising': advertising,
      'totalRevenue': totalRevenue,
      'date': date.toIso8601String(),
      'teamId': teamId,
    };
  }
}
