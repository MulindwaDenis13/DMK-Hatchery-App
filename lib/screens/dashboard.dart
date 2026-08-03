import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/models.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/dashboard/dashboard_bloc.dart';
import '../models/enums.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    _loadDashboard();
  }

  _loadDashboard() {
    context.read<DashboardBloc>().add(
          GetDashboardStats(),
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardBloc, DashboardState>(
      builder: (context, state) {
        if (state.status == AppState.loading) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (state.status == AppState.failure) {
          return Scaffold(
            body: Center(
              child: Text(
                state.error ?? "Failed to load dashboard",
              ),
            ),
          );
        }

        final dashboard = state.data;

        if (dashboard == null) {
          return const Scaffold(
            body: Center(
              child: Text(
                "No dashboard data available",
              ),
            ),
          );
        }

        return Scaffold(
          body: SafeArea(
            child: CustomScrollView(
              slivers: [
                SliverAppBar(
                  expandedHeight: 120,
                  floating: true,
                  pinned: true,
                  backgroundColor: Colors.green.shade700,
                  foregroundColor: Colors.white,
                  flexibleSpace: FlexibleSpaceBar(
                    titlePadding: const EdgeInsets.only(left: 16, bottom: 16),
                    title: const Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Good Morning 👋",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          "Denis Mulindwa",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.all(16),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      _buildStatsGrid(dashboard),
                      const SizedBox(height: 16),
                      _buildChartsRow(dashboard),
                      const SizedBox(height: 16),
                      _buildRecentActivity(dashboard),
                      const SizedBox(height: 16),
                      _buildQuickActions(),
                    ]),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatsGrid(Dashboard dashboard) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.1,
      children: [
        _buildStatCard(
          title: 'Total Batches',
          value: dashboard.total_batches.toString(),
          icon: Icons.inventory_2_outlined,
          color: Colors.blue.shade600,
          backgroundColor: Colors.blue.shade50,
          subtitle: '${dashboard.active_batches} Active',
        ),
        _buildStatCard(
          title: 'Paid Invoices',
          value: dashboard.total_paid_invoices.toString(),
          icon: Icons.check_circle_outline,
          color: Colors.green.shade600,
          backgroundColor: Colors.green.shade50,
          subtitle: _formatCurrency(dashboard.total_paid_amount),
        ),
        _buildStatCard(
          title: 'Unpaid Invoices',
          value: dashboard.total_unpaid_invoices.toString(),
          icon: Icons.pending_actions_outlined,
          color: Colors.orange.shade600,
          backgroundColor: Colors.orange.shade50,
          subtitle: _formatCurrency(dashboard.total_amount_due),
        ),
        _buildStatCard(
          title: 'Amount Due',
          value: _formatCurrency(dashboard.total_amount_due),
          icon: Icons.money_off_outlined,
          color: Colors.red.shade600,
          backgroundColor: Colors.red.shade50,
          subtitle: '${dashboard.total_unpaid_invoices} pending',
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    required Color backgroundColor,
    String? subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 20,
                ),
              ),
              if (subtitle != null)
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey.shade500,
                    fontWeight: FontWeight.w500,
                  ),
                ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade900,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChartsRow(Dashboard dashboard) {
    return Row(
      children: [
        Expanded(
          child: _buildChartCard(
            title: 'Batch Status',
            data: {
              'Active': dashboard.active_batches,
              'Completed': dashboard.completed_batches,
              'Pending': dashboard.total_batches -
                  dashboard.active_batches -
                  dashboard.completed_batches,
            },
            colors: [
              Colors.blue.shade600,
              Colors.green.shade600,
              Colors.orange.shade600,
            ],
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildChartCard(
            title: 'Invoice Status',
            data: {
              'Paid': dashboard.total_paid_invoices,
              'Unpaid': dashboard.total_unpaid_invoices,
            },
            colors: [
              Colors.green.shade600,
              Colors.red.shade600,
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildChartCard({
    required String title,
    required Map<String, int> data,
    required List<Color> colors,
  }) {
    final total = data.values.fold(0, (sum, value) => sum + value);
    if (total == 0) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade800,
              ),
            ),
            const SizedBox(height: 12),
            Center(
              child: Text(
                'No data available',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade400,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade800,
            ),
          ),
          const SizedBox(height: 12),
          // Mini bar chart
          Row(
            children: data.entries.toList().asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              final percentage = (item.value / total) * 100;
              final color = colors[index % colors.length];

              return Expanded(
                child: Column(
                  children: [
                    Container(
                      height: 60,
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        width: 20,
                        height: percentage > 0 ? percentage * 0.6 : 2,
                        decoration: BoxDecoration(
                          color: color,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.key,
                      style: TextStyle(
                        fontSize: 8,
                        color: Colors.grey.shade500,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      item.value.toString(),
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade800,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentActivity(Dashboard dashboard) {
    final recentBatches = dashboard.recent_batches;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.history,
                    color: Colors.green.shade700,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Recent Batches',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade900,
                    ),
                  ),
                ],
              ),
              TextButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('View all batches'),
                      backgroundColor: Colors.green,
                    ),
                  );
                },
                style: TextButton.styleFrom(
                  foregroundColor: Colors.green.shade700,
                ),
                child: const Text('View All'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ...recentBatches.map((batch) => _buildActivityItem(batch)),
        ],
      ),
    );
  }

  Widget _buildActivityItem(DashboardBatch batch) {
    IconData statusIcon;
    Color statusColor;

    switch (batch.status.toLowerCase()) {
      case 'active':
        statusIcon = Icons.play_circle_outline;
        statusColor = Colors.blue.shade600;
        break;
      case 'completed':
        statusIcon = Icons.check_circle_outline;
        statusColor = Colors.green.shade600;
        break;
      default:
        statusIcon = Icons.hourglass_top;
        statusColor = Colors.orange.shade600;
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.shade100,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              statusIcon,
              color: statusColor,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Batch ${batch.mark}',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade900,
                  ),
                ),
                Text(
                  '${batch.egg_count} eggs • ${batch.progressive_percentage.toStringAsFixed(0)}% complete',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade500,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              batch.status,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: statusColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quick Actions',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade900,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildActionButton(
                icon: Icons.add_box_outlined,
                label: 'New Batch',
                color: Colors.green.shade600,
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Create new batch feature'),
                      backgroundColor: Colors.green,
                    ),
                  );
                },
              ),
              const SizedBox(width: 12),
              _buildActionButton(
                icon: Icons.receipt_long_outlined,
                label: 'Invoices',
                color: Colors.blue.shade600,
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('View invoices feature'),
                      backgroundColor: Colors.blue,
                    ),
                  );
                },
              ),
              const SizedBox(width: 12),
              _buildActionButton(
                icon: Icons.payment_outlined,
                label: 'Payments',
                color: Colors.orange.shade600,
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Make payment feature'),
                      backgroundColor: Colors.orange,
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.08),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: color.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                color: color,
                size: 28,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatCurrency(double amount) {
    final formatter = NumberFormat.currency(
      symbol: 'UGX ',
      decimalDigits: 0,
      locale: 'en_UG',
    );
    return formatter.format(amount);
  }
}
