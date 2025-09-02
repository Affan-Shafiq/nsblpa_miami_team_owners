import '../models/user_model.dart';
import '../models/revenue_model.dart';
import '../models/contract_model.dart';

class DummyDataService {
  static final User currentUser = User(
    id: '1',
    name: 'John Smith',
    email: 'john.smith@miamirevenuerunners.com',
    role: 'Team Owner',
    ownershipPercentage: 15.5,
    totalInvestment: 250000.0,
    teamId: 'miami',
    status: 'approved',
  );

  static final List<RevenueData> revenueData = [
    RevenueData(
      id: '1',
      season: '2024-25',
      ticketSales: 850000.0,
      merchandise: 320000.0,
      sponsorships: 280000.0,
      advertising: 450000.0,
      totalRevenue: 1900000.0,
      date: DateTime(2024, 8, 1),
      teamId: 'miami',
    ),
    RevenueData(
      id: '2',
      season: '2023-24',
      ticketSales: 780000.0,
      merchandise: 290000.0,
      sponsorships: 250000.0,
      advertising: 420000.0,
      totalRevenue: 1740000.0,
      date: DateTime(2023, 8, 1),
      teamId: 'miami',
    ),
    RevenueData(
      id: '3',
      season: '2022-23',
      ticketSales: 720000.0,
      merchandise: 260000.0,
      sponsorships: 220000.0,
      advertising: 380000.0,
      totalRevenue: 1580000.0,
      date: DateTime(2022, 8, 1),
      teamId: 'miami',
    ),
  ];

  static final List<Contract> contracts = [
    Contract(
      id: '1',
      name: 'Mike Johnson',
      type: 'player',
      position: 'Point Guard',
      salary: 85000.0,
      startDate: DateTime(2024, 9, 1),
      endDate: DateTime(2025, 8, 31),
      status: 'active',
      teamId: 'miami',
    ),
    Contract(
      id: '2',
      name: 'Sarah Williams',
      type: 'player',
      position: 'Shooting Guard',
      salary: 78000.0,
      startDate: DateTime(2024, 9, 1),
      endDate: DateTime(2025, 8, 31),
      status: 'active',
      teamId: 'miami',
    ),
    Contract(
      id: '3',
      name: 'David Rodriguez',
      type: 'staff',
      position: 'Head Coach',
      salary: 95000.0,
      startDate: DateTime(2024, 6, 1),
      endDate: DateTime(2026, 5, 31),
      status: 'active',
      teamId: 'miami',
    ),
    Contract(
      id: '4',
      name: 'Lisa Chen',
      type: 'staff',
      position: 'Assistant Coach',
      salary: 65000.0,
      startDate: DateTime(2024, 8, 1),
      endDate: DateTime(2025, 7, 31),
      status: 'active',
      teamId: 'miami',
    ),
    Contract(
      id: '5',
      name: 'Robert Davis',
      type: 'player',
      position: 'Power Forward',
      salary: 82000.0,
      startDate: DateTime(2023, 9, 1),
      endDate: DateTime(2024, 8, 31),
      status: 'expired',
      teamId: 'miami',
    ),
  ];

  static final Map<String, dynamic> teamStats = {
    'totalValue': 2500000.0,
    'totalRevenue': 1620000.0,
    'profitMargin': 0.35,
    'roi': 0.28,
    'activeContracts': 4,
    'expiringContracts': 1,
  };

  static final List<Map<String, dynamic>> announcements = [
    {
      'id': '1',
      'title': 'Season Opening Game',
      'content': 'Join us for the season opener against DC Sales Eagles on September 15th!',
      'date': DateTime(2024, 8, 25),
      'type': 'event',
    },
    {
      'id': '2',
      'title': 'New Player Signing',
      'content': 'We are excited to announce the signing of rookie guard Alex Thompson.',
      'date': DateTime(2024, 8, 20),
      'type': 'news',
    },
    {
      'id': '3',
      'title': 'Revenue Report Available',
      'content': 'Q3 revenue report is now available in the dashboard.',
      'date': DateTime(2024, 8, 15),
      'type': 'update',
    },
  ];


}
