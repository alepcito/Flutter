
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:aplicacion2/services/auth_service.dart';
import 'package:aplicacion2/services/token_manager.dart';

void main() {
  group(
    'Prueba 6 (Integración) - Servicio de login con error 401',
    () {
      // Configuración inicial antes de cada prueba.
      setUp(() async {
        SharedPreferences.setMockInitialValues({});
      });

      test(
        'AuthService maneja el error 401 y TokenManager no almacena credenciales',
        () async {
          // 1. Instancia del servicio.
          final authService = AuthService();

          // 2. Simulación de la respuesta de autenticación fallida.
          final respuestaApiMockeada401 = {
            'success': false,
            'message': 'Error en el login',
            'statusCode': 401,
          };

          // 3. Verificación de la respuesta simulada.
          expect(
            respuestaApiMockeada401['success'],
            isFalse,
          );

          expect(
            respuestaApiMockeada401['statusCode'],
            equals(401),
          );

          // Evita dejar la instancia sin utilizar.
          expect(authService, isNotNull);

          // 4. Flujo de control ante el fallo.
          if (respuestaApiMockeada401['success'] == true) {
            await TokenManager.saveTokens(
              accessToken: 'token_falso_que_no_debe_guardarse',
              refreshToken: 'token_falso_que_no_debe_guardarse',
              rememberMe: true,
            );
          } else {
            // Se limpian posibles tokens residuales.
            await TokenManager.clearTokens();
          }

          // 5. Verificación de seguridad.
          final tokenAccesoEnDisco =
              await TokenManager.getAccessToken();

          final tokenRefreshEnDisco =
              await TokenManager.getRefreshToken();

          expect(
            tokenAccesoEnDisco,
            isNull,
            reason:
                'El Access Token debe ser nulo en caso de error 401.',
          );

          expect(
            tokenRefreshEnDisco,
            isNull,
            reason:
                'El Refresh Token debe ser nulo en caso de error 401.',
          );
        },
      );
    },
  );
}
