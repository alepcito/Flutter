import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group(
    'Prueba 4 (Componentes) - Estado de error visible tras un 401',
    () {
      testWidgets(
        'Cuando la API responde 401, se muestra "Credenciales incorrectas" y el formulario se habilita',
        (WidgetTester tester) async {
          // 1. PREPARACIÓN DEL ENTORNO (Arrange)
          bool isLoading = false;
          String? errorMessage;

          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: StatefulBuilder(
                  builder: (
                    BuildContext context,
                    StateSetter setState,
                  ) {
                    return Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          // Campo de texto simulado.
                          TextField(
                            key: const Key('email_field'),
                            enabled: !isLoading,
                            decoration: const InputDecoration(
                              labelText: 'Correo',
                            ),
                          ),

                          // Mensaje de error dinámico.
                          if (errorMessage != null)
                            Text(
                              errorMessage!,
                              style: const TextStyle(
                                color: Colors.red,
                              ),
                            ),

                          // Botón de acceso.
                          ElevatedButton(
                            onPressed: isLoading
                                ? null
                                : () async {
                                    // Simulación del inicio de sesión.
                                    setState(() {
                                      isLoading = true;
                                      errorMessage = null;
                                    });

                                    // Simula la espera de la API.
                                    await Future.delayed(
                                      Duration.zero,
                                    );

                                    // Simula la respuesta HTTP 401.
                                    setState(() {
                                      isLoading = false;
                                      errorMessage =
                                          'Credenciales incorrectas';
                                    });
                                  },
                            child: isLoading
                                ? const CircularProgressIndicator()
                                : const Text('Acceso'),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          );

          // 2. COMPROBACIÓN INICIAL (Assert)
          expect(
            find.text('Credenciales incorrectas'),
            findsNothing,
          );

          final TextField campoInicial =
              tester.widget<TextField>(
            find.byKey(const Key('email_field')),
          );

          expect(campoInicial.enabled, isTrue);

          // 3. ACCIÓN (Act)
          await tester.tap(find.text('Acceso'));
          await tester.pumpAndSettle();

          // 4. VERIFICACIONES FINALES (Assert)

          // El mensaje de error debe aparecer.
          expect(
            find.text('Credenciales incorrectas'),
            findsOneWidget,
          );

          // El campo debe volver a estar habilitado.
          final TextField campoFinal =
              tester.widget<TextField>(
            find.byKey(const Key('email_field')),
          );

          expect(campoFinal.enabled, isTrue);

          // El botón debe estar activo.
          final ElevatedButton botonFinal =
              tester.widget<ElevatedButton>(
            find.byType(ElevatedButton),
          );

          expect(botonFinal.onPressed, isNotNull);
        },
      );
    },
  );
}
