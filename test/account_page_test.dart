
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:aplicacion2/screens/account_page.dart';
import 'package:aplicacion2/models/userdata.dart';

// Función de validación de negocio para la prueba.
bool validarFormularioCuenta(Map<String, String> campos) {
  if (campos['phone'] == null || campos['phone']!.trim().isEmpty) {
    return false;
  }

  if (campos['email'] == null || campos['email']!.trim().isEmpty) {
    return false;
  }

  if (campos['username'] == null ||
      campos['username']!.trim().isEmpty) {
    return false;
  }

  if (campos['password'] == null ||
      campos['password']!.isEmpty) {
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

  setUp(() {
    UserData.clear();
  });

  group(
    'Pruebas unitarias - Validación de campos obligatorios',
    () {
      test(
        'Retorna false si faltan campos obligatorios',
        () {
          final camposIncompletos = <String, String>{
            'phone': '',
            'email': 'eli@example.com',
            'username': '',
            'password': '123',
          };

          expect(
            validarFormularioCuenta(camposIncompletos),
            isFalse,
          );
        },
      );

      test(
        'Retorna true si todos los campos están rellenados',
        () {
          final camposCompletos = <String, String>{
            'phone': '12345678',
            'email': 'eli@example.com',
            'username': 'elidev',
            'password': '123',
          };

          expect(
            validarFormularioCuenta(camposCompletos),
            isTrue,
          );
        },
      );

      test('Retorna false si falta el teléfono', () {
        expect(
          validarFormularioCuenta({
            'phone': '',
            'email': 'eli@example.com',
            'username': 'elidev',
            'password': '123',
          }),
          isFalse,
        );
      });

      test('Retorna false si falta el correo', () {
        expect(
          validarFormularioCuenta({
            'phone': '12345678',
            'email': '',
            'username': 'elidev',
            'password': '123',
          }),
          isFalse,
        );
      });

      test('Retorna false si falta el usuario', () {
        expect(
          validarFormularioCuenta({
            'phone': '12345678',
            'email': 'eli@example.com',
            'username': '',
            'password': '123',
          }),
          isFalse,
        );
      });

      test('Retorna false si falta la contraseña', () {
        expect(
          validarFormularioCuenta({
            'phone': '12345678',
            'email': 'eli@example.com',
            'username': 'elidev',
            'password': '',
          }),
          isFalse,
        );
      });
    },
  );

  testWidgets(
    'Verificación de alertas visuales en el formulario',
    (WidgetTester tester) async {
      final originalOnError = FlutterError.onError;

      FlutterError.onError = (FlutterErrorDetails details) {
        if (details.exception.toString().contains('overflowed')) {
          return;
        }

        if (originalOnError != null) {
          originalOnError(details);
        } else {
          FlutterError.presentError(details);
        }
      };

      addTearDown(() {
        FlutterError.onError = originalOnError;
      });

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AccountPage(
              jsonStrings: mockJsonStrings,
            ),
          ),
        ),
      );

      final botonValidar = find.byIcon(Icons.arrow_back);

      expect(
        botonValidar,
        findsOneWidget,
        reason: 'AccountPage debe mostrar el botón con icono arrow_back.',
      );

      await tester.tap(botonValidar);
      await tester.pumpAndSettle();

      expect(
        find.text('Este campo es obligatorio'),
        findsAtLeastNWidgets(1),
      );
    },
  );
}
