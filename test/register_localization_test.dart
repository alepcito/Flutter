import 'dart:convert';

import 'package:aplicacion2/screens/register_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  for (final language in ['es', 'en']) {
    testWidgets('Registro abre con los textos reales de $language', (tester) async {
      final jsonText = await rootBundle.loadString('assets/$language.json');
      final strings = jsonDecode(jsonText) as Map<String, dynamic>;
      final fontLoader = FontLoader('FontRoboto')
        ..addFont(rootBundle.load('assets/Roboto.ttf'));
      await fontLoader.load();

      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(fontFamily: 'FontRoboto'),
          home: RegisterPage(jsonStrings: strings),
        ),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.text(strings['register'] as String), findsWidgets);
      expect(find.text(strings['adress'] as String), findsOneWidget);
    });
  }
}
