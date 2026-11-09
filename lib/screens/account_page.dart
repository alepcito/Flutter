import 'package:flutter/material.dart';
import 'package:aplicacion2/widgets/custom_widgets.dart';
import 'package:aplicacion2/models/userdata.dart';

/// Pantalla para capturar datos de cuenta del usuario.
///
/// Esta vista contiene campos para teléfono, correo, nombre de usuario,
/// contraseña, ocupación y rol. La información se guarda temporalmente
/// en la clase [UserData].
class AccountPage extends StatefulWidget {
  /// Mapa de cadenas traducidas para los textos visibles.
  final Map<String, dynamic> jsonStrings;

  /// Constructor que recibe el mapa de traducciones.
  const AccountPage({
    super.key,
    required this.jsonStrings,
  });

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  // Controladores
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _userController = TextEditingController();
  final _passwordController = TextEditingController();
  final _occupationController = TextEditingController();
  final _roleController = TextEditingController();

  // Banderas de error
  bool _phoneError = false;
  bool _emailError = false;
  bool _usernameError = false;
  bool _userError = false;
  bool _passwordError = false;
  bool _occupationError = false;
  bool _roleError = false;

  // Bandera para mostrar / ocultar contraseña
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();

    // Precargar datos desde UserData
    _phoneController.text = UserData.phone;
    _emailController.text = UserData.email;
    _usernameController.text = UserData.username;
    // _userController.text = UserData.user;
    _passwordController.text = UserData.password;
    _occupationController.text = UserData.occupation;
    _roleController.text = UserData.role;
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _emailController.dispose();
    _usernameController.dispose();
    _userController.dispose();
    _passwordController.dispose();
    _occupationController.dispose();
    _roleController.dispose();

    super.dispose();
  }

  /// Valida que todos los campos estén llenos.
  void _validateFields() {
    setState(() {
      _phoneError = _phoneController.text.isEmpty;
      _emailError = _emailController.text.isEmpty;
      _usernameError = _usernameController.text.isEmpty;
      _userError = _userController.text.isEmpty;
      _passwordError = _passwordController.text.isEmpty;
      _occupationError = _occupationController.text.isEmpty;
      _roleError = _roleController.text.isEmpty;
    });
  }

  /// Verifica si todos los campos han sido completados correctamente.
  bool _areFieldsFilled() {
    return !_phoneController.text.isEmpty &&
        !_emailController.text.isEmpty &&
        !_usernameController.text.isEmpty &&
        !_userController.text.isEmpty &&
        !_passwordController.text.isEmpty &&
        !_occupationController.text.isEmpty &&
        !_roleController.text.isEmpty;
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
                            jsonStrings['account'],
                            style: const TextStyle(
                              color: Color.fromARGB(255, 111, 38, 59),
                              fontSize: 30.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 20.0),

                          buildField(
                            _phoneController,
                            jsonStrings['phone'],
                            _phoneError,
                            widget.jsonStrings,
                          ),

                          buildField(
                            _emailController,
                            jsonStrings['email_account'],
                            _emailError,
                            widget.jsonStrings,
                          ),

                          buildField(
                            _usernameController,
                            jsonStrings['username'],
                            _usernameError,
                            widget.jsonStrings,
                          ),

                          buildField(
                            _userController,
                            jsonStrings['user'],
                            _userError,
                            widget.jsonStrings,
                          ),

                          // Campo de contraseña
                          TextFormField(
                            controller: _passwordController,
                            obscureText: _obscurePassword,
                            style: const TextStyle(fontSize: 14),
                            decoration: InputDecoration(
                              isDense: true,
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 12.0,
                                horizontal: 12.0,
                              ),
                              border: const OutlineInputBorder(),
                              labelText: jsonStrings['pass_account'],
                              labelStyle: const TextStyle(fontSize: 14),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  size: 20,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscurePassword = !_obscurePassword;
                                  });
                                },
                              ),
                            ),
                          ),

                          if (_passwordError)
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
                            _occupationController,
                            jsonStrings['occupation'],
                            _occupationError,
                            widget.jsonStrings,
                          ),

                          buildField(
                            _roleController,
                            jsonStrings['role'],
                            _roleError,
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

                              // Actualizar UserData
                              // incluso si los campos están vacíos.
                              UserData.phone = _phoneController.text;
                              UserData.email = _emailController.text;
                              UserData.username = _usernameController.text;

                              // UserData.user = _userController.text;

                              UserData.password = _passwordController.text;
                              UserData.occupation =
                                  _occupationController.text;
                              UserData.role = _roleController.text;

                              if (_areFieldsFilled()) {
                                Navigator.pop(context, true);
                              } else {
                                Navigator.pop(context);
                              }
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