
import 'package:flutter_test/flutter_test.dart';

// Valida el contrato o esquema del JSON recibido.
bool validarContratoLogin(Map<String, dynamic> jsonResponse) {
  // 1. La propiedad success debe existir y ser booleana.
  if (!jsonResponse.containsKey('success') ||
      jsonResponse['success'] is! bool) {
    return false;
  }

  // 2. Si el login fue exitoso, ambos tokens deben ser String.
  if (jsonResponse['success'] == true) {
    if (!jsonResponse.containsKey('accessToken') ||
        jsonResponse['accessToken'] is! String ||
        !jsonResponse.containsKey('refreshToken') ||
        jsonResponse['refreshToken'] is! String) {
      return false;
    }
  } else {
    // 3. Si el login falló, el mensaje es opcional,
    // pero debe ser String si está presente.
    if (jsonResponse.containsKey('message') &&
        jsonResponse['message'] is! String) {
      return false;
    }
  }

  return true;
}

void main() {
  group(
    'Pruebas de Contrato - Respuesta de Login de la API',
    () {
      test(
        'Caso de éxito: El JSON cumple el contrato con sus tokens',
        () {
          // Respuesta simulada de un login exitoso.
          final respuestaCorrecta = {
            'success': true,
            'accessToken':
                'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...',
            'refreshToken': 'def_refresh_token_789...',
          };

          final resultado =
              validarContratoLogin(respuestaCorrecta);

          expect(
            resultado,
            isTrue,
            reason: 'El JSON tiene la estructura y los tipos correctos.',
          );
        },
      );

      test(
        'Casos fallidos: El JSON rompe el contrato',
        () {
          // Fallo 1: faltan los tokens requeridos.
          final jsonSinTokens = {
            'success': true,
          };

          expect(
            validarContratoLogin(jsonSinTokens),
            isFalse,
          );

          // Fallo 2: accessToken es un número y no un String.
          final jsonConTipoErroneo = {
            'success': true,
            'accessToken': 12345,
            'refreshToken': 'valid_refresh_token',
          };

          expect(
            validarContratoLogin(jsonConTipoErroneo),
            isFalse,
          );

          // Fallo 3: success es un String y no un booleano.
          final jsonSuccessInvalido = {
            'success': 'true',
            'accessToken': 'token',
            'refreshToken': 'token',
          };

          expect(
            validarContratoLogin(jsonSuccessInvalido),
            isFalse,
          );
        },
      );
    },
  );
}
