import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import '../models/revenue_model.dart';
import '../models/contract_model.dart';
import '../models/communication_model.dart';
import '../constants/app_config.dart';

class SampleDataService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Populate all sample data
  static Future<void> populateAllSampleData() async {
    try {
      print('Starting to populate all sample data...');
      
      await populateSampleUsers();
      await populateSampleRevenue();
      await populateSampleContracts();
      await populateSampleCommunications();
      
      print('All sample data populated successfully!');
    } catch (e) {
      print('Error populating sample data: $e');
      throw 'Failed to populate sample data: $e';
    }
  }

  // Populate sample users
  static Future<void> populateSampleUsers() async {
    try {
      final users = [
        User(
          id: 'user1',
          name: 'John Doe',
          email: 'john.doe@miamiteam.com',
          role: 'owner',
          ownershipPercentage: 25.0,
          totalInvestment: 500000.0,
          teamId: AppConfig.teamId,
          status: 'approved',
        ),
        User(
          id: 'user2',
          name: 'Sarah Wilson',
          email: 'sarah.wilson@miamiteam.com',
          role: 'owner',
          ownershipPercentage: 20.0,
          totalInvestment: 400000.0,
          teamId: AppConfig.teamId,
          status: 'approved',
        ),
        User(
          id: 'user3',
          name: 'Mike Chen',
          email: 'mike.chen@miamiteam.com',
          role: 'owner',
          ownershipPercentage: 15.0,
          totalInvestment: 300000.0,
          teamId: AppConfig.teamId,
          status: 'approved',
        ),
        User(
          id: 'user4',
          name: 'Emma Rodriguez',
          email: 'emma.rodriguez@miamiteam.com',
          role: 'owner',
          ownershipPercentage: 12.5,
          totalInvestment: 250000.0,
          teamId: AppConfig.teamId,
          status: 'pending',
        ),
        User(
          id: 'user5',
          name: 'David Thompson',
          email: 'david.thompson@miamiteam.com',
          role: 'owner',
          ownershipPercentage: 10.0,
          totalInvestment: 200000.0,
          teamId: AppConfig.teamId,
          status: 'pending',
        ),
        User(
          id: 'user6',
          name: 'Lisa Garcia',
          email: 'lisa.garcia@miamiteam.com',
          role: 'owner',
          ownershipPercentage: 8.5,
          totalInvestment: 170000.0,
          teamId: AppConfig.teamId,
          status: 'pending',
        ),
        User(
          id: 'user7',
          name: 'Admin User',
          email: 'admin@miamiteam.com',
          role: 'admin',
          ownershipPercentage: 0.0,
          totalInvestment: 0.0,
          teamId: AppConfig.teamId,
          status: 'approved',
        ),
      ];

      for (final user in users) {
        await _firestore.collection('users').doc(user.id).set(user.toJson());
      }

      print('Sample users populated successfully');
    } catch (e) {
      print('Error populating sample users: $e');
      throw 'Failed to populate sample users';
    }
  }

  // Populate sample revenue data
  static Future<void> populateSampleRevenue() async {
    try {
      final revenueData = [
        RevenueData(
          id: 'revenue1',
          season: '2024-2025',
          ticketSales: 850000.0,
          merchandise: 320000.0,
          sponsorships: 280000.0,
          advertising: 450000.0,
          totalRevenue: 1900000.0,
          date: DateTime(2024, 8, 1),
          teamId: AppConfig.teamId,
        ),
        RevenueData(
          id: 'revenue2',
          season: '2023-2024',
          ticketSales: 780000.0,
          merchandise: 290000.0,
          sponsorships: 250000.0,
          advertising: 420000.0,
          totalRevenue: 1740000.0,
          date: DateTime(2023, 8, 1),
          teamId: AppConfig.teamId,
        ),
        RevenueData(
          id: 'revenue3',
          season: '2022-2023',
          ticketSales: 720000.0,
          merchandise: 270000.0,
          sponsorships: 220000.0,
          advertising: 380000.0,
          totalRevenue: 1590000.0,
          date: DateTime(2022, 8, 1),
          teamId: AppConfig.teamId,
        ),
      ];

      for (final revenue in revenueData) {
        await _firestore.collection('revenue').add(revenue.toJson());
      }

      print('Sample revenue data populated successfully');
    } catch (e) {
      print('Error populating sample revenue: $e');
      throw 'Failed to populate sample revenue';
    }
  }

  // Populate sample contracts
  static Future<void> populateSampleContracts() async {
    try {
      final contracts = [
        Contract(
          id: 'contract1',
          name: 'Marcus Johnson',
          type: 'player',
          position: 'Point Guard',
          salary: 850000.0,
          startDate: DateTime(2024, 9, 1),
          endDate: DateTime(2027, 8, 31),
          status: 'active',
          teamId: AppConfig.teamId,
        ),
        Contract(
          id: 'contract2',
          name: 'Alex Rodriguez',
          type: 'player',
          position: 'Shooting Guard',
          salary: 650000.0,
          startDate: DateTime(2023, 9, 1),
          endDate: DateTime(2025, 8, 31),
          status: 'active',
          teamId: AppConfig.teamId,
        ),
        Contract(
          id: 'contract3',
          name: 'Chris Williams',
          type: 'player',
          position: 'Power Forward',
          salary: 750000.0,
          startDate: DateTime(2022, 9, 1),
          endDate: DateTime(2024, 8, 31),
          status: 'expired',
          teamId: AppConfig.teamId,
        ),
        Contract(
          id: 'contract4',
          name: 'Jordan Smith',
          type: 'player',
          position: 'Center',
          salary: 950000.0,
          startDate: DateTime(2024, 9, 1),
          endDate: DateTime(2026, 8, 31),
          status: 'active',
          teamId: AppConfig.teamId,
        ),
        Contract(
          id: 'contract5',
          name: 'Miami Arena',
          type: 'staff',
          position: 'Venue',
          salary: 120000.0,
          startDate: DateTime(2024, 1, 1),
          endDate: DateTime(2029, 12, 31),
          status: 'active',
          teamId: AppConfig.teamId,
        ),
        Contract(
          id: 'contract6',
          name: 'Nike Sports',
          type: 'staff',
          position: 'Equipment',
          salary: 300000.0,
          startDate: DateTime(2024, 6, 1),
          endDate: DateTime(2027, 5, 31),
          status: 'active',
          teamId: AppConfig.teamId,
        ),
      ];

      for (final contract in contracts) {
        await _firestore.collection('contracts').add(contract.toJson());
      }

      print('Sample contracts populated successfully');
    } catch (e) {
      print('Error populating sample contracts: $e');
      throw 'Failed to populate sample contracts';
    }
  }

  // Populate sample communications
  static Future<void> populateSampleCommunications() async {
    try {
      final communications = [
        Communication(
          id: '1',
          title: 'Season Opening Game Announcement',
          content: 'Join us for the exciting season opener against DC Sales Eagles on September 15th! This is a must-attend event for all team members and supporters.',
          type: CommunicationType.announcement,
          priority: CommunicationPriority.high,
          status: CommunicationStatus.published,
          authorId: 'admin',
          authorName: 'Team Management',
          teamId: AppConfig.teamId,
          recipients: ['all'],
          tags: ['event', 'season', 'game'],
          metadata: {
            'eventDate': '2024-09-15',
            'location': 'Miami Arena',
            'opponent': 'DC Sales Eagles',
          },
          createdAt: DateTime.now().subtract(const Duration(days: 2)),
          publishedAt: DateTime.now().subtract(const Duration(days: 2)),
          updatedAt: DateTime.now().subtract(const Duration(days: 2)),
          requiresAcknowledgement: true,
          acknowledgedBy: [],
          attachments: [],
          viewCount: 0,
          viewedBy: [],
        ),
        Communication(
          id: '2',
          title: 'New Player Signing',
          content: 'We are excited to announce the signing of rookie guard Alex Thompson. Alex brings exceptional talent and dedication to our team.',
          type: CommunicationType.news,
          priority: CommunicationPriority.normal,
          status: CommunicationStatus.published,
          authorId: 'admin',
          authorName: 'Team Management',
          teamId: AppConfig.teamId,
          recipients: ['all'],
          tags: ['player', 'signing', 'rookie'],
          metadata: {
            'playerName': 'Alex Thompson',
            'position': 'Guard',
            'experience': 'Rookie',
          },
          createdAt: DateTime.now().subtract(const Duration(days: 1)),
          publishedAt: DateTime.now().subtract(const Duration(days: 1)),
          updatedAt: DateTime.now().subtract(const Duration(days: 1)),
          requiresAcknowledgement: false,
          acknowledgedBy: [],
          attachments: [],
          viewCount: 0,
          viewedBy: [],
        ),
        Communication(
          id: '3',
          title: 'Q3 Revenue Report Available',
          content: 'The Q3 revenue report is now available in the dashboard. Please review the financial performance and provide feedback.',
          type: CommunicationType.report,
          priority: CommunicationPriority.normal,
          status: CommunicationStatus.published,
          authorId: 'admin',
          authorName: 'Finance Team',
          teamId: AppConfig.teamId,
          recipients: ['all'],
          tags: ['finance', 'report', 'Q3'],
          metadata: {
            'reportType': 'Revenue',
            'quarter': 'Q3',
            'year': '2024',
          },
          createdAt: DateTime.now().subtract(const Duration(hours: 6)),
          publishedAt: DateTime.now().subtract(const Duration(hours: 6)),
          updatedAt: DateTime.now().subtract(const Duration(hours: 6)),
          requiresAcknowledgement: true,
          acknowledgedBy: [],
          attachments: [],
          viewCount: 0,
          viewedBy: [],
        ),
        Communication(
          id: '4',
          title: 'Weekly Team Performance Update',
          content: 'This week\'s performance metrics show significant improvement in team coordination and individual player stats. Keep up the excellent work!',
          type: CommunicationType.teamUpdate,
          priority: CommunicationPriority.normal,
          status: CommunicationStatus.published,
          authorId: 'coach',
          authorName: 'Head Coach',
          teamId: AppConfig.teamId,
          recipients: ['all'],
          tags: ['performance', 'weekly', 'update'],
          metadata: {
            'updateType': 'Weekly',
            'category': 'Performance',
          },
          createdAt: DateTime.now().subtract(const Duration(hours: 2)),
          publishedAt: DateTime.now().subtract(const Duration(hours: 2)),
          updatedAt: DateTime.now().subtract(const Duration(hours: 2)),
          requiresAcknowledgement: false,
          acknowledgedBy: [],
          attachments: [],
          viewCount: 0,
          viewedBy: [],
        ),
        Communication(
          id: '5',
          title: 'Important Policy Update',
          content: 'Please review the updated team policies regarding player conduct and social media usage. Compliance is mandatory for all team members.',
          type: CommunicationType.policy,
          priority: CommunicationPriority.high,
          status: CommunicationStatus.published,
          authorId: 'admin',
          authorName: 'HR Department',
          teamId: AppConfig.teamId,
          recipients: ['all'],
          tags: ['policy', 'compliance', 'mandatory'],
          metadata: {
            'policyType': 'Conduct',
            'effectiveDate': '2024-08-01',
            'complianceRequired': true,
          },
          createdAt: DateTime.now().subtract(const Duration(hours: 1)),
          publishedAt: DateTime.now().subtract(const Duration(hours: 1)),
          updatedAt: DateTime.now().subtract(const Duration(hours: 1)),
          requiresAcknowledgement: true,
          acknowledgedBy: [],
          attachments: [],
          viewCount: 0,
          viewedBy: [],
        ),
        Communication(
          id: '6',
          title: 'Team Meeting Reminder',
          content: 'Don\'t forget about tomorrow\'s team meeting at 10 AM. Agenda includes season strategy discussion and player feedback session.',
          type: CommunicationType.reminder,
          priority: CommunicationPriority.normal,
          status: CommunicationStatus.published,
          authorId: 'admin',
          authorName: 'Team Coordinator',
          teamId: AppConfig.teamId,
          recipients: ['all'],
          tags: ['meeting', 'reminder', 'strategy'],
          metadata: {
            'meetingDate': '2024-08-02',
            'time': '10:00 AM',
            'location': 'Team Conference Room',
            'agenda': ['Season Strategy', 'Player Feedback'],
          },
          createdAt: DateTime.now().subtract(const Duration(minutes: 30)),
          publishedAt: DateTime.now().subtract(const Duration(minutes: 30)),
          updatedAt: DateTime.now().subtract(const Duration(minutes: 30)),
          requiresAcknowledgement: false,
          acknowledgedBy: [],
          attachments: [],
          viewCount: 0,
          viewedBy: [],
        ),
      ];

      for (final communication in communications) {
        await _firestore.collection('communications').add(communication.toJson());
      }

      print('Sample communications populated successfully');
    } catch (e) {
      print('Error populating sample communications: $e');
      throw 'Failed to populate sample communications';
    }
  }

  // Clear all sample data
  static Future<void> clearAllSampleData() async {
    try {
      print('Starting to clear all sample data...');
      
      await _clearCollection('users');
      await _clearCollection('revenue');
      await _clearCollection('contracts');
      await _clearCollection('communications');
      
      print('All sample data cleared successfully!');
    } catch (e) {
      print('Error clearing sample data: $e');
      throw 'Failed to clear sample data: $e';
    }
  }

  // Helper method to clear a collection
  static Future<void> _clearCollection(String collectionName) async {
    try {
      final querySnapshot = await _firestore
          .collection(collectionName)
          .where('teamId', isEqualTo: AppConfig.teamId)
          .get();

      final batch = _firestore.batch();
      for (final doc in querySnapshot.docs) {
        batch.delete(doc.reference);
      }

      await batch.commit();
      print('$collectionName collection cleared successfully');
    } catch (e) {
      print('Error clearing $collectionName collection: $e');
      throw 'Failed to clear $collectionName collection';
    }
  }

  // Get data counts for each collection
  static Future<Map<String, int>> getDataCounts() async {
    try {
      final usersCount = await _getCollectionCount('users');
      final revenueCount = await _getCollectionCount('revenue');
      final contractsCount = await _getCollectionCount('contracts');
      final communicationsCount = await _getCollectionCount('communications');

      return {
        'users': usersCount,
        'revenue': revenueCount,
        'contracts': contractsCount,
        'communications': communicationsCount,
      };
    } catch (e) {
      print('Error getting data counts: $e');
      return {
        'users': 0,
        'revenue': 0,
        'contracts': 0,
        'communications': 0,
      };
    }
  }

  // Helper method to get collection count
  static Future<int> _getCollectionCount(String collectionName) async {
    try {
      final querySnapshot = await _firestore
          .collection(collectionName)
          .where('teamId', isEqualTo: AppConfig.teamId)
          .get();

      return querySnapshot.docs.length;
    } catch (e) {
      print('Error getting $collectionName count: $e');
      return 0;
    }
  }
}
