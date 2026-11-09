import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Botón de menú personalizado con un icono y una etiqueta.
///
/// Este widget muestra un botón con un icono SVG y un texto debajo.
/// Se puede asignar una función onTap para manejar el evento de clic.
class MenuButton extends StatelessWidget {
  /// Ruta del icono SVG que se mostrará en el botón.
  final String iconPath;

  /// Etiqueta del botón, que se mostrará debajo del icono.
  final String label;

  /// Función opcional que se ejecuta al presionar el botón.
  final VoidCallback? onTap;

  /// Constructor de MenuButton.
  ///
  /// - iconPath: Ruta del icono SVG (obligatorio).
  /// - label: Texto que se mostrará debajo del icono (obligatorio).
  /// - onTap: Callback opcional que se ejecuta al presionar el botón.
  const MenuButton({
    super.key,
    required this.iconPath,
    required this.label,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      // Llama a la función onTap si se proporciona, de lo contrario, imprime un mensaje en la consola.
      onTap: onTap ?? () => print('Click en $label'),
      child: SizedBox(
        width: 120,
        height: 120,
        child: Card(
          elevation: 9.0, // Efecto de sombra en la tarjeta.
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Muestra el icono SVG con un tamaño fijo y un color azul.
              SvgPicture.asset(
                iconPath,
                width: 45,
                height: 45,
                color: const Color.fromARGB(255, 33, 150, 243),
              ),
              // Muestra la etiqueta del botón.
              Text(label),
            ],
          ),
        ),
      ),
    );
  }
}