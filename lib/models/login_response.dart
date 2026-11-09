
class LoginResponse {
  final bool success;
  final String? accessToken;
  final String? refreshToken;
  final String? message;
  final int? statusCode;

  const LoginResponse({
    required this.success,
    this.accessToken,
    this.refreshToken,
    this.message,
    this.statusCode,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      success: json['success'] == true,
      accessToken: json['accessToken'] as String?,
      refreshToken: json['refreshToken'] as String?,
      message: json['message'] as String?,
      statusCode: json['statusCode'] as int?,
    );
  }
}
