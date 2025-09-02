import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../utils/theme.dart';
import '../../../services/firebase_service.dart';

import '../../../models/revenue_model.dart';

class RevenueReport extends StatelessWidget {
  const RevenueReport({super.key});

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(symbol: '\$', decimalDigits: 0);

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseService.getTeamRevenueData(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final revenueDocs = snapshot.data?.docs ?? [];
        final revenueData = revenueDocs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          return RevenueData.fromJson(data);
        }).toList();

        if (revenueData.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.attach_money_outlined,
                  size: 64,
                  color: AppTheme.textSecondary,
                ),
                const SizedBox(height: 16),
                Text(
                  'No revenue data available',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                Text(
                  'Revenue data will appear here once added by admin',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                ),
                
              ],
            ),
          );
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Text(
                'Revenue Report',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Season-wise team revenue breakdown',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppTheme.textSecondary,
                ),
              ),

              const SizedBox(height: 24),

              // Revenue Overview Card
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppTheme.successColor.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              Icons.trending_up,
                              color: AppTheme.successColor,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Total Revenue (${revenueData.first.season})',
                                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    color: AppTheme.textSecondary,
                                  ),
                                ),
                                Text(
                                  currencyFormat.format(revenueData.first.totalRevenue),
                                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.successColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      
                      // Revenue Metrics
                      Row(
                        children: [
                          Expanded(
                            child: _buildRevenueMetric(
                              'Ticket Sales',
                              currencyFormat.format(revenueData.first.ticketSales),
                              AppTheme.primaryColor,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildRevenueMetric(
                              'Merchandise',
                              currencyFormat.format(revenueData.first.merchandise),
                              AppTheme.secondaryColor,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildRevenueMetric(
                              'Sponsorships',
                              currencyFormat.format(revenueData.first.sponsorships),
                              AppTheme.accentColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

          const SizedBox(height: 24),

              // Revenue Breakdown
          Text(
            'Revenue Breakdown',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  _buildRevenueBreakdownItem(
                    context,
                    'Ticket Sales',
                    revenueData.first.ticketSales,
                    revenueData.first.totalRevenue,
                    Icons.event_seat,
                    AppTheme.primaryColor,
                  ),
                  const SizedBox(height: 16),
                  _buildRevenueBreakdownItem(
                    context,
                    'Merchandise',
                    revenueData.first.merchandise,
                    revenueData.first.totalRevenue,
                    Icons.shopping_bag,
                    AppTheme.secondaryColor,
                  ),
                      const SizedBox(height: 16),
                      _buildRevenueBreakdownItem(
                        context,
                        'Sponsorships',
                        revenueData.first.sponsorships,
                        revenueData.first.totalRevenue,
                        Icons.business,
                        AppTheme.accentColor,
                      ),
                  const SizedBox(height: 16),
                  _buildRevenueBreakdownItem(
                    context,
                    'Advertising',
                    revenueData.first.advertising,
                    revenueData.first.totalRevenue,
                    Icons.campaign,
                    AppTheme.accentColor,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Season Comparison
          Text(
            'Season Comparison',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),

          ...revenueData.map((data) => Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.calendar_today,
                  color: AppTheme.primaryColor,
                  size: 20,
                ),
              ),
              title: Text(
                data.season,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              subtitle: Text(
                'Total Revenue: ${currencyFormat.format(data.totalRevenue)}',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.textSecondary,
                ),
              ),
              trailing: Text(
                currencyFormat.format(data.totalRevenue),
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.successColor,
                ),
              ),
            ),
                     )),
        ],
      ),
        );
      },
    );
  }

  Widget _buildRevenueMetric(
    String title,
    String value,
    Color color,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: AppTheme.textSecondary,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildRevenueBreakdownItem(
    BuildContext context,
    String title,
    double amount,
    double total,
    IconData icon,
    Color color,
  ) {
    final percentage = (amount / total * 100).toStringAsFixed(1);
    final currencyFormat = NumberFormat.currency(symbol: '\$', decimalDigits: 0);

    return Row(
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '$percentage% of total revenue',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppTheme.textSecondary,
                ),
              ),
            ],
          ),
        ),
        Text(
          currencyFormat.format(amount),
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}
