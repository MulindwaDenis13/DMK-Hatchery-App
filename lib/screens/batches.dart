import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/batch/batch_bloc.dart';
import '../models/models.dart';
import '../models/enums.dart';
import '../widgets/status_badge.dart';
import '../widgets/progress_bar.dart';
import '../widgets/stat_card.dart';
import 'invoices/invoice.dart';

class BatchesScreen extends StatefulWidget {
  const BatchesScreen({super.key});

  @override
  State<BatchesScreen> createState() => _BatchesScreenState();
}

class _BatchesScreenState extends State<BatchesScreen> {
  final ScrollController _scrollController = ScrollController();
  String _searchQuery = '';
  String _selectedFilter = 'All';

  final List<String> _filters = ['All', 'Incubating', 'Completed', 'Cancelled'];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _loadBatches();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _loadBatches() {
    context.read<BatchBloc>().add(
          BatchLoadRequested(
            status: _selectedFilter.toLowerCase(),
            search: _searchQuery,
            page: 1,
          ),
        );
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      final state = context.read<BatchBloc>().state;
      if (state.status == AppState.success && state.hasMore) {
        context.read<BatchBloc>().add(
              BatchLoadMoreRequested(
                status: _selectedFilter.toLowerCase(),
                search: _searchQuery,
                page: state.currentPage + 1,
              ),
            );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Batches',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            letterSpacing: 0.3,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.green.shade700,
        foregroundColor: Colors.white,
        elevation: 2,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadBatches,
          ),
        ],
      ),
      body: Column(
        children: [
          // Search and Filter
          _buildSearchAndFilter(),
          // Batches List
          Expanded(
            child: BlocConsumer<BatchBloc, BatchState>(
              listener: (context, state) {
                if (state is BatchLoadFailure) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message!),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              builder: (context, state) {
                if (state.status == AppState.loading && state.isFirstLoad) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (state.status == AppState.success) {
                  if (state.batches.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.inbox_outlined,
                            size: 64,
                            color: Colors.grey.shade400,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No batches found',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Try adjusting your search or filter',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade400,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16),
                    itemCount: state.batches.length + (state.hasMore ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index >= state.batches.length) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16.0),
                          child: Center(
                            child: SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                              ),
                            ),
                          ),
                        );
                      }

                      final batch = state.batches[index];
                      return _buildBatchCard(batch);
                    },
                  );
                }

                if (state is BatchLoadFailure) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 64,
                          color: Colors.red.shade400,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Failed to load batches',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          state.message!,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _loadBatches,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green.shade700,
                          ),
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilter() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Search
          TextField(
            decoration: InputDecoration(
              hintText: 'Search batches by mark...',
              prefixIcon: Icon(
                Icons.search,
                color: Colors.green.shade600,
              ),
              suffixIcon: _searchQuery.isNotEmpty
                  ? IconButton(
                      icon: Icon(Icons.clear, color: Colors.grey.shade400),
                      onPressed: () {
                        setState(() {
                          _searchQuery = '';
                        });
                        _loadBatches();
                      },
                    )
                  : null,
              filled: true,
              fillColor: Colors.grey.shade50,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
            ),
            onChanged: (value) {
              setState(() {
                _searchQuery = value;
              });
              _loadBatches();
            },
          ),
          const SizedBox(height: 12),
          // Filter chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _filters.map((filter) {
                final isSelected = _selectedFilter == filter;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(filter),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        _selectedFilter = filter;
                      });
                      _loadBatches();
                    },
                    selectedColor: Colors.green.shade100,
                    labelStyle: TextStyle(
                      color: isSelected
                          ? Colors.green.shade700
                          : Colors.grey.shade600,
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.w400,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(
                        color: isSelected
                            ? Colors.green.shade300
                            : Colors.grey.shade300,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBatchCard(Batch batch) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    StatusBadge(
                      status: batch.status,
                      icon: _getStatusIcon(batch.status),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Mark: ${batch.mark}',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    OutlinedButton(
                      onPressed: () {
                        _navigateToInvoice(batch);
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        side: BorderSide(color: Colors.grey.shade300),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'View Invoice',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Main Content
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Basic Info Grid
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  childAspectRatio: 2.5,
                  children: [
                    _buildInfoItem('Incubator', batch.incubator.name),
                    _buildInfoItem(
                      'Start Date',
                      DateFormat('MMM d, yyyy').format(batch.startDate),
                    ),
                    _buildInfoItem(
                      'Expected End',
                      DateFormat('MMM d, yyyy').format(batch.expectedEndDate),
                    ),
                    _buildInfoItem('Total Eggs', batch.eggCount.toString()),
                  ],
                ),
                const SizedBox(height: 16),

                // Progress Bar
                ProgressBar(percentage: batch.progressPercentage),
                const SizedBox(height: 16),

                // Stats
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    StatCard(
                      label: 'Total Eggs',
                      value: batch.eggCount.toString(),
                    ),
                    StatCard(
                      label: 'Hatched',
                      value: batch.hatchedCount.toString(),
                      valueColor: Colors.green.shade600,
                    ),
                    StatCard(
                      label: 'Spoiled',
                      value: batch.spoiledCount.toString(),
                      valueColor: Colors.red.shade600,
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Hatching Activities Timeline
                if (batch.hatchingActivities.isNotEmpty) ...[
                  const Divider(),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(Icons.history,
                          size: 16, color: Colors.grey.shade400),
                      const SizedBox(width: 8),
                      Text(
                        'Hatching History',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxHeight: 200),
                    child: ListView.separated(
                      shrinkWrap: true,
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: batch.hatchingActivities.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        final activity = batch.hatchingActivities[index];
                        return _buildActivityItem(activity);
                      },
                    ),
                  ),
                ],

                // Notes
                if (batch.notes != null) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      batch.notes!,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: Colors.grey.shade400,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade800,
          ),
        ),
      ],
    );
  }

  Widget _buildActivityItem(HatchingActivity activity) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border(
          left: BorderSide(
            color: activity.isComplete
                ? Colors.green.shade500
                : Colors.blue.shade500,
            width: 4,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    DateFormat('MMM d, h:mm a').format(activity.recordedAt),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: activity.isComplete
                          ? Colors.green.shade600
                          : Colors.blue.shade600,
                    ),
                  ),
                  if (activity.isEarly) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.yellow.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'Early Hatch',
                        style: TextStyle(
                          fontSize: 9,
                          color: Colors.yellow.shade700,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                  if (activity.isComplete) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.green.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'Completed',
                        style: TextStyle(
                          fontSize: 9,
                          color: Colors.green.shade700,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              Text(
                _timeAgo(activity.recordedAt),
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey.shade400,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(Icons.check_circle, size: 14, color: Colors.green.shade500),
              const SizedBox(width: 4),
              Text(
                'Hatched: +${activity.hatchedCount}',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade700,
                ),
              ),
              const SizedBox(width: 16),
              Icon(Icons.cancel, size: 14, color: Colors.red.shade500),
              const SizedBox(width: 4),
              Text(
                'Spoiled: +${activity.spoiledCount}',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade700,
                ),
              ),
            ],
          ),
          if (activity.daysRemaining != null &&
              activity.daysRemaining! > 0) ...[
            const SizedBox(height: 4),
            Text(
              '${activity.daysRemaining} days before expected date',
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey.shade500,
              ),
            ),
          ],
        ],
      ),
    );
  }

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'incubating':
        return Icons.play_circle_outline;
      case 'completed':
        return Icons.check_circle_outline;
      case 'cancelled':
        return Icons.hourglass_top;
      default:
        return Icons.info_outline;
    }
  }

  String _timeAgo(DateTime date) {
    final difference = DateTime.now().difference(date);
    if (difference.inDays > 30) {
      return '${(difference.inDays / 30).floor()}mo ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }

  void _navigateToInvoice(Batch batch) {
    // Create mock invoice
    final invoice = batch.invoice;

    if (invoice == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Invoice not found",
          ),
          backgroundColor: Colors.red,
        ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => InvoiceScreen(invoice: invoice),
        ),
      );
    }
  }
}
