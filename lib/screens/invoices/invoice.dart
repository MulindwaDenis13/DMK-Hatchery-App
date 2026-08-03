import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/models.dart';

class InvoiceScreen extends StatelessWidget {
  final Invoice invoice;

  const InvoiceScreen({
    super.key,
    required this.invoice,
  });

  @override
  Widget build(BuildContext context) {
    final isPaid = invoice.status.toLowerCase() == 'paid';
    final balance = invoice.balance;

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text(
          'Invoice',
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
            icon: const Icon(Icons.print),
            onPressed: () {
              // Print functionality
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Print feature coming soon'),
                  backgroundColor: Colors.green,
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 600),
          padding: const EdgeInsets.all(24),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: Colors.green.shade100,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.eco,
                          color: Colors.green.shade700,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'DMK Hatchery',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: Colors.grey.shade900,
                            ),
                          ),
                          Text(
                            'Quality Poultry & Hatchery Services',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.orange.shade400,
                          Colors.orange.shade600
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.description, color: Colors.white, size: 18),
                        SizedBox(width: 8),
                        Text(
                          'INVOICE',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 16),

              // Invoice Info
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Invoice No:',
                        style: TextStyle(
                            fontSize: 12, color: Colors.grey.shade600),
                      ),
                      Text(
                        invoice.invoiceNumber,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Date:',
                        style: TextStyle(
                            fontSize: 12, color: Colors.grey.shade600),
                      ),
                      Text(
                        DateFormat('MMM d, yyyy').format(invoice.date),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Customer & Batch Info
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Bill To:',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey.shade700,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            invoice.customer.name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            '📞 ${invoice.customer.phone}',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          Text(
                            '✉️ ${invoice.customer.email}',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          Text(
                            '📍 ${invoice.customer.location}',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Batch Information:',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey.shade700,
                            ),
                          ),
                          const SizedBox(height: 4),
                          _buildDetailRow('Batch Mark:', invoice.batch.mark),
                          _buildDetailRow(
                            'Incubator:',
                            invoice.batch.incubator.name,
                          ),
                          _buildDetailRow(
                            'Start Date:',
                            DateFormat('MMM d, yyyy')
                                .format(invoice.batch.startDate),
                          ),
                          _buildDetailRow(
                            'End Date:',
                            DateFormat('MMM d, yyyy')
                                .format(invoice.batch.expectedEndDate),
                          ),
                          _buildDetailRow(
                            'Status:',
                            invoice.status.toUpperCase(),
                            valueColor: isPaid
                                ? Colors.green.shade600
                                : Colors.orange.shade600,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Items Table
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade200),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    // Header
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(12),
                          topRight: Radius.circular(12),
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Text(
                              '#',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Text(
                              'Description',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              'Quantity',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              'Unit Price',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              'Total',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Item Row
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Text(
                              '1',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade700,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Hatched Chicks',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  'Successfully hatched chicks from incubation batch',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey.shade500,
                                  ),
                                ),
                                if (invoice.spoiledEggs > 0)
                                  Text(
                                    'Note: ${invoice.spoiledEggs} spoiled eggs were discarded',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.orange.shade600,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              '${invoice.hatchedEggs.toInt()} chicks',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              _formatCurrency(invoice.costPerHatched),
                              style: const TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              _formatCurrency(
                                  invoice.hatchedEggs * invoice.costPerHatched),
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Totals
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(12),
                          bottomRight: Radius.circular(12),
                        ),
                      ),
                      child: Column(
                        children: [
                          _buildTotalRow(
                            'Subtotal:',
                            _formatCurrency(
                                invoice.hatchedEggs * invoice.costPerHatched),
                          ),
                          _buildTotalRow(
                            'Total Amount:',
                            _formatCurrency(invoice.totalAmount),
                            isBold: true,
                            textColor: Colors.green.shade700,
                          ),
                          if (isPaid)
                            _buildTotalRow(
                              'Amount Paid:',
                              _formatCurrency(invoice.totalAmount),
                              textColor: Colors.green.shade600,
                            ),
                          // Balance Row
                          if (!isPaid && balance > 0) ...[
                            _buildTotalRow(
                              'Balance Due:',
                              _formatCurrency(balance),
                              isBold: true,
                              textColor: Colors.orange.shade700,
                            ),
                          ],
                          if (isPaid) ...[
                            _buildTotalRow(
                              'Balance:',
                              _formatCurrency(0),
                              isBold: true,
                              textColor: Colors.green.shade600,
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Payment Information
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.green.shade50, Colors.green.shade100],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Payment Information',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.green.shade800,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Bank: Centenary Bank',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade700,
                            ),
                          ),
                          Text(
                            'Account: DMK Hatchery',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade700,
                            ),
                          ),
                          Text(
                            'Account No: 0112345678900',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade700,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'M-PESA Paybill: 123456',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.green.shade700,
                            ),
                          ),
                          // Payment status
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: isPaid
                                  ? Colors.green.shade100
                                  : Colors.orange.shade100,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  isPaid ? Icons.check_circle : Icons.pending,
                                  size: 14,
                                  color: isPaid
                                      ? Colors.green.shade700
                                      : Colors.orange.shade700,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  isPaid
                                      ? 'Payment Completed'
                                      : 'Payment Pending',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: isPaid
                                        ? Colors.green.shade700
                                        : Colors.orange.shade700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.green.shade200),
                      ),
                      child: Center(
                        child: Text(
                          'SCAN\nTO PAY',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Colors.green.shade600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Footer
              Column(
                children: [
                  Text(
                    'Thank you for choosing DMK Hatchery!',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'For inquiries, contact our customer support',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey.shade500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Invoice generated on ${DateFormat('MMM d, yyyy h:mm a').format(DateTime.now())}',
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.grey.shade400,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade600,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: valueColor ?? Colors.grey.shade800,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTotalRow(String label, String value,
      {bool isBold = false, Color? textColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isBold ? 16 : 14,
              fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
              color: isBold ? Colors.grey.shade800 : Colors.grey.shade700,
            ),
          ),
          const SizedBox(width: 16),
          Text(
            value,
            style: TextStyle(
              fontSize: isBold ? 18 : 14,
              fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
              color: textColor ?? Colors.grey.shade800,
            ),
          ),
        ],
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
