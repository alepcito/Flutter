import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:aplicacion2/widgets/custom_widgets.dart';
import 'package:aplicacion2/models/userdata.dart';

/// Página donde el usuario ve indicaciones para tomar su fotografía.
///
/// Esta pantalla muestra un conjunto de instrucciones visuales
/// y textuales sobre cómo debe ser la fotografía del usuario.
/// Al presionar "Continuar", se considera que el usuario acepta
/// las condiciones y se actualiza el estado en [UserData].
class PhotoPage extends StatefulWidget {
  /// Diccionario de traducciones para internacionalización.
  final Map<String, dynamic> jsonStrings;

  /// Constructor de [PhotoPage].
  const PhotoPage({super.key, required this.jsonStrings});

  @override
  State<PhotoPage> createState() => _PhotoPageState();
}

class _PhotoPageState extends State<PhotoPage> {
  /// Bandera que indica si el usuario ha confirmado las instrucciones.
  bool _photoConfirmed = false;

  @override
  Widget build(BuildContext context) {
    final jsonStrings = widget.jsonStrings;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 80, 39, 51),
      body: Stack(
        children: <Widget>[
          /// Implementamos el logo en la parte superior de la pantalla
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
                      padding: const EdgeInsets.all(30.0),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.99),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            jsonStrings['photo'],
                            style: const TextStyle(
                              color: Color.fromARGB(255, 111, 38, 59),
                              fontSize: 30.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 30.0),

                          SvgPicture.asset(
                            'assets/Avatar.svg',
                            height: 110.0,
                            width: 110.0,
                          ),

                          const SizedBox(height: 40),

                          Text(
                            jsonStrings['take_picture'],
                            style: const TextStyle(
                              color: Color.fromARGB(255, 111, 38, 59),
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 20.0),

                          bulletItem(
                            jsonStrings['indication1'] ?? '',
                          ),
                          bulletItem(
                            jsonStrings['indication2'] ?? '',
                          ),
                          bulletItem(
                            jsonStrings['indication3'] ?? '',
                          ),
                          bulletItem(
                            jsonStrings['indication4'] ?? '',
                          ),
                          bulletItem(
                            jsonStrings['indication5'] ?? '',
                          ),

                          const SizedBox(height: 30.0),

                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromARGB(255, 185, 140, 87),
                              foregroundColor: Colors.white,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(3),
                                ),
                              ),
                            ),
                            onPressed: () {
                              setState(() {
                                _photoConfirmed = true;
                              });

                              UserData.photoConfirmed = true;

                              Navigator.pop(context, true);
                            },
                            child: Text(
                              jsonStrings['continue'],
                            ),
                          ),
                        ],
                      ),
                    ),

                    /// Botón de regreso en la esquina superior izquierda
                    /// del contenedor blanco
                    Positioned(
                      top: 0,
                      left: 0,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            decoration: const BoxDecoration(
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.all(
                                Radius.circular(3),
                              ),
                              color: Color.fromARGB(255, 211, 183, 150),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.arrow_back),
                            iconSize: 30.0,
                            color: Colors.white,
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
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
    );
  }
}