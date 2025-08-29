class Contract {
  final String id;
  final String name;
  final String type; // 'player' or 'staff'
  final String position;
  final double salary;
  final DateTime startDate;
  final DateTime endDate;
  final String status; // 'active', 'expired', 'pending'
  final String? documentUrl;

  Contract({
    required this.id,
    required this.name,
    required this.type,
    required this.position,
    required this.salary,
    required this.startDate,
    required this.endDate,
    required this.status,
    this.documentUrl,
  });

  factory Contract.fromJson(Map<String, dynamic> json) {
    return Contract(
      id: json['id'],
      name: json['name'],
      type: json['type'],
      position: json['position'],
      salary: json['salary'].toDouble(),
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      status: json['status'],
      documentUrl: json['documentUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'position': position,
      'salary': salary,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'status': status,
      'documentUrl': documentUrl,
    };
  }
}
