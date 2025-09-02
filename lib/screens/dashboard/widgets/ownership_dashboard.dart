import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../utils/theme.dart';
import '../../../services/firebase_service.dart';

import '../../../models/user_model.dart';

class OwnershipDashboard extends StatefulWidget {
  const OwnershipDashboard({super.key});

  @override
  State<OwnershipDashboard> createState() => _OwnershipDashboardState();
}

class _OwnershipDashboardState extends State<OwnershipDashboard> {
  User? _currentUser;
  Map<String, dynamic> _dashboardStats = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
  }

  Future<void> _loadDashboardData() async {
    try {
      final currentUser = FirebaseService.currentUser;
      if (currentUser != null) {
        final userData = await FirebaseService.getUserData(currentUser.uid);
        final dashboardStats = await FirebaseService.getTeamDashboardStats();
        
        setState(() {
          _currentUser = userData;
          _dashboardStats = dashboardStats;
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading dashboard: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_currentUser == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: AppTheme.textSecondary.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'Unable to load user data',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppTheme.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _loadDashboardData,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    final currencyFormat = NumberFormat.currency(symbol: '\$', decimalDigits: 0);
    final totalValue = _dashboardStats['totalValue'] ?? 0.0;
    final totalRevenue = _dashboardStats['totalRevenue'] ?? 0.0;
    final activeContracts = _dashboardStats['activeContracts'] ?? 0;
    final totalContracts = _dashboardStats['totalContracts'] ?? 0;
    final urgentCommunications = _dashboardStats['urgentCommunications'] ?? 0;
    final totalUsers = _dashboardStats['totalUsers'] ?? 0;
    final pendingUsers = _dashboardStats['pendingUsers'] ?? 0;

    // Calculate ROI based on current value vs investment
    final roi = _currentUser!.totalInvestment > 0 
        ? (totalValue - _currentUser!.totalInvestment) / _currentUser!.totalInvestment 
        : 0.0;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Welcome Section
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppTheme.primaryColor,
                  AppTheme.primaryColor.withValues(alpha: 0.8),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome back, ${_currentUser!.name}!',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Here\'s your team ownership overview',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.white.withValues(alpha: 0.9),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),




            

          // Ownership Stats Grid
          Text(
            'Your Ownership',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),

          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 1.5,
            children: [
              _buildStatCard(
                context,
                'Ownership %',
                '${_currentUser!.ownershipPercentage}%',
                Icons.pie_chart,
                AppTheme.primaryColor,
              ),
              _buildStatCard(
                context,
                'Total Investment',
                currencyFormat.format(_currentUser!.totalInvestment),
                Icons.account_balance_wallet,
                AppTheme.secondaryColor,
              ),
              _buildStatCard(
                context,
                'Current Value',
                currencyFormat.format(totalValue),
                Icons.trending_up,
                AppTheme.successColor,
              ),
              _buildStatCard(
                context,
                'ROI',
                '${(roi * 100).toStringAsFixed(1)}%',
                Icons.percent,
                roi >= 0 ? AppTheme.successColor : AppTheme.errorColor,
              ),
            ],
          ),

          const SizedBox(height: 32),

          // Team Performance
          Text(
            'Team Performance',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: _buildTeamStatCard(
                  context,
                  'Team Value',
                  currencyFormat.format(totalValue),
                  Icons.business,
                  AppTheme.primaryColor,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildTeamStatCard(
                  context,
                  'Annual Revenue',
                  currencyFormat.format(totalRevenue),
                  Icons.attach_money,
                  AppTheme.successColor,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: _buildTeamStatCard(
                  context,
                  'Active Contracts',
                  '$activeContracts / $totalContracts',
                  Icons.people,
                  AppTheme.secondaryColor,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildTeamStatCard(
                  context,
                  'Team Members',
                  '$totalUsers',
                  Icons.group,
                  AppTheme.accentColor,
                ),
              ),
            ],
          ),

          const SizedBox(height: 32),

          // Quick Actions
          Text(
            'Quick Actions',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: _buildActionCard(
                  context,
                  'View Revenue Report',
                  Icons.analytics_outlined,
                  AppTheme.primaryColor,
                  () {
                    // Navigate to revenue report (index 1)
                    _navigateToTab(1);
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildActionCard(
                  context,
                  'Manage Contracts',
                  Icons.description_outlined,
                  AppTheme.secondaryColor,
                  () {
                    // Navigate to contracts (index 2)
                    _navigateToTab(2);
                  },
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: _buildActionCard(
                  context,
                  'Team Announcements',
                  Icons.announcement_outlined,
                  AppTheme.successColor,
                  () {
                    // Navigate to communication (index 3)
                    _navigateToTab(3);
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                                  child: _buildActionCard(
                    context,
                    'Team Stats',
                    Icons.analytics_outlined,
                    AppTheme.accentColor,
                                      () {
                      // Navigate to communication (index 3)
                      _navigateToTab(3);
                    },
                ),
              ),
            ],
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  void _navigateToTab(int index) {
    // Navigate to the specific tab in the parent dashboard
    if (mounted) {
      // Use a callback to communicate with parent widget
      // For now, we'll use a simple approach with Navigator
      switch (index) {
        case 1: // Revenue
          Navigator.pushNamed(context, '/dashboard', arguments: {'tab': 1});
          break;
        case 2: // Contracts
          Navigator.pushNamed(context, '/dashboard', arguments: {'tab': 2});
          break;
        case 3: // Communication
          Navigator.pushNamed(context, '/dashboard', arguments: {'tab': 3});
          break;
      }
    }
  }

  Widget _buildStatCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Icon(
                icon,
                color: color,
                size: 18,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              value,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 3),
            Text(
              title,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppTheme.textSecondary,
                fontSize: 10,
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

  Widget _buildTeamStatCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    icon,
                    color: color,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              value,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionCard(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 24,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActivityItem(
    BuildContext context,
    String title,
    String time,
    IconData icon,
    Color color,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: color,
            size: 20,
          ),
        ),
        title: Text(
          title,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text(
          time,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: AppTheme.textSecondary,
          ),
        ),
        trailing: Icon(
          Icons.chevron_right,
          color: AppTheme.textSecondary,
        ),
      ),
    );
  }

  Widget _buildAlertItem(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    Color color,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      color: color.withValues(alpha: 0.05),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: color,
            size: 20,
          ),
        ),
        title: Text(
          title,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: color.withValues(alpha: 0.8),
          ),
        ),
        trailing: Icon(
          Icons.chevron_right,
          color: color,
        ),
      ),
    );
  }
}
