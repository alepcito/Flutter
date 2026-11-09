
import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:aplicacion2/models/userdata.dart';

// Simula la lógica de integración y envío del JSON.
Map<String, dynamic> validarEnvioRegistro(
  Map<String, dynamic> jsonPayload,
  bool mockServerSuccess,
) {
  // Verifica que existan los campos mínimos requeridos.
  if (!jsonPayload.containsKey('phone') ||
      !jsonPayload.containsKey('street') ||
      !jsonPayload.containsKey('photoConfirmed')) {
    return {
      'success': false,
      'message': 'JSON incompleto: Faltan módulos del formulario',
    };
  }

  // Simula una respuesta exitosa o un error del servidor.
  if (mockServerSuccess) {
    return {
      'success': true,
      'accessToken': 'mock_access_token_integration_2026',
      'refreshToken': 'mock_refresh_token_integration_2026',
    };
  } else {
    return {
      'success': false,
      'message': 'Error de conexión del servidor (500)',
    };
  }
}

void main() {
  setUp(() {
    UserData.clear();
  });

  group(
    'Pruebas de Integración - Registro de Usuario y Envío de JSON',
    () {
      test(
        'Casos fallidos: Payload incompleto o rechazo de la API',
        () {
          // Caso 1: JSON incompleto.
          final jsonIncompleto = {
            'phone': '12345678',
          };

          final resultadoIncompleto =
              validarEnvioRegistro(jsonIncompleto, true);

          expect(resultadoIncompleto['success'], isFalse);

          // Caso 2: JSON completo, pero el servidor falla.
          final jsonEstructurado = {
            'phone': '123',
            'street': 'Av. Principal',
            'photoConfirmed': true,
          };

          final resultadoServidorCaido =
              validarEnvioRegistro(jsonEstructurado, false);

          expect(resultadoServidorCaido['success'], isFalse);
        },
      );

      test(
        'Caso de éxito: Construcción y envío correcto de todos los módulos en el JSON',
        () {
          // 1. Datos de AccountPage.
          UserData.phone = '5551234567';
          UserData.email = 'elizabeth@example.com';
          UserData.username = 'elizabeth_dev';
          UserData.password = 'Pass123*';

          // 2. Datos de AddressPage.
          UserData.zipCode = '50000';
          UserData.street = 'Av. Tecnológico';
          UserData.city = 'Toluca';

          // 3. Datos de PhotoPage.
          UserData.photoConfirmed = true;

          // 4. Construcción del JSON integrado.
          final Map<String, dynamic> jsonPayloadReal = {
            'phone': UserData.phone,
            'email': UserData.email,
            'username': UserData.username,
            'password': UserData.password,
            'zipCode': UserData.zipCode,
            'street': UserData.street,
            'city': UserData.city,
            'photoConfirmed': UserData.photoConfirmed,
          };

          // 5. Verificación de la integración de los datos.
          expect(jsonPayloadReal['city'], equals('Toluca'));
          expect(jsonPayloadReal['photoConfirmed'], isTrue);

          // 6. Simulación del procesamiento del servidor.
          final respuestaServidor =
              validarEnvioRegistro(jsonPayloadReal, true);

          expect(respuestaServidor['success'], isTrue);
          expect(respuestaServidor['accessToken'], isNotNull);

          // 7. Verificación de la serialización JSON.
          final String jsonStringEmitido =
              jsonEncode(jsonPayloadReal);

          expect(
            jsonStringEmitido,
            contains('"photoConfirmed":true'),
          );
        },
      );
    },
  );
}
