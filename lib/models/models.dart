class Customer {
  final int id;
  final String name;
  final String phone;
  final String email;
  final String location;
  final String joinDate;
  final int totalHatched;
  final int totalEggs;
  final int batchCount;
  final String? imageUrl;
  final String? bio;

  Customer({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    required this.location,
    required this.joinDate,
    required this.totalHatched,
    required this.totalEggs,
    required this.batchCount,
    this.imageUrl,
    this.bio,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      id: json['id'],
      name: json['name'],
      phone: json['phone'],
      email: json['email'],
      location: json['location'],
      imageUrl: json['image_url'],
      bio: json['bio'],
      joinDate: json['join_date'],
      totalHatched: json['total_hatched'],
      batchCount: json['batches_count'],
      totalEggs: json['total_eggs'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'email': email,
      'location': location,
    };
  }
}

class Incubator {
  final int id;
  final String name;

  Incubator({
    required this.id,
    required this.name,
  });

  factory Incubator.fromJson(Map<String, dynamic> json) {
    return Incubator(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}

class HatchingActivity {
  final int id;
  final DateTime recordedAt;
  final int hatchedCount;
  final int unHatchedCount;
  final bool isComplete;
  final bool isEarly;
  final int? daysRemaining;

  HatchingActivity({
    required this.id,
    required this.recordedAt,
    required this.hatchedCount,
    required this.unHatchedCount,
    this.isComplete = false,
    this.isEarly = false,
    this.daysRemaining,
  });

  factory HatchingActivity.fromJson(Map<String, dynamic> json) {
    return HatchingActivity(
      id: json['id'],
      recordedAt: DateTime.parse(json['recorded_at']),
      hatchedCount: json['hatched_count'],
      unHatchedCount: json['unhatched_count'],
      isComplete: json['is_complete'] ?? false,
      isEarly: json['is_early'] ?? false,
      daysRemaining: json['days_remaining'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'recordedAt': recordedAt.toIso8601String(),
      'hatchedCount': hatchedCount,
      'unHatchedCount': unHatchedCount,
      'isComplete': isComplete,
      'isEarly': isEarly,
      'daysRemaining': daysRemaining,
    };
  }
}

class InvoiceSummary {
  final int id;
  final String invoiceNumber;
  final String status;
  final double balance;

  InvoiceSummary({
    required this.id,
    required this.invoiceNumber,
    required this.status,
    required this.balance,
  });

  factory InvoiceSummary.fromJson(Map<String, dynamic> json) {
    return InvoiceSummary(
      id: json['id'],
      invoiceNumber: json['invoice_number'] ?? '',
      status: json['status'] ?? '',
      balance: (json['balance'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

class Batch {
  final int id;
  final String mark;
  final Incubator incubator;
  final DateTime startDate;
  final DateTime expectedEndDate;
  final String status;
  final int eggCount;
  final int hatchedCount;
  final int clearCount;
  final double progressPercentage;
  final String? notes;
  final List<HatchingActivity> hatchingActivities;
  final InvoiceSummary? invoice;

  Batch({
    required this.id,
    required this.mark,
    required this.incubator,
    required this.startDate,
    required this.expectedEndDate,
    required this.status,
    required this.eggCount,
    required this.hatchedCount,
    required this.clearCount,
    required this.progressPercentage,
    this.notes,
    this.hatchingActivities = const [],
    this.invoice,
  });

  factory Batch.fromJson(Map<String, dynamic> json) {
    return Batch(
      id: json['id'],
      mark: json['mark'],
      incubator: Incubator.fromJson(json['incubator']),
      startDate: DateTime.parse(json['start_date']),
      expectedEndDate: DateTime.parse(json['expected_end_date']),
      status: json['status'],
      eggCount: json['egg_count'],
      hatchedCount: json['hatched_count'],
      clearCount: json['clear_count'],
      progressPercentage: (json['progress_percentage'] as num).toDouble(),
      notes: json['notes'],
      invoice: json['invoice'] != null
          ? InvoiceSummary.fromJson(json['invoice'])
          : null,
      hatchingActivities: (json['hatching_activities'] as List? ?? [])
          .map((e) => HatchingActivity.fromJson(e))
          .toList(),
    );
  }
}

class BatchSummary {
  final int id;
  final String mark;
  final double progressPercentage;

  BatchSummary({
    required this.id,
    required this.mark,
    required this.progressPercentage,
  });

  factory BatchSummary.fromJson(Map<String, dynamic> json) {
    return BatchSummary(
      id: json['id'],
      mark: json['mark'],
      progressPercentage: (json['progress_percentage'] as num).toDouble(),
    );
  }
}

class InvoiceList {
  final int id;
  final String invoiceNumber;
  final int hatchedEggs;
  final double totalAmount;
  final double balance;
  final DateTime date;
  final String status;
  final BatchSummary batch;

  InvoiceList({
    required this.id,
    required this.invoiceNumber,
    required this.totalAmount,
    required this.hatchedEggs,
    required this.date,
    required this.status,
    required this.balance,
    required this.batch,
  });

  factory InvoiceList.fromJson(Map<String, dynamic> json) {
    return InvoiceList(
      id: json['id'],
      invoiceNumber: json['invoice_number'],
      batch: BatchSummary.fromJson(json['batch']),
      hatchedEggs: json['hatched_eggs'],
      totalAmount: (json['total_amount'] as num).toDouble(),
      date: DateTime.parse(json['date']),
      status: json['status'],
      balance: (json['balance'] as num).toDouble(),
    );
  }
}

class Payment {
  final int id;
  final double amount;
  final String payment_method;
  final DateTime payment_date;

  Payment({
    required this.id,
    required this.amount,
    required this.payment_method,
    required this.payment_date,
  });

  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      id: json['id'],
      amount: (json['amount'] as num).toDouble(),
      payment_method: json['payment_method'],
      payment_date: DateTime.parse(json['payment_date']),
    );
  }
}

class Invoice {
  final int id;
  final String invoiceNumber;
  final Batch batch;
  final Customer customer;
  final int hatchedEggs;
  final int unHatchedEggs;
  final double costPerEgg;
  final double totalAmount;
  final double amountPaid;
  final double balance;
  final DateTime date;
  final String status;
  final double paymentProgress;
  final List<Payment> payments;

  Invoice({
    required this.id,
    required this.invoiceNumber,
    required this.batch,
    required this.customer,
    required this.hatchedEggs,
    required this.unHatchedEggs,
    required this.costPerEgg,
    required this.totalAmount,
    required this.amountPaid,
    required this.date,
    required this.status,
    required this.balance,
    required this.paymentProgress,
    this.payments = const [],
  });

  factory Invoice.fromJson(Map<String, dynamic> json) {
    return Invoice(
      id: json['id'],
      invoiceNumber: json['invoice_number'],
      batch: Batch.fromJson(json['batch']),
      customer: Customer.fromJson(json['customer']),
      hatchedEggs: json['hatched_eggs'],
      unHatchedEggs: json['unhatched_eggs'],
      costPerEgg: (json['cost_per_egg'] as num).toDouble(),
      totalAmount: (json['total_amount'] as num).toDouble(),
      amountPaid: (json['paid_amount'] as num).toDouble(),
      date: DateTime.parse(json['date']),
      status: json['status'],
      balance: (json['balance'] as num).toDouble(),
      paymentProgress: (json['payment_progress'] as num).toDouble(),
      payments: (json['payments'] as List? ?? [])
          .map((e) => Payment.fromJson(e))
          .toList(),
    );
  }
}

class DashboardBatch {
  final int id;
  final String mark;
  final String status;
  final int egg_count;
  final int hatched_count;
  final int progressive_percentage;

  DashboardBatch({
    required this.id,
    required this.mark,
    required this.status,
    required this.egg_count,
    required this.hatched_count,
    required this.progressive_percentage,
  });

  factory DashboardBatch.fromJson(Map<String, dynamic> json) {
    return DashboardBatch(
      id: json['id'],
      hatched_count: json['hatched_count'],
      egg_count: json['egg_count'],
      status: json['status'],
      mark: json['mark'],
      progressive_percentage: json['progressive_percentage'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'hatched_count': hatched_count,
      'egg_count': egg_count,
      'mark': mark,
      'status': status,
      'progressive_percentage': progressive_percentage
    };
  }
}

class Dashboard {
  final int total_batches;
  final int active_batches;
  final int completed_batches;
  final int total_paid_invoices;
  final int total_unpaid_invoices;
  final double total_paid_amount;
  final double total_amount_due;
  final String name;
  final List<DashboardBatch> recent_batches;

  Dashboard({
    required this.total_batches,
    required this.active_batches,
    required this.completed_batches,
    required this.total_paid_invoices,
    required this.total_paid_amount,
    required this.total_unpaid_invoices,
    required this.total_amount_due,
    required this.name,
    this.recent_batches = const [],
  });

  factory Dashboard.fromJson(Map<String, dynamic> json) {
    return Dashboard(
      total_batches: json['total_batches'],
      active_batches: json['active_batches'],
      completed_batches: json['completed_batches'],
      total_paid_invoices: json['total_paid_invoices'],
      total_paid_amount: (json['total_paid_amount'] as num).toDouble(),
      total_unpaid_invoices: json['total_unpaid_invoices'],
      total_amount_due: (json['total_amount_due'] as num).toDouble(),
      name: json['name'],
      recent_batches: (json['recent_batches'] as List? ?? [])
          .map((e) => DashboardBatch.fromJson(e))
          .toList(),
    );
  }
}

class Pagination<T> {
  final int currentPage;
  final List<T> data;
  final int lastPage;
  final int perPage;
  final int total;
  final bool hasMore;

  const Pagination({
    required this.currentPage,
    required this.data,
    required this.lastPage,
    required this.perPage,
    required this.total,
    required this.hasMore,
  });

  factory Pagination.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJsonT,
  ) {
    return Pagination<T>(
      currentPage: json['current_page'],
      data: (json['data'] as List<dynamic>? ?? [])
          .map((e) => fromJsonT(e as Map<String, dynamic>))
          .toList(),
      lastPage: json['last_page'] ?? 1,
      perPage: json['per_page'] ?? 0,
      total: json['total'] ?? 0,
      hasMore: json['next_page_url'] != null,
    );
  }

  Map<String, dynamic> toJson(
    Map<String, dynamic> Function(T value) toJsonT,
  ) {
    return {
      'current_page': currentPage,
      'data': data.map(toJsonT).toList(),
      'last_page': lastPage,
      'per_page': perPage,
      'total': total,
      'hasMore': hasMore,
    };
  }
}

extension PaginationExtension<T> on Pagination<T> {
  bool get isEmpty => data.isEmpty;
  bool get isNotEmpty => data.isNotEmpty;
  int get length => data.length;
}
