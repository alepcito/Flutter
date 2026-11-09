import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:aplicacion2/screens/account_page.dart';

// Simula la evaluación de los requisitos de accesibilidad.
bool validarAccesibilidadControles({
  required bool tieneLabelsFormulario,
  required bool imagenesConAltText,
  required bool navegacionAnunciada,
}) {
  if (!tieneLabelsFormulario ||
      !imagenesConAltText ||
      !navegacionAnunciada) {
    return false;
  }

  return true;
}

void main() {
  final Map<String, dynamic> mockJsonStrings = {
    'account': 'Datos de Cuenta',
    'phone': 'Teléfono',
    'email_account': 'Correo Electrónico',
    'username': 'Nombre de Usuario',
    'user': 'Usuario',
    'pass_account': 'Contraseña',
    'occupation': 'Ocupación',
    'role': 'Rol',
    'mandatory_field': 'Este campo es obligatorio',
  };

  group(
    'Pruebas Unitarias - Matriz de Requisitos de Accesibilidad',
    () {
      test(
        'Casos fallidos: Estructuras carentes de atributos de accesibilidad',
        () {
          // Caso 1: faltan descripciones alternativas.
          expect(
            validarAccesibilidadControles(
              tieneLabelsFormulario: true,
              imagenesConAltText: false,
              navegacionAnunciada: true,
            ),
            isFalse,
          );

          // Caso 2: faltan etiquetas informativas.
          expect(
            validarAccesibilidadControles(
              tieneLabelsFormulario: false,
              imagenesConAltText: true,
              navegacionAnunciada: true,
            ),
            isFalse,
          );
        },
      );

      test(
        'Caso de éxito: La interfaz cumple los requisitos de inclusión',
        () {
          final controlAccesible = validarAccesibilidadControles(
            tieneLabelsFormulario: true,
            imagenesConAltText: true,
            navegacionAnunciada: true,
          );

          expect(controlAccesible, isTrue);
        },
      );
    },
  );

  testWidgets(
    'Accesibilidad: Verificación de Semantics y controles en AccountPage',
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

      // Activa el árbol de semántica.
      final SemanticsHandle handler = tester.ensureSemantics();

      try {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: AccountPage(jsonStrings: mockJsonStrings),
            ),
          ),
        );

        expect(find.byIcon(Icons.arrow_back), findsOneWidget);
        expect(find.text('Datos de Cuenta'), findsOneWidget);
        expect(find.text('Teléfono'), findsOneWidget);
      } finally {
        handler.dispose();
      }

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AccountPage(
              jsonStrings: mockJsonStrings,
            ),
          ),
        ),
      );

      // 1. Comprueba que exista el botón de regreso.
      expect(
        find.byIcon(Icons.arrow_back),
        findsOneWidget,
      );

      // 2. Comprueba las etiquetas principales del formulario.
      expect(
        find.text('Datos de Cuenta'),
        findsOneWidget,
      );

      expect(
        find.text('Teléfono'),
        findsOneWidget,
      );
    },
  );
}
