
import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

// Función de validación local de las credenciales.
bool validarFormularioLogin(String? email, String? password) {
  if (email == null || email.trim().isEmpty) return false;
  if (password == null || password.isEmpty) return false;

  final emailRegex = RegExp(
    r'^[\w.-]+@([\w-]+\.)+[\w-]{2,4}$',
  );

  return emailRegex.hasMatch(email.trim());
}

void main() {
  group('Prueba 1 (Unitaria) - Validación de credenciales', () {
    test('Retorna true con email y contraseña correctos', () {
      final resultado = validarFormularioLogin(
        'jose@gmail.com',
        '123456789',
      );

      expect(resultado, isTrue);
    });

    test('Retorna false cuando la contraseña está vacía', () {
      final resultado = validarFormularioLogin(
        'jose@gmail.com',
        '',
      );

      expect(resultado, isFalse);
    });

    test('Retorna false cuando el email está vacío', () {
      final resultado = validarFormularioLogin(
        '',
        '123456789',
      );

      expect(resultado, isFalse);
    });

    test('Retorna false cuando el formato del email es inválido', () {
      final resultado = validarFormularioLogin(
        'jose_sin_arroba.com',
        '123456789',
      );

      expect(resultado, isFalse);
    });

    test('Simulación de servidor (Mock HTTP 200)', () async {
      final clienteFalso = MockClient((request) async {
        return http.Response(
          jsonEncode({
            'accessToken': 'token123',
            'refreshToken': 'refresh123',
          }),
          200,
          headers: {
            'content-type': 'application/json',
          },
        );
      });

      final respuesta = await clienteFalso.post(
        Uri.parse('http://example.com/api'),
      );

      expect(respuesta.statusCode, 200);

      final data = jsonDecode(respuesta.body);
      expect(data['accessToken'], 'token123');
      expect(data['refreshToken'], 'refresh123');

      clienteFalso.close();
    });
  });
}
