class User {
  final int? id;
  int? rankId;  // Để null cho việc cập nhật sau
  String name;
  String username;
  String password;
  String email;
  String? phone;  // Để null cho việc cập nhật sau
  DateTime? dob;  // Để null cho việc cập nhật sau
  String? url;
  int? totalScore;

  User({
    this.id,
    this.rankId = 1,  // Để null cho việc cập nhật sau
    required this.name,
    required this.username,
    required this.password,
    required this.email,
    this.phone,  // Để null cho việc cập nhật sau
    this.dob,  // Để null cho việc cập nhật sau
    this.url,
    this.totalScore = 0,
  });

  // Chuyển đổi từ Map thành User
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      rankId: map['rank_id'],
      name: map['name'],
      username: map['username'],
      password: map['password'],
      email: map['email'],
      phone: map['phone'] ?? 'N/A',  // Có thể là null
      dob: map['dob'] != null ? DateTime.parse(map['dob']) : null,  // Chuyển từ String thành DateTime, nếu có
      url: map['url'] ?? 'https://th.bing.com/th/id/OIP.PoS7waY4-VeqgNuBSxVUogAAAA?w=415&h=415&rs=1&pid=ImgDetMain',
      totalScore: map['total_score'] ?? 0,
    );
  }

  // Chuyển đổi User thành Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'rank_id': rankId,  // Để null nếu không có giá trị
      'name': name,
      'username': username,
      'password': password,
      'email': email,
      'phone': phone,  // Để null nếu không có giá trị
      'dob': dob?.toIso8601String(),  // Chuyển từ DateTime thành String, nếu có
      'url':url,
      'total_score': totalScore,
    };
  }
}
