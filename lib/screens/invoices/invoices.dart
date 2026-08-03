import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/invoice/invoice_bloc.dart';
import '../../models/models.dart';
import '../../models/enums.dart';
import 'invoice.dart';

class InvoicesScreen extends StatefulWidget {
  const InvoicesScreen({super.key});

  @override
  State<InvoicesScreen> createState() => _InvoicesScreenState();
}

class _InvoicesScreenState extends State<InvoicesScreen> {
  final ScrollController _scrollController = ScrollController();
  String _searchQuery = '';
  String _selectedFilter = 'All';

  final List<String> _filters = [
    'All',
    'Paid',
    'Pending',
    'Overdue',
    'Cancelled'
  ];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _loadInvoices();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _loadInvoices() {
    context.read<InvoiceBloc>().add(
          InvoiceLoadRequested(
            status: _selectedFilter.toLowerCase(),
            search: _searchQuery,
            page: 1,
          ),
        );
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      final state = context.read<InvoiceBloc>().state;
      if (state.status == AppState.success && state.hasMore) {
        context.read<InvoiceBloc>().add(
              InvoiceLoadMoreRequested(
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
          'My Invoices',
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
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              _showFilterDialog();
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadInvoices,
          ),
        ],
      ),
      body: Column(
        children: [
          // Search
          _buildSearchBar(),
          // Invoices List
          Expanded(
            child: BlocConsumer<InvoiceBloc, InvoiceState>(
              listener: (context, state) {
                if (state is InvoiceLoadFailure) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.error!),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
                if (state.status == AppState.success && state.message != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message!),
                      backgroundColor: Colors.green,
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
                  final invoices = state.invoices;

                  if (invoices.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.receipt_long_outlined,
                            size: 64,
                            color: Colors.grey.shade400,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No invoices found',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _searchQuery.isNotEmpty || _selectedFilter != 'All'
                                ? 'Try adjusting your search or filter'
                                : 'Your invoices will appear here',
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
                    itemCount: invoices.length + (state.hasMore ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index >= invoices.length) {
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

                      final invoice = invoices[index];
                      return _buildInvoiceCard(invoice);
                    },
                  );
                }

                if (state is InvoiceLoadFailure) {
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
                          'Failed to load invoices',
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
                          onPressed: _loadInvoices,
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

  Widget _buildSearchBar() {
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
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search invoices by batch mark...',
          prefixIcon: Icon(
            Icons.search,
            color: Colors.green.shade600,
          ),
          filled: true,
          fillColor: Colors.grey.shade50,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: Icon(Icons.clear, color: Colors.grey.shade400),
                  onPressed: () {
                    setState(() {
                      _searchQuery = '';
                    });
                    _loadInvoices();
                  },
                )
              : null,
        ),
        onChanged: (value) {
          setState(() {
            _searchQuery = value;
          });
          _loadInvoices();
        },
      ),
    );
  }

  Widget _buildInvoiceCard(Invoice invoice) {
    final isPaid = invoice.status.toLowerCase() == 'paid';
    final balance = invoice.balance;
    final totalAmount = invoice.totalAmount;

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
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => InvoiceScreen(invoice: invoice),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: _getStatusColor(invoice.status)
                                .withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            invoice.status.toUpperCase(),
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: _getStatusColor(invoice.status),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Mark: ${invoice.batch.mark}',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                    Icon(
                      Icons.chevron_right,
                      color: Colors.grey.shade400,
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Invoice Info - No Customer Details
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          invoice.invoiceNumber,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Date: ${DateFormat('MMM d, yyyy').format(invoice.date)}',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          _formatCurrency(totalAmount),
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: isPaid
                                ? Colors.green.shade700
                                : Colors.orange.shade700,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${invoice.hatchedEggs.toInt()} chicks',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Balance Row
                if (!isPaid && balance > 0) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Colors.orange.shade200,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.account_balance_wallet,
                              size: 16,
                              color: Colors.orange.shade700,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Balance Due:',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Colors.orange.shade700,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          _formatCurrency(balance),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange.shade700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                ],

                // Paid indicator for fully paid invoices
                if (isPaid) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Colors.green.shade200,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.check_circle,
                              size: 16,
                              color: Colors.green.shade700,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Fully Paid',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Colors.green.shade700,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          _formatCurrency(0),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.green.shade700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                ],

                // Progress indicator for batch
                Container(
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(2),
                  ),
                  child: FractionallySizedBox(
                    widthFactor: invoice.batch.progressPercentage / 100,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.green.shade600,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Incubation Progress',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade500,
                      ),
                    ),
                    Text(
                      '${invoice.batch.progressPercentage.toStringAsFixed(0)}%',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade500,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'paid':
        return Colors.green.shade600;
      case 'pending':
        return Colors.orange.shade600;
      case 'overdue':
        return Colors.red.shade600;
      default:
        return Colors.grey.shade600;
    }
  }

  void _showFilterDialog() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Filter Invoices',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade900,
                ),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                children: _filters.map((filter) {
                  final isSelected = _selectedFilter == filter;
                  return FilterChip(
                    label: Text(filter),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        _selectedFilter = filter;
                      });
                      Navigator.pop(context);
                      _loadInvoices();
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
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
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
