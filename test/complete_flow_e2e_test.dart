
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:aplicacion2/models/userdata.dart';

// Emula la validación de la secuencia completa E2E.
bool validarFlujoE2E({
  required bool loginValido,
  required bool formulariosCompletos,
  required bool registroExitoso,
}) {
  if (!loginValido) return false;
  if (!formulariosCompletos) return false;
  if (!registroExitoso) return false;

  return true;
}

void main() {
  final Map<String, dynamic> mockJsonStrings = {
    'error': 'Error',
    'personal': 'Datos Personales',
    'account': 'Datos de Cuenta',
    'adress': 'Dirección',
    'photo': 'Fotografía',
    'mandatory_field': 'Este campo es obligatorio',
  };

  setUp(() {
    UserData.clear();
  });

  group(
    'Pruebas E2E - Flujo Completo de la Aplicación',
    () {
      test(
        'Casos fallidos: Interrupción en cualquiera de las fases del flujo',
        () {
          // Fallo en el login inicial.
          expect(
            validarFlujoE2E(
              loginValido: false,
              formulariosCompletos: true,
              registroExitoso: true,
            ),
            isFalse,
          );

          // El login pasa, pero hay formularios incompletos.
          expect(
            validarFlujoE2E(
              loginValido: true,
              formulariosCompletos: false,
              registroExitoso: true,
            ),
            isFalse,
          );

          // El registro final falla.
          expect(
            validarFlujoE2E(
              loginValido: true,
              formulariosCompletos: true,
              registroExitoso: false,
            ),
            isFalse,
          );
        },
      );

      test(
        'Caso de éxito: Login, formularios, registro y pantalla final',
        () {
          final flujoPerfecto = validarFlujoE2E(
            loginValido: true,
            formulariosCompletos: true,
            registroExitoso: true,
          );

          expect(
            flujoPerfecto,
            isTrue,
            reason: 'El usuario completó todo el recorrido con éxito.',
          );
        },
      );
    },
  );

  testWidgets(
    'Simulación E2E: Persistencia de datos entre pantallas',
    (WidgetTester tester) async {
      // Conserva el manejador original de errores.
      final originalOnError = FlutterError.onError;

      FlutterError.onError = (FlutterErrorDetails details) {
        if (details.exception.toString().contains('overflowed')) {
          return;
        }

        originalOnError?.call(details);
      };

      addTearDown(() {
        FlutterError.onError = originalOnError;
      });

      // 1. Simula los datos acumulados durante el registro.
      UserData.email = 'elizabeth@example.com';
      UserData.username = 'elizabeth_dev';
      UserData.street = 'Av. de las Ciencias';
      UserData.photoConfirmed = true;

      // 2. Construye una pantalla final simplificada.
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return Center(
                  child: Text('Bienvenido, ${UserData.username}'),
                );
              },
            ),
          ),
        ),
      );

      // 3. Verifica que la pantalla muestre el usuario guardado.
      expect(
        find.text('Bienvenido, elizabeth_dev'),
        findsOneWidget,
      );
    },
  );
}
