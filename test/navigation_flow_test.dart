import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:aplicacion2/screens/register_page.dart';
import 'package:aplicacion2/screens/welcome_page.dart';

void main() {
  setUpAll(() async {
    SharedPreferences.setMockInitialValues({
      'access_token': 'fake-token-123',
      'refresh_token': 'fake-refresh-456',
      'remember_me': true,
    });
  });

  final Map<String, dynamic> jsonStrings = {
    // WelcomePage
    'welcome': 'Bienvenido',
    'register': 'Registro',
    'my_account': 'Mi cuenta',
    'products': 'Productos',
    'chatbot': 'Chatbot',
    'privacy': 'Privacidad',
    'logout': 'Cerrar sesión',

    // RegisterPage
    'personal': 'Datos Personales',
    'account': 'Datos de Cuenta',
    'address': 'Dirección',
    'adress': 'Dirección',
    'photo': 'Fotografía',
    'name_register': 'Nombre de la Pantera',
    'register_button': 'Registrar',

    // PersonalPage
    'name': 'Nombre',
    'last_name': 'Apellido Paterno',
    'second_last_name': 'Apellido Materno',
    'birth_date': 'Fecha de Nacimiento',
    'gender': 'Género',
    'nationality': 'Nacionalidad',

    // AccountPage
    'phone': 'Teléfono',
    'email_account': 'Correo Electrónico',
    'username': 'Nombre de Usuario',
    'user': 'Usuario',
    'pass_account': 'Contraseña',
    'occupation': 'Ocupación',
    'role': 'Rol',

    // AddressPage
    'zip_code': 'Código Postal',
    'state': 'Estado',
    'city': 'Ciudad',
    'neighborhood': 'Colonia',
    'street': 'Calle',
    'ext_number': 'Número Exterior',
    'int_number': 'Número Interior',
    'reference': 'Referencia',

    // PhotoPage
    'take_picture': 'Toma tu foto',
    'indication1': 'Indicación 1',
    'indication2': 'Indicación 2',
    'indication3': 'Indicación 3',
    'indication4': 'Indicación 4',
    'indication5': 'Indicación 5',
    'continue': 'Continuar',

    // General
    'mandatory_field': 'Este campo es obligatorio',
    'error': 'Error',
    'accept': 'Aceptar',
    'success': 'Éxito',
  };

  testWidgets(
    'Navegación entre pantallas: flujo completo',
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

      // 1. Iniciar en WelcomePage.
      await tester.pumpWidget(
        MaterialApp(
          home: WelcomePage(jsonStrings: jsonStrings),
        ),
      );

    await tester.pumpAndSettle();

    // 1. Verificar WelcomePage.
    expect(find.text('Bienvenido'), findsOneWidget);

    // 2. Navegar a RegisterPage.
    await _tapOnText(tester, 'Registro');
    expect(find.text('Registro'), findsOneWidget);

    // 3. Navegar a PersonalPage.
    await _tapOnIcon(tester, 0);
    expect(find.text('Datos Personales'), findsOneWidget);

    // Regresar a RegisterPage.
    await _tapOnBack(tester);
    expect(find.text('Registro'), findsOneWidget);

    // 4. Navegar a AccountPage.
    await _tapOnIcon(tester, 1);
    expect(find.text('Datos de Cuenta'), findsOneWidget);

    // Regresar a RegisterPage.
    await _tapOnBack(tester);
    expect(find.text('Registro'), findsOneWidget);

    // 5. Navegar a AddressPage.
    await _tapOnIcon(tester, 2);
    expect(find.text('Dirección'), findsOneWidget);

    // Regresar a RegisterPage.
    await _tapOnBack(tester);
    expect(find.text('Registro'), findsOneWidget);

    // 6. Navegar a PhotoPage.
    await _tapOnIcon(tester, 3);
    expect(find.text('Fotografía'), findsOneWidget);

    // Regresar a RegisterPage.
    await _tapOnBack(tester);
    expect(find.text('Registro'), findsOneWidget);

    // 7. Regresar a WelcomePage.
    await _tapOnBack(tester);
    expect(find.text('Bienvenido'), findsOneWidget);

    // 8. Navegar a AccountPage desde WelcomePage.
    await _tapOnText(tester, 'Mi cuenta');
    expect(find.text('Datos de Cuenta'), findsOneWidget);

    // Regresar a WelcomePage.
    await _tapOnBack(tester);
    expect(find.text('Bienvenido'), findsOneWidget);

    },
  );
}

// Toca un texto visible y espera a que termine la transición.
Future<void> _tapOnText(
  WidgetTester tester,
  String text,
) async {
  final finder = find.text(text);

  expect(
    finder,
    findsOneWidget,
    reason: 'No se encontró el texto "$text".',
  );

  await tester.tap(finder);
  await tester.pumpAndSettle();
}
// Busca un SVG por su recurso y toca el InkWell que lo contiene.

Future<void> _tapOnIcon(
  WidgetTester tester,
  int sectionIndex,
) async {
  const assetPaths = [
    'assets/Usuario.svg',
    'assets/Correo.svg',
    'assets/add.svg',
    'assets/Fotografia.svg',
  ];

  if (sectionIndex < 0 || sectionIndex >= assetPaths.length) {
    throw RangeError.index(sectionIndex, assetPaths);
  }

  final assetPath = assetPaths[sectionIndex];

  final svgFinder = find.byWidgetPredicate(
    (widget) {
      if (widget is! SvgPicture) return false;

      return widget.bytesLoader.toString().contains(assetPath);
    },
    description: 'SVG correspondiente a $assetPath',
  );

  expect(
    svgFinder,
    findsOneWidget,
    reason: 'No se encontró el icono $assetPath.',
  );

  final inkWellFinder = find.ancestor(
    of: svgFinder,
    matching: find.byType(InkWell),
  );

  expect(
    inkWellFinder,
    findsOneWidget,
    reason: 'No se encontró el InkWell de $assetPath.',
  );

  await tester.ensureVisible(svgFinder);
  await tester.pumpAndSettle();

  await tester.tap(inkWellFinder);
  await tester.pumpAndSettle();
}



// Toca el botón de retroceso de la pantalla actual.
Future<void> _tapOnBack(WidgetTester tester) async {
  final backFinder = find.byIcon(Icons.arrow_back);

  expect(
    backFinder,
    findsOneWidget,
    reason: 'No se encontró el botón de retroceso.',
  );

  await tester.tap(backFinder);
  await tester.pumpAndSettle();
}