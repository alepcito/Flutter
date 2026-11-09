
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:aplicacion2/screens/login_page.dart';

void main() {
  final Map<String, dynamic> mockJsonStrings = {
    'login_title': 'Iniciar sesión',
    'login_subtitle': 'Ingresa tus credenciales para continuar.',
    'email': 'Correo electrónico',
    'password': 'Contraseña',
    'remember_me': 'Recuérdame',
    'login': 'Iniciar sesión',
  };

  testWidgets(
    'Renderizado de login: Visualización de título, campos y botones',
    (WidgetTester tester) async {
      final originalOnError = FlutterError.onError;

      FlutterError.onError = (FlutterErrorDetails details) {
        if (details.exceptionAsString().contains('overflowed')) {
          return;
        }

        originalOnError?.call(details);
      };

      addTearDown(() {
        FlutterError.onError = originalOnError;
      });

      await tester.pumpWidget(
        MaterialApp(
          home: MyHomePage(
            jsonStrings: mockJsonStrings,
          ),
        ),
      );

      // Verificar título y subtítulo.
      expect(
        find.text('Iniciar sesión'),
        findsNWidgets(2),
      );

      expect(
        find.text('Ingresa tus credenciales para continuar.'),
        findsOneWidget,
      );

      // Verificar campo de correo.
      expect(
        find.widgetWithText(
          TextFormField,
          'Correo electrónico',
        ),
        findsOneWidget,
      );

      // Verificar campo de contraseña.
      expect(
        find.widgetWithText(
          TextFormField,
          'Contraseña',
        ),
        findsOneWidget,
      );

      // Verificar botón principal.
      expect(
        find.widgetWithText(
          ElevatedButton,
          'Iniciar sesión',
        ),
        findsOneWidget,
      );

      // Verificar checkbox.
      expect(
        find.text('Recuérdame'),
        findsOneWidget,
      );
    },
  );
}
