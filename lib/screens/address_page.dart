import 'package:flutter/material.dart';
import 'package:aplicacion2/widgets/custom_widgets.dart';
import 'package:aplicacion2/models/userdata.dart';

/// Página para ingresar los datos de dirección del usuario.
///
/// Incluye campos como código postal, ciudad, colonia, calle, etc.
/// Solo guarda los datos si todos los campos están completos.
/// Los datos se almacenan temporalmente en la clase [UserData].
class AdressPage extends StatefulWidget {
  /// Mapa con cadenas traducidas para los textos.
  final Map<String, dynamic> jsonStrings;

  /// Constructor que requiere [jsonStrings] para internacionalización.
  const AdressPage({super.key, required this.jsonStrings});

  @override
  State<AdressPage> createState() => _AdressPageState();
}

class _AdressPageState extends State<AdressPage> {
  // Controladores para los campos
  final _zipController = TextEditingController();
  final _stateController = TextEditingController();
  final _cityController = TextEditingController();
  final _neighborhoodController = TextEditingController();
  final _streetController = TextEditingController();
  final _extNumberController = TextEditingController();
  final _intNumberController = TextEditingController();
  final _referenceController = TextEditingController();

  // Banderas de error por campo
  bool _zipError = false;
  bool _stateError = false;
  bool _cityError = false;
  bool _neighborhoodError = false;
  bool _streetError = false;
  bool _extNumberError = false;
  bool _intNumberError = false;
  bool _referenceError = false;

  @override
  void initState() {
    super.initState();

    // Precargar datos desde UserData
    _zipController.text = UserData.zipCode;
    _stateController.text = UserData.state;
    _cityController.text = UserData.city;
    _neighborhoodController.text = UserData.neighborhood;
    _streetController.text = UserData.street;
    _extNumberController.text = UserData.extNumber;
    _intNumberController.text = UserData.intNumber;
    _referenceController.text = UserData.reference;
  }

  /// Valida que todos los campos tengan contenido.
  void _validateFields() {
    setState(() {
      _zipError = _zipController.text.isEmpty;
      _stateError = _stateController.text.isEmpty;
      _cityError = _cityController.text.isEmpty;
      _neighborhoodError = _neighborhoodController.text.isEmpty;
      _streetError = _streetController.text.isEmpty;
      _extNumberError = _extNumberController.text.isEmpty;
      _intNumberError = _intNumberController.text.isEmpty;
      _referenceError = _referenceController.text.isEmpty;
    });
  }

  /// Indica si todos los campos han sido completados correctamente.
  bool _areFieldsFilled() {
    return !_zipController.text.isEmpty &&
        !_stateController.text.isEmpty &&
        !_cityController.text.isEmpty &&
        !_neighborhoodController.text.isEmpty &&
        !_streetController.text.isEmpty &&
        !_extNumberController.text.isEmpty &&
        !_intNumberController.text.isEmpty &&
        !_referenceController.text.isEmpty;
  }

  @override
  void dispose() {
    _zipController.dispose();
    _stateController.dispose();
    _cityController.dispose();
    _neighborhoodController.dispose();
    _streetController.dispose();
    _extNumberController.dispose();
    _intNumberController.dispose();
    _referenceController.dispose();

    super.dispose();
  }

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
                      padding: const EdgeInsets.all(20.0),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.99),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            jsonStrings['adress'],
                            style: const TextStyle(
                              color: Color.fromARGB(255, 111, 38, 59),
                              fontSize: 30.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 20.0),

                          buildField(
                            _zipController,
                            jsonStrings['zip_code'],
                            _zipError,
                            widget.jsonStrings,
                          ),

                          buildField(
                            _stateController,
                            jsonStrings['state'],
                            _stateError,
                            widget.jsonStrings,
                          ),

                          buildField(
                            _cityController,
                            jsonStrings['city'],
                            _cityError,
                            widget.jsonStrings,
                          ),

                          buildField(
                            _neighborhoodController,
                            jsonStrings['neighborhood'],
                            _neighborhoodError,
                            widget.jsonStrings,
                          ),

                          buildField(
                            _streetController,
                            jsonStrings['street'],
                            _streetError,
                            widget.jsonStrings,
                          ),

                          buildField(
                            _extNumberController,
                            jsonStrings['ext_number'],
                            _extNumberError,
                            widget.jsonStrings,
                          ),

                          buildField(
                            _intNumberController,
                            jsonStrings['int_number'],
                            _intNumberError,
                            widget.jsonStrings,
                          ),

                          buildField(
                            _referenceController,
                            jsonStrings['reference'],
                            _referenceError,
                            widget.jsonStrings,
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
                              _validateFields();

                              // Guardar lo que esté en los campos,
                              // incluso si están vacíos.
                              UserData.zipCode = _zipController.text;
                              UserData.state = _stateController.text;
                              UserData.city = _cityController.text;
                              UserData.neighborhood =
                                  _neighborhoodController.text;
                              UserData.street = _streetController.text;
                              UserData.extNumber =
                                  _extNumberController.text;
                              UserData.intNumber =
                                  _intNumberController.text;
                              UserData.reference =
                                  _referenceController.text;

                              Navigator.pop(
                                context,
                                _areFieldsFilled(),
                              );
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