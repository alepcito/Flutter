import 'package:flutter/material.dart';
import 'register_page.dart';
import '../widgets/menu_button.dart';

/// Pantalla principal de la aplicación.
///
/// Muestra un menú con diferentes opciones representadas por botones,
/// utilizando íconos y etiquetas extraídas de un archivo JSON de idiomas.
class HomeScreen extends StatelessWidget {
  /// Mapa que contiene los textos en el idioma seleccionado.
  final Map<String, dynamic> strings;

  /// Constructor de HomeScreen.
  ///
  /// - strings: Mapa con las cadenas de texto para la localización.
  const HomeScreen({super.key, required this.strings});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Imagen de fondo de la pantalla.
          const BackgroundImage(),
          // Capa superior: Contenedor principal del menú centrado.
          Center(
            child: Container(
              // El tamaño se calcula proporcionalmente al ancho de la pantalla.
              // Establece el ancho al 80% del ancho total de la pantalla para mantener márgenes laterales.
              width: MediaQuery.of(context).size.width * 0.8,
              // Define la altura basada en una proporción del ancho (aspect ratio aproximado de 1:1.6).
              // Nota: Usar el ancho como base para la altura ayuda a mantener la forma en diferentes orientaciones.
              height: MediaQuery.of(context).size.width * 1.29,
              // Espaciado interno uniforme para que el contenido no toque los bordes del contenedor.
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                // Color de fondo oscuro con una opacidad casi sólida (99%).
                // Se usa .withOpacity para permitir ajustes finos de transparencia si fuera necesario.
                color: const Color.fromARGB(255, 43, 57, 66).withOpacity(0.99),
                // Suaviza las esquinas del contenedor con un radio de 20 píxeles lógicos.
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Título de bienvenida.
                  Text(
                    strings['welcome'],
                    style: const TextStyle(color: Colors.white, fontSize: 25.0),
                  ),
                  const SizedBox(height: 20),

                  
                  // Filas de botones de menú con diferentes funcionalidades.
                  // Primera fila del menú que agrupa las opciones de perfil y registro.
                  _buildMenuRow([
                    // Botón de acceso a la cuenta del usuario. 
                    // Utiliza el icono 'Usuario.svg' y la etiqueta localizada para 'my_account'.
                    MenuButton(iconPath: 'assets/Usuario.svg', label: strings['my_account']),
                    // Botón que gestiona la navegación hacia el formulario de registro.
                    MenuButton(
                      iconPath: 'assets/Registro.svg',
                      label: strings['register'],
                      onTap: () {
                        // Navegación imperativa hacia [RegisterScreen].
                        // Se pasa el mapa [strings] para mantener la consistencia del idioma seleccionado.
                        Navigator.push(
  context,
  MaterialPageRoute(
    builder: (_) => RegisterPage(jsonStrings: strings),
  ),
);
                      },
                    ),
                  ]),
                  
                  _buildMenuRow([
                    MenuButton(iconPath: 'assets/Notificaciones.svg', label: strings['notifications']),
                    MenuButton(iconPath: 'assets/Pantera.svg', label: strings['chatbot']),
                  ]),
                  _buildMenuRow([
                    MenuButton(iconPath: 'assets/Privacidad.svg', label: strings['privacy']),
                    // Acción para finalizar la sesión activa.
                    MenuButton(iconPath: 'assets/Cerrar.svg', label: strings['logout']),
                  ]),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Construye una fila de botones de menú.
  ///
  /// - buttons: Lista de widgets de tipo MenuButton que se mostrarán en la fila.
  Widget _buildMenuRow(List<Widget> buttons) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: buttons,
    );
  }
}

/// Widget que muestra la imagen de fondo de la pantalla principal.
class BackgroundImage extends StatelessWidget {
  /// Constructor de BackgroundImage.
  const BackgroundImage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/fondo.png"),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}