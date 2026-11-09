
import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  static const String baseUrl = 'http://developer.jquiroz.net:3005';

  Future<Map<String, dynamic>> login(
    String email,
    String password,
  ) async {
    try {
      final uri = Uri.parse('$baseUrl/api/users/login');

      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      final dynamic decoded;

      try {
        decoded = jsonDecode(response.body);
      } on FormatException {
        return {
          'success': false,
          'message': 'El servidor devolvió una respuesta inválida.',
          'statusCode': response.statusCode,
        };
      }

      if (decoded is! Map<String, dynamic>) {
        return {
          'success': false,
          'message': 'El formato de respuesta del servidor es inesperado.',
          'statusCode': response.statusCode,
        };
      }

      if (response.statusCode == 200) {
        return {
          'success': true,
          'accessToken': decoded['accessToken'],
          'refreshToken': decoded['refreshToken'],
        };
      }

      return {
        'success': false,
        'message': decoded['message']?.toString() ??
            'Error en el inicio de sesión.',
        'statusCode': response.statusCode,
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Error de conexión: $e',
        'statusCode': 0,
      };
    }
  }
}
