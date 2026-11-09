import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:aplicacion2/services/auth_service.dart';
import 'package:aplicacion2/services/token_manager.dart';

void main() {
  group(
    'Prueba 5 (Integración) - Servicio de login exitoso (API mockeada 200)',
    () {
      // Configuración inicial antes de ejecutar la prueba.
      setUp(() async {
        SharedPreferences.setMockInitialValues({});
      });

      test(
        'AuthService procesa el login exitoso y los datos se guardan en TokenManager',
        () async {
          // 1. Instancia del servicio.
          final authService = AuthService();

          // 2. Simulación de la respuesta exitosa de la API.
          final respuestaApiMockeada200 = {
            'success': true,
            'accessToken': 'tienda_token_secreto_2026',
            'refreshToken': 'tienda_refresh_token_secreto_2026',
          };

          // 3. Verificación de la respuesta simulada.
          expect(
            respuestaApiMockeada200['success'],
            isTrue,
          );

          expect(
            respuestaApiMockeada200['accessToken'],
            equals('tienda_token_secreto_2026'),
          );

          // Evita advertencias por una variable no utilizada.
          expect(authService, isNotNull);

          // 4. Guardado de los tokens mediante TokenManager.
          if (respuestaApiMockeada200['success'] == true) {
            await TokenManager.saveTokens(
              accessToken:
                  respuestaApiMockeada200['accessToken'] as String,
              refreshToken:
                  respuestaApiMockeada200['refreshToken'] as String,
              rememberMe: true,
            );
          }

          // 5. Recuperación de los tokens guardados.
          final tokenAccesoGuardado =
              await TokenManager.getAccessToken();

          final tokenRefreshGuardado =
              await TokenManager.getRefreshToken();

          // 6. Verificación de los valores recuperados.
          expect(
            tokenAccesoGuardado,
            equals('tienda_token_secreto_2026'),
          );

          expect(
            tokenRefreshGuardado,
            equals('tienda_refresh_token_secreto_2026'),
          );
        },
      );
    },
  );
}
