class RevenueData {
  final String id;
  final String season;
  final double ticketSales;
  final double merchandise;
  final double advertising;
  final double totalRevenue;
  final DateTime date;

  RevenueData({
    required this.id,
    required this.season,
    required this.ticketSales,
    required this.merchandise,
    required this.advertising,
    required this.totalRevenue,
    required this.date,
  });

  factory RevenueData.fromJson(Map<String, dynamic> json) {
    return RevenueData(
      id: json['id'],
      season: json['season'],
      ticketSales: json['ticketSales'].toDouble(),
      merchandise: json['merchandise'].toDouble(),
      advertising: json['advertising'].toDouble(),
      totalRevenue: json['totalRevenue'].toDouble(),
      date: DateTime.parse(json['date']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'season': season,
      'ticketSales': ticketSales,
      'merchandise': merchandise,
      'advertising': advertising,
      'totalRevenue': totalRevenue,
      'date': date.toIso8601String(),
    };
  }
}
