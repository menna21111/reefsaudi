class AccountModel {
  final String id;
  final String userName;
  final String email;
  final String? fullName;
  final List<String> roles;

  const AccountModel({
    required this.id,
    required this.userName,
    required this.email,
    this.fullName,
    this.roles = const [],
  });

  factory AccountModel.fromJson(Map<String, dynamic> json) {
    return AccountModel(
      id: json['id'] as String,
      userName: json['userName'] as String? ?? '',
      email: json['email'] as String? ?? '',
      fullName: json['fullName'] as String?,
      roles: (json['roles'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
    );
  }
}
