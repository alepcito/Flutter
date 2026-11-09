import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:aplicacion2/services/token_manager.dart';
import 'package:aplicacion2/models/userdata.dart';
import 'package:aplicacion2/screens/register_page.dart';
import 'package:aplicacion2/screens/account_page.dart';

/// Logo fijo y posicionado en la parte superior,
/// centrado horizontalmente.
Widget logo() {
  return Positioned(
    top: 0,
    left: 0,
    right: 0,
    child: SvgPicture.asset(
      'assets/logo.svg',
      height: 130.0,
      width: 130.0,
      colorFilter: const ColorFilter.mode(
        Colors.white,
        BlendMode.srcIn,
      ),
    ),
  );
}

/// Botón personalizado con ícono SVG y texto.
///
/// [nombreImagen] es la ruta del ícono SVG.
/// [acronimo] es el texto mostrado debajo del ícono.
/// [context] es el contexto de la aplicación.
/// [jsonStrings] contiene las traducciones utilizadas
/// para la navegación.
Widget customIconButton({
  required String nombreImagen,
  required String acronimo,
  required BuildContext context,
  required Map<String, dynamic> jsonStrings,
}) {
  return InkWell(
    child: SizedBox(
      width: 130,
      height: 130,
      child: Card(
        margin: const EdgeInsets.all(10.0),
        elevation: 9.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              nombreImagen,
              width: 45,
              height: 45,
              colorFilter: const ColorFilter.mode(
                Color.fromARGB(255, 111, 38, 59),
                BlendMode.srcIn,
              ),
            ),
            Text(
              acronimo,
              style: const TextStyle(
                color: Color.fromARGB(255, 111, 38, 59),
                fontSize: 15.0,
              ),
            ),
          ],
        ),
      ),
    ),

    // Acción al presionar el botón.
    onTap: () async {
      print('Click en $acronimo');

      // Navegación hacia Registro.
      if (acronimo == 'Registro' || acronimo == 'Register') {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RegisterPage(
              jsonStrings: jsonStrings,
            ),
          ),
        );
      }

      // Navegación hacia Mi Cuenta.
      else if (acronimo == jsonStrings['my_account']) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AccountPage(
              jsonStrings: jsonStrings,
            ),
          ),
        );
      }
      // 3. LÓGICA DE CERRAR SESIÓN
      else if (acronimo == jsonStrings['logout'] ||
              acronimo == 'Cerrar sesión') {

        // Borrar los tokens guardados en SharedPreferences.
        await TokenManager.clearTokens();

        // Limpiar los datos de la sesión actual.
        UserData.clear();

        // Regresar al login y eliminar las pantallas anteriores.
        if (!context.mounted) return;

        Navigator.pushNamedAndRemoveUntil(
          context,
          '/login',
          (route) => false,
        );
      }
    },
  );
}

/// Campo de texto reutilizable con validación de error
/// y soporte multilenguaje.
Widget buildField(
  TextEditingController controller,
  String label,
  bool hasError,
  Map<String, dynamic> jsonStrings,
) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      TextFormField(
        controller: controller,
        style: const TextStyle(fontSize: 14),
        decoration: InputDecoration(
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 12.0,
            horizontal: 12.0,
          ),
          border: const OutlineInputBorder(),
          labelText: label,
          labelStyle: const TextStyle(fontSize: 14),
        ),
      ),
      if (hasError)
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            jsonStrings['mandatory_field'],
            style: const TextStyle(
              color: Color.fromARGB(255, 80, 39, 51),
              fontSize: 12,
            ),
          ),
        ),
      const SizedBox(height: 14.0),
    ],
  );
}

/// Widget auxiliar para mostrar un elemento de lista
/// con una viñeta (bullet).
Widget bulletItem(String text) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 0.0),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '• ',
          style: TextStyle(
            fontSize: 18.0,
            color: Color.fromARGB(255, 111, 38, 59),
          ),
        ),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              color: Color.fromARGB(255, 111, 38, 59),
              fontSize: 14.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    ),
  );
}