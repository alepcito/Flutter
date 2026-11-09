import 'package:flutter/material.dart';
import '../widgets/academic_screen.dart';

class PrivacyPage extends StatelessWidget {
  const PrivacyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AcademicScreen(
      title: 'Aviso de privacidad',
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(24, 0, 24, 24),
        child: Text(
          'Proyecto académico\n\n'
          'Esta aplicación se utiliza con fines educativos para demostrar '
          'autenticación, formularios y comunicación con servidores.\n\n'
          'Datos utilizados\n\n'
          'Los formularios permiten introducir datos personales, de cuenta y '
          'domicilio. El inicio de sesión envía las credenciales al servidor '
          'configurado y guarda los tokens de sesión en el dispositivo. '
          'Los mensajes del chat se envían al servidor configurado.\n\n'
          'Uso de la información\n\n'
          'Para las prácticas se recomienda utilizar datos ficticios y '
          'contraseñas exclusivas para este proyecto. La conservación de '
          'información enviada depende del servidor utilizado.\n\n'
          'Control de la sesión\n\n'
          'Al cerrar sesión se eliminan los tokens guardados por la aplicación '
          'y se limpian los datos temporales del formulario. Esto no elimina '
          'información que ya se haya enviado al servidor.\n\n'
          'Este aviso describe el uso académico de la aplicación y deberá '
          'actualizarse si cambian sus funciones o el tratamiento de datos.',
          style: TextStyle(fontSize: 16, height: 1.5, color: Colors.black87),
        ),
      ),
    );
  }
}
