import 'package:flutter/material.dart';
import 'package:aplicacion2/widgets/custom_widgets.dart';
// import 'package:aplicacion2/screens/graphql_test_page.dart';
// import 'package:aplicacion2/screens/websocket_test_page.dart';
// import 'package:aplicacion2/screens/sse_test_page.dart';
/// Página de bienvenida que presenta un menú con accesos directos
/// a diferentes secciones de la aplicación.
///
/// Esta página muestra un logo en la parte superior, un botón para regresar,
/// y una tarjeta central con varios botones interactivos.
///
/// Los textos e íconos están definidos mediante un mapa jsonStrings
/// para soporte multilenguaje.
class WelcomePage extends StatelessWidget {
  final Map<String, dynamic> jsonStrings;

  /// Constructor de [WelcomePage].
  ///
  /// Requiere [jsonStrings] para traducir el contenido mostrado.
  const WelcomePage({
    super.key,
    required this.jsonStrings,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 80, 39, 51),
      body: Center(
        child: Stack(
          children: <Widget>[
            /// Logo en la parte superior de la pantalla.
            logo(),

            Positioned(
              top: 100,
              left: 0,
              right: 0,
              bottom: 0,
              child: SingleChildScrollView(
                child: Center(
                  child: Stack(
                    children: [
                      Container(
                        width: 320,
                        height: 650,
                        padding: const EdgeInsets.all(20.0),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.99),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Text(
                                    jsonStrings['welcome'],
                                    style: const TextStyle(
                                      color: Color.fromARGB(
                                        255,
                                        111,
                                        38,
                                        59,
                                      ),
                                      fontSize: 25.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            // Primera fila de botones.
                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceEvenly,
                              children: [
                                customIconButton(
                                  nombreImagen:
                                      'assets/Usuario.svg',
                                  acronimo:
                                      jsonStrings['my_account'],
                                  context: context,
                                  jsonStrings: jsonStrings,
                                ),
                                customIconButton(
                                  nombreImagen:
                                      'assets/Registro.svg',
                                  acronimo:
                                      jsonStrings['register'],
                                  context: context,
                                  jsonStrings: jsonStrings,
                                ),
                              ],
                            ),

                            const SizedBox(height: 30.0),

                            // Segunda fila de botones.
                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceEvenly,
                              children: [
                                customIconButton(
                                  nombreImagen:
                                      'assets/Notificaciones.svg',
                                  acronimo:
                                      jsonStrings['products'],
                                  context: context,
                                  jsonStrings: jsonStrings,
                                ),
                                customIconButton(
                                  nombreImagen:
                                      'assets/Pantera.svg',
                                  acronimo:
                                      jsonStrings['chatbot'],
                                  context: context,
                                  jsonStrings: jsonStrings,
                                ),
                              ],
                            ),

                            const SizedBox(height: 30.0),

                            // Tercera fila de botones.
                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceEvenly,
                              children: [
                                customIconButton(
                                  nombreImagen:
                                      'assets/Privacidad.svg',
                                  acronimo:
                                      jsonStrings['privacy'],
                                  context: context,
                                  jsonStrings: jsonStrings,
                                ),
                                customIconButton(
                                  nombreImagen:
                                      'assets/Cerrar.svg',
                                  acronimo:
                                      jsonStrings['logout'],
                                  context: context,
                                  jsonStrings: jsonStrings,
                                ),
                              ],
                            ),
                            
                            /* Botón de prueba SSE oculto para integrar la
                               tecnología en una pantalla funcional.
                            const SizedBox(height: 12.0),

                            ElevatedButton.icon(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const SseTestPage(),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.notifications_active),
                              label: const Text('Probar SSE'),
                            ),
                            */
                            /*
                              //Boton prueba de GraphQL
                            const SizedBox(height: 20.0),
                            ElevatedButton.icon(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const GraphQLTestPage(),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.cloud_outlined),
                              label: const Text('Probar GraphQL'),
                            ),
                            //Botón de prueba para WS
                            const SizedBox(height: 12.0),

                            ElevatedButton.icon(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const WebSocketTestPage(),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.message),
                              label: const Text('Probar WebSocket'),
                            ),*/
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
