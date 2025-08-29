class User {
  final String id;
  final String name;
  final String email;
  final String role;
  final double ownershipPercentage;
  final double totalInvestment;
  final String teamId;
  final String status; // 'pending', 'approved', 'rejected'

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.ownershipPercentage,
    required this.totalInvestment,
    required this.teamId,
    required this.status,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      role: json['role'],
      ownershipPercentage: json['ownershipPercentage']?.toDouble() ?? 0.0,
      totalInvestment: json['totalInvestment']?.toDouble() ?? 0.0,
      teamId: json['teamId'],
      status: json['status'] ?? 'pending',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role,
      'ownershipPercentage': ownershipPercentage,
      'totalInvestment': totalInvestment,
      'teamId': teamId,
      'status': status,
    };
  }
}
