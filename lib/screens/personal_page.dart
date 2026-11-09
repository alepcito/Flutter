import 'package:flutter/material.dart';
import 'package:aplicacion2/widgets/custom_widgets.dart';
import 'package:aplicacion2/models/userdata.dart';

/// Página para capturar datos personales del usuario.
///
/// Esta pantalla permite al usuario ingresar su nombre, apellidos,
/// fecha de nacimiento, género y nacionalidad.
class PersonalPage extends StatefulWidget {
  /// Diccionario de traducciones para internacionalización.
  final Map<String, dynamic> jsonStrings;

  /// Constructor de [PersonalPage].
  const PersonalPage({
    super.key,
    required this.jsonStrings,
  });

  @override
  State<PersonalPage> createState() => _PersonalPageState();
}

/// Estado de la vista [PersonalPage].
///
/// Maneja los controladores de texto, validación de campos
/// y guardado condicional en [UserData].
class _PersonalPageState extends State<PersonalPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _secondLastNameController =
      TextEditingController();
  final TextEditingController _birthDateController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _nationalityController =
      TextEditingController();

  // Banderas de error por campo
  bool _nameError = false;
  bool _lastNameError = false;
  bool _secondLastNameError = false;
  bool _birthDateError = false;
  bool _genderError = false;
  bool _nationalityError = false;

  @override
  void initState() {
    super.initState();

    // Precargar datos desde UserData
    _nameController.text = UserData.name;
    _lastNameController.text = UserData.lastName;
    _secondLastNameController.text = UserData.secondLastName;
    _birthDateController.text = UserData.birthDate;
    _genderController.text = UserData.gender;
    _nationalityController.text = UserData.nationality;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _lastNameController.dispose();
    _secondLastNameController.dispose();
    _birthDateController.dispose();
    _genderController.dispose();
    _nationalityController.dispose();

    super.dispose();
  }

  /// Muestra un selector de fecha para la fecha de nacimiento.
  Future<void> _selectBirthDate(BuildContext context) async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1930),
      lastDate: DateTime.now(),
      locale: const Locale('es', 'ES'),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color.fromARGB(255, 185, 140, 87),
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: const Color.fromARGB(255, 185, 140, 87),
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (selectedDate != null) {
      String formattedDate =
          '${selectedDate.day.toString().padLeft(2, '0')}/'
          '${selectedDate.month.toString().padLeft(2, '0')}/'
          '${selectedDate.year}';

      setState(() {
        _birthDateController.text = formattedDate;
      });
    }
  }

  /// Activa las banderas de error para los campos vacíos.
  void _validateFields() {
    setState(() {
      _nameError = _nameController.text.isEmpty;
      _lastNameError = _lastNameController.text.isEmpty;
      _secondLastNameError = _secondLastNameController.text.isEmpty;
      _birthDateError = _birthDateController.text.isEmpty;
      _genderError = _genderController.text.isEmpty;
      _nationalityError = _nationalityController.text.isEmpty;
    });
  }

  /// Verifica si todos los campos han sido completados.
  bool _areFieldsFilled() {
    return !_nameController.text.isEmpty &&
        !_lastNameController.text.isEmpty &&
        !_secondLastNameController.text.isEmpty &&
        !_birthDateController.text.isEmpty &&
        !_genderController.text.isEmpty &&
        !_nationalityController.text.isEmpty;
  }

  @override
  Widget build(BuildContext context) {
    final jsonStrings = widget.jsonStrings;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 80, 39, 51),
      body: Stack(
        children: <Widget>[
          // Logo en la parte superior
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
                      height: 600,
                      padding: const EdgeInsets.all(20.0),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.99),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            jsonStrings['personal'],
                            style: const TextStyle(
                              color: Color.fromARGB(255, 111, 38, 59),
                              fontSize: 30.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 20.0),

                          buildField(
                            _nameController,
                            jsonStrings['name'],
                            _nameError,
                            widget.jsonStrings,
                          ),

                          buildField(
                            _lastNameController,
                            jsonStrings['last_name'],
                            _lastNameError,
                            widget.jsonStrings,
                          ),

                          buildField(
                            _secondLastNameController,
                            jsonStrings['second_last_name'],
                            _secondLastNameError,
                            widget.jsonStrings,
                          ),

                          GestureDetector(
                            onTap: () => _selectBirthDate(context),
                            child: AbsorbPointer(
                              child: TextFormField(
                                controller: _birthDateController,
                                decoration: InputDecoration(
                                  isDense: true,
                                  contentPadding: const EdgeInsets.symmetric(
                                    vertical: 12.0,
                                    horizontal: 12.0,
                                  ),
                                  border: const OutlineInputBorder(),
                                  labelText: jsonStrings['birth_date'],
                                  labelStyle: const TextStyle(
                                    fontSize: 14,
                                  ),
                                  suffixIcon: const Icon(
                                    Icons.calendar_month,
                                  ),
                                ),
                              ),
                            ),
                          ),

                          if (_birthDateError)
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

                          buildField(
                            _genderController,
                            jsonStrings['gender'],
                            _genderError,
                            widget.jsonStrings,
                          ),

                          buildField(
                            _nationalityController,
                            jsonStrings['nationality'],
                            _nationalityError,
                            widget.jsonStrings,
                          ),
                        ],
                      ),
                    ),

                    // Botón de regreso
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

                              // Actualiza UserData incluso si
                              // algunos campos están vacíos.
                              UserData.name = _nameController.text;
                              UserData.lastName = _lastNameController.text;
                              UserData.secondLastName =
                                  _secondLastNameController.text;
                              UserData.birthDate =
                                  _birthDateController.text;
                              UserData.gender = _genderController.text;
                              UserData.nationality =
                                  _nationalityController.text;

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