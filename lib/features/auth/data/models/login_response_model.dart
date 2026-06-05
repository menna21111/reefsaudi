class LoginResponseModel {
  final String accessToken;
  final String? refreshToken;
  final String? expiresIn;
  final String? mediaAccessToken;

  const LoginResponseModel({
    required this.accessToken,
    this.refreshToken,
    this.expiresIn,
    this.mediaAccessToken,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String?,
      expiresIn: json['expiresIn'] as String?,
      mediaAccessToken: json['mediaAccessToken'] as String?,
    );
  }
}
