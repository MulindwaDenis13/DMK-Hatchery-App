class Customer {
  final int id;
  final String name;
  final String phone;
  final String email;
  final String location;
  final String? imageUrl;
  final String? bio;
  final String joinDate;

  Customer({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    required this.location,
    required this.joinDate,
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
  final int spoiledCount;
  final bool isComplete;
  final bool isEarly;
  final int? daysRemaining;

  HatchingActivity({
    required this.id,
    required this.recordedAt,
    required this.hatchedCount,
    required this.spoiledCount,
    this.isComplete = false,
    this.isEarly = false,
    this.daysRemaining,
  });

  factory HatchingActivity.fromJson(Map<String, dynamic> json) {
    return HatchingActivity(
      id: json['id'],
      recordedAt: DateTime.parse(json['recorded_at']),
      hatchedCount: json['hatched_count'],
      spoiledCount: json['spoiled_count'],
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
      'spoiledCount': spoiledCount,
      'isComplete': isComplete,
      'isEarly': isEarly,
      'daysRemaining': daysRemaining,
    };
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
  final int spoiledCount;
  final double progressPercentage;
  final String? notes;
  final List<HatchingActivity> hatchingActivities;
  final Invoice? invoice;

  Batch({
    required this.id,
    required this.mark,
    required this.incubator,
    required this.startDate,
    required this.expectedEndDate,
    required this.status,
    required this.eggCount,
    required this.hatchedCount,
    required this.spoiledCount,
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
      spoiledCount: json['spoiled_count'],
      progressPercentage: (json['progress_percentage'] as num).toDouble(),
      notes: json['notes'],
      invoice:
          json['invoice'] != null ? Invoice.fromJson(json['invoice']) : null,
      hatchingActivities: (json['hatching_activities'] as List? ?? [])
          .map((e) => HatchingActivity.fromJson(e))
          .toList(),
    );
  }
}

class Invoice {
  final int id;
  final String invoiceNumber;
  final Batch batch;
  final Customer customer;
  final int hatchedEggs;
  final int spoiledEggs;
  final double costPerHatched;
  final double totalAmount;
  final double balance;
  final DateTime date;
  final String status;

  Invoice({
    required this.id,
    required this.invoiceNumber,
    required this.batch,
    required this.customer,
    required this.hatchedEggs,
    required this.spoiledEggs,
    required this.costPerHatched,
    required this.totalAmount,
    required this.date,
    required this.status,
    required this.balance,
  });

  factory Invoice.fromJson(Map<String, dynamic> json) {
    return Invoice(
      id: json['id'],
      invoiceNumber: json['invoice_number'],
      batch: Batch.fromJson(json['batch']),
      customer: Customer.fromJson(json['customer']),
      hatchedEggs: json['hatched_eggs'],
      spoiledEggs: json['spoiled_eggs'],
      costPerHatched: (json['cost_per_hatched'] as num).toDouble(),
      totalAmount: (json['total_amount'] as num).toDouble(),
      date: DateTime.parse(json['date']),
      status: json['status'],
      balance: (json['balance'] as num).toDouble(),
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
  final List<DashboardBatch> recent_batches;

  Dashboard({
    required this.total_batches,
    required this.active_batches,
    required this.completed_batches,
    required this.total_paid_invoices,
    required this.total_paid_amount,
    required this.total_unpaid_invoices,
    required this.total_amount_due,
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
