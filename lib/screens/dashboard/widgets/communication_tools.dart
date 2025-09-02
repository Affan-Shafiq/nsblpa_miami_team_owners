import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../utils/theme.dart';
import '../../../services/firebase_service.dart';

import '../../../models/communication_model.dart';

class CommunicationTools extends StatefulWidget {
  const CommunicationTools({super.key});

  @override
  State<CommunicationTools> createState() => _CommunicationToolsState();
}

class _CommunicationToolsState extends State<CommunicationTools> {
  String _selectedTab = 'Announcements';
  final List<String> _tabs = ['Announcements', 'Team Updates', 'Messages'];
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  CommunicationType _selectedType = CommunicationType.announcement;
  CommunicationPriority _selectedPriority = CommunicationPriority.normal;
  bool _requiresAcknowledgement = false;

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header
        Container(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Communication',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Team announcements and updates',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              FloatingActionButton(
                onPressed: () {
                  _showCreateCommunicationDialog(context);
                },
                backgroundColor: AppTheme.primaryColor,
                child: const Icon(Icons.add, color: Colors.white),
              ),
              
            ],
          ),
        ),

        // Tab Bar
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: AppTheme.backgroundColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: _tabs.map((tab) {
              final isSelected = _selectedTab == tab;
              return Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedTab = tab;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                    decoration: BoxDecoration(
                      color: isSelected ? AppTheme.primaryColor : Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      tab,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: isSelected ? Colors.white : AppTheme.textSecondary,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                        fontSize: 13,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),

        const SizedBox(height: 16),

        // Content
        Expanded(
          child: _buildTabContent(),
        ),
      ],
    );
  }

  Widget _buildTabContent() {
    switch (_selectedTab) {
      case 'Announcements':
        return _buildAnnouncementsTab();
      case 'Team Updates':
        return _buildTeamUpdatesTab();
      case 'Messages':
        return _buildMessagesTab();
      default:
        return _buildAnnouncementsTab();
    }
  }

  Widget _buildAnnouncementsTab() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseService.getCommunicationsByType(CommunicationType.announcement),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final communications = snapshot.data?.docs ?? [];

        if (communications.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.announcement_outlined,
                    size: 64,
                    color: AppTheme.textSecondary.withOpacity(0.5),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No announcements yet',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: AppTheme.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Create the first announcement for your team',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppTheme.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ],
              ),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: communications.length,
          itemBuilder: (context, index) {
            final communication = communications[index];
            final data = communication.data() as Map<String, dynamic>;
            
            return _buildCommunicationCard(data, communication.id);
          },
        );
      },
    );
  }

  Widget _buildTeamUpdatesTab() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseService.getCommunicationsByType(CommunicationType.teamUpdate),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final communications = snapshot.data?.docs ?? [];

        if (communications.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.update_outlined,
                    size: 64,
                    color: AppTheme.textSecondary.withOpacity(0.5),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No team updates yet',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: AppTheme.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Share team performance and achievements',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppTheme.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ],
              ),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: communications.length,
          itemBuilder: (context, index) {
            final communication = communications[index];
            final data = communication.data() as Map<String, dynamic>;
            
            return _buildCommunicationCard(data, communication.id);
          },
        );
      },
    );
  }

  Widget _buildMessagesTab() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseService.getCommunicationsByType(CommunicationType.message),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final communications = snapshot.data?.docs ?? [];

        if (communications.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.chat_bubble_outline,
                    size: 64,
                    color: AppTheme.textSecondary.withOpacity(0.5),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No messages yet',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: AppTheme.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Start a conversation with your team',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppTheme.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () {
                      _showCreateCommunicationDialog(context);
                    },
                    icon: const Icon(Icons.message),
                    label: const Text('New Message'),
                  ),
                ],
              ),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: communications.length,
          itemBuilder: (context, index) {
            final communication = communications[index];
            final data = communication.data() as Map<String, dynamic>;
            
            return _buildCommunicationCard(data, communication.id);
          },
        );
      },
    );
  }

  Widget _buildCommunicationCard(Map<String, dynamic> data, String docId) {
    final type = data['type'] ?? 'announcement';
    final priority = data['priority'] ?? 'normal';
    final createdAt = data['createdAt'] != null 
        ? (data['createdAt'] as Timestamp).toDate() 
        : DateTime.now();
    final viewCount = data['viewCount'] ?? 0;
    final requiresAcknowledgement = data['requiresAcknowledgement'] ?? false;
    final acknowledgedBy = List<String>.from(data['acknowledgedBy'] ?? []);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: _getCommunicationTypeColor(type).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    _getCommunicationTypeIcon(type),
                    color: _getCommunicationTypeColor(type),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data['title'] ?? '',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              data['authorName'] ?? 'Unknown',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: AppTheme.primaryColor,
                                fontWeight: FontWeight.w500,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            DateFormat('MMM dd, yyyy').format(createdAt),
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppTheme.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: _getCommunicationTypeColor(type).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        type.toUpperCase(),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: _getCommunicationTypeColor(type),
                          fontWeight: FontWeight.w600,
                          fontSize: 10,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (priority == 'high' || priority == 'urgent') ...[
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: _getPriorityColor(priority).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          priority.toUpperCase(),
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: _getPriorityColor(priority),
                            fontWeight: FontWeight.w600,
                            fontSize: 8,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              data['content'] ?? '',
              style: Theme.of(context).textTheme.bodyMedium,
              overflow: TextOverflow.ellipsis,
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 16,
              runSpacing: 8,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.visibility,
                      size: 16,
                      color: AppTheme.textSecondary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '$viewCount views',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
                if (requiresAcknowledgement) ...[
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.check_circle,
                        size: 16,
                        color: acknowledgedBy.isNotEmpty 
                            ? AppTheme.successColor 
                            : AppTheme.warningColor,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        acknowledgedBy.isNotEmpty 
                            ? '${acknowledgedBy.length} acknowledged'
                            : 'Requires acknowledgement',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: acknowledgedBy.isNotEmpty 
                              ? AppTheme.successColor 
                              : AppTheme.warningColor,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ],
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      _viewCommunicationDetails(data, docId);
                    },
                    icon: const Icon(Icons.visibility),
                    label: const Text('View Details'),
                  ),
                ),
                if (requiresAcknowledgement && !acknowledgedBy.contains(FirebaseService.currentUser?.uid)) ...[
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        _acknowledgeCommunication(docId);
                      },
                      icon: const Icon(Icons.check_circle),
                      label: const Text('Acknowledge'),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getCommunicationTypeColor(String type) {
    switch (type) {
      case 'announcement':
        return AppTheme.primaryColor;
      case 'teamUpdate':
        return AppTheme.secondaryColor;
      case 'message':
        return AppTheme.accentColor;
      case 'event':
        return AppTheme.successColor;
      case 'news':
        return AppTheme.accentColor;
      case 'policy':
        return AppTheme.warningColor;
      case 'emergency':
        return AppTheme.errorColor;
      default:
        return AppTheme.textSecondary;
    }
  }

  IconData _getCommunicationTypeIcon(String type) {
    switch (type) {
      case 'announcement':
        return Icons.announcement;
      case 'teamUpdate':
        return Icons.update;
      case 'message':
        return Icons.message;
      case 'event':
        return Icons.event;
      case 'news':
        return Icons.newspaper;
      case 'policy':
        return Icons.policy;
      case 'emergency':
        return Icons.warning;
      default:
        return Icons.announcement;
    }
  }

  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'low':
        return AppTheme.successColor;
      case 'normal':
        return AppTheme.primaryColor;
      case 'high':
        return AppTheme.warningColor;
      case 'urgent':
        return AppTheme.errorColor;
      default:
        return AppTheme.textSecondary;
    }
  }

  void _showCreateCommunicationDialog(BuildContext context) {
    _titleController.clear();
    _contentController.clear();
    _selectedType = CommunicationType.announcement;
    _selectedPriority = CommunicationPriority.normal;
    _requiresAcknowledgement = false;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create Communication'),
        content: SingleChildScrollView(
          child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
                controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                  hintText: 'Enter communication title',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
                controller: _contentController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Content',
                  hintText: 'Enter communication content',
              ),
            ),
            const SizedBox(height: 16),
              DropdownButtonFormField<CommunicationType>(
              decoration: const InputDecoration(
                labelText: 'Type',
              ),
                value: _selectedType,
                items: CommunicationType.values.map((type) {
                  return DropdownMenuItem(
                    value: type,
                    child: Text(type.toString().split('.').last.replaceAll(RegExp(r'([A-Z])'), ' \$1').trim()),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _selectedType = value;
                    });
                  }
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<CommunicationPriority>(
                decoration: const InputDecoration(
                  labelText: 'Priority',
                ),
                value: _selectedPriority,
                items: CommunicationPriority.values.map((priority) {
                  return DropdownMenuItem(
                    value: priority,
                    child: Text(priority.toString().split('.').last.toUpperCase()),
                  );
                }).toList(),
              onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _selectedPriority = value;
                    });
                  }
                },
              ),
              const SizedBox(height: 16),
              CheckboxListTile(
                title: const Text('Requires Acknowledgement'),
                value: _requiresAcknowledgement,
                onChanged: (value) {
                  setState(() {
                    _requiresAcknowledgement = value ?? false;
                  });
                },
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.zero,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              _createCommunication();
              Navigator.pop(context);
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  void _createCommunication() async {
    if (_titleController.text.isEmpty || _contentController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    try {
      final currentUser = FirebaseService.currentUser;
      if (currentUser == null) return;

      final communication = Communication(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: _titleController.text,
        content: _contentController.text,
        type: _selectedType,
        priority: _selectedPriority,
        status: CommunicationStatus.published,
        authorId: currentUser.uid,
        authorName: currentUser.displayName ?? 'Unknown User',
        teamId: 'miami', // TODO: Get from AppConfig
        recipients: ['all'],
        tags: [],
        metadata: {},
        createdAt: DateTime.now(),
        publishedAt: DateTime.now(),
        updatedAt: DateTime.now(),
        requiresAcknowledgement: _requiresAcknowledgement,
        acknowledgedBy: [],
        attachments: [],
        viewCount: 0,
        viewedBy: [],
      );

      await FirebaseService.addCommunication(communication);
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Communication created successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error creating communication: $e')),
      );
    }
  }

  void _viewCommunicationDetails(Map<String, dynamic> data, String docId) {
    // TODO: Implement detailed view
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('View details feature coming soon')),
    );
  }

  void _acknowledgeCommunication(String docId) async {
    try {
      final currentUser = FirebaseService.currentUser;
      if (currentUser == null) return;

      await FirebaseService.acknowledgeCommunication(docId, currentUser.uid);
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Communication acknowledged')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error acknowledging communication: $e')),
      );
    }
  }
}
