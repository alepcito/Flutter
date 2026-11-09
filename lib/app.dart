import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_localizations/flutter_localizations.dart';

// Pantallas
import 'screens/login_page.dart';
import 'screens/welcome_page.dart';
import 'screens/register_page.dart';
import 'screens/account_page.dart';
import 'screens/personal_page.dart';
import 'screens/address_page.dart';
import 'screens/photo_page.dart';

/// Clase principal de la aplicación.
/// Se encarga de inicializar la app y definir el tema principal.
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

/// Estado de la clase MyApp.
///
/// Gestiona la carga de los textos desde un archivo JSON.
class _MyAppState extends State<MyApp> {
  Map<String, dynamic>? _jsonStrings;

  @override
  void initState() {
    super.initState();
    loadJson();
  }

  /// Carga el archivo JSON desde la carpeta de assets.
  Future<void> loadJson() async {
    final String jsonString =
        await rootBundle.loadString('assets/es.json');

    setState(() {
      _jsonStrings = jsonDecode(jsonString);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_jsonStrings == null) {
      return const MaterialApp(
        home: Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }

    return MaterialApp(
      locale: const Locale('es', 'ES'),
      supportedLocales: const [
        Locale('en', 'US'),
        Locale('es', 'ES'),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      title: _jsonStrings!['app_title'],
      theme: ThemeData(
        fontFamily: 'FontRoboto',
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 60, 196, 255),
        ),
        useMaterial3: true,
      ),
      home: MyHomePage(jsonStrings: _jsonStrings!),

      // Definición del mapa de navegación (Routes).
      routes: {
        '/login': (context) => MyHomePage(
              jsonStrings: _jsonStrings!,
            ),
      },
    );
  }
}