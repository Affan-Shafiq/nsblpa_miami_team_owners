import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/communication_model.dart';
import '../constants/app_config.dart';

class CommunicationDataService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Populate Firebase with sample communication data
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

      // Add each communication to Firebase
      for (final communication in communications) {
        await _firestore.collection('communications').add(communication.toJson());
      }

      print('Sample communications populated successfully');
    } catch (e) {
      print('Error populating sample communications: $e');
      throw 'Failed to populate sample communications';
    }
  }

  // Clear all communications (for testing)
  static Future<void> clearAllCommunications() async {
    try {
      final querySnapshot = await _firestore
          .collection('communications')
          .where('teamId', isEqualTo: AppConfig.teamId)
          .get();

      final batch = _firestore.batch();
      for (final doc in querySnapshot.docs) {
        batch.delete(doc.reference);
      }

      await batch.commit();
      print('All communications cleared successfully');
    } catch (e) {
      print('Error clearing communications: $e');
      throw 'Failed to clear communications';
    }
  }

  // Get communication count
  static Future<int> getCommunicationCount() async {
    try {
      final querySnapshot = await _firestore
          .collection('communications')
          .where('teamId', isEqualTo: AppConfig.teamId)
          .get();

      return querySnapshot.docs.length;
    } catch (e) {
      print('Error getting communication count: $e');
      return 0;
    }
  }
}
