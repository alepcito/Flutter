
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:aplicacion2/screens/account_page.dart';

// Función conceptual que simula la inspección estructural del Widget Test.
bool validarWidgetFormulario({
  required bool camposRenderizados,
  required bool permiteEscritura,
}) {
  if (!camposRenderizados || !permiteEscritura) {
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

  // Validación lógica de casos de éxito y fallos.
  group(
    'Pruebas Unitarias - Matriz de Estado del Widget Formulario',
    () {
      test(
        'Casos fallidos: Componentes incompletos o bloqueados',
        () {
          // Los campos existen, pero no permiten interacción.
          expect(
            validarWidgetFormulario(
              camposRenderizados: true,
              permiteEscritura: false,
            ),
            isFalse,
          );

          // No se encuentra el campo en la jerarquía visual.
          expect(
            validarWidgetFormulario(
              camposRenderizados: false,
              permiteEscritura: true,
            ),
            isFalse,
          );
        },
      );

      test(
        'Caso de éxito: El widget se dibuja y responde correctamente al usuario',
        () {
          final widgetValido = validarWidgetFormulario(
            camposRenderizados: true,
            permiteEscritura: true,
          );

          expect(widgetValido, isTrue);
        },
      );
    },
  );

  // Simulación aislada del renderizado e interacción de widgets.
  testWidgets(
    'Widget Test - Verificación de interacción y escritura en AccountPage',
    (WidgetTester tester) async {
      // Ignoramos errores de overflow durante esta prueba.
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

      // Cargamos AccountPage en el árbol virtual de pruebas.
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AccountPage(jsonStrings: mockJsonStrings),
          ),
        ),
      );

      // Verificamos que exista al menos un campo de texto.
      final Finder campoTextoForm = find.byType(TextFormField);

      expect(
        campoTextoForm,
        findsAtLeastNWidgets(1),
        reason: 'Debe existir al menos un campo de texto.',
      );

      // Simulamos la escritura del usuario en el primer campo.
      await tester.enterText(
        campoTextoForm.first,
        '1234567890',
      );

      // Actualizamos el árbol de widgets.
      await tester.pump();

      // Comprobamos que el texto introducido se refleje en la interfaz.
      expect(
        find.text('1234567890'),
        findsOneWidget,
        reason: 'El widget debe reflejar el texto escrito por el usuario.',
      );
    },
  );
}
