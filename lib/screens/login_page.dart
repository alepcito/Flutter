
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'welcome_page.dart';
import '../services/auth_service.dart';
import '../services/token_manager.dart';

class MyHomePage extends StatefulWidget {
  final Map<String, dynamic> jsonStrings;

  const MyHomePage({
    super.key,
    required this.jsonStrings,
  });

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final AuthService _authService = AuthService();

  bool _obscureText = true;
  bool _rememberMe = false;
  bool _isLoading = false;

  String _text(String key, String fallback) {
    return widget.jsonStrings[key]?.toString() ?? fallback;
  }

  @override
  void initState() {
    super.initState();
    _loadSavedCredentials();
  }

  Future<void> _loadSavedCredentials() async {
    try {
      final rememberMe = await TokenManager.getRememberMe();

      if (!mounted) return;

      setState(() {
        _rememberMe = rememberMe;
      });

      if (rememberMe) {
        final token = await TokenManager.getAccessToken();

        if (!mounted) return;

        if (token != null && token.isNotEmpty) {
          _navigateToWelcome();
        }
      }
    } catch (e) {
      debugPrint('Error al recuperar la sesión: $e');
    }
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final result = await _authService.login(
        _emailController.text.trim(),
        _passwordController.text,
      );

      if (!mounted) return;

      if (result['success'] == true) {
        final accessToken = result['accessToken'];
        final refreshToken = result['refreshToken'];

        if (accessToken is! String ||
            refreshToken is! String ||
            accessToken.isEmpty ||
            refreshToken.isEmpty) {
          _showErrorDialog(
            'La respuesta del servidor no contiene tokens válidos.',
          );
          return;
        }

        await TokenManager.saveTokens(
          accessToken: accessToken,
          refreshToken: refreshToken,
          rememberMe: _rememberMe,
        );

        if (!mounted) return;

        _navigateToWelcome();
      } else {
        _showErrorDialog(
          result['message']?.toString() ??
              'No se pudo iniciar sesión. Verifica tus credenciales.',
        );
      }
    } catch (e) {
      if (!mounted) return;

      _showErrorDialog(
        'Ocurrió un error al iniciar sesión. Inténtalo de nuevo.',
      );

      debugPrint('Error de inicio de sesión: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _navigateToWelcome() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => WelcomePage(
          jsonStrings: widget.jsonStrings,
        ),
      ),
      (route) => false,
    );
  }

  void _showErrorDialog(String message) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(_text('error', 'Error')),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(_text('accept', 'Aceptar')),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 80, 39, 51),
      body: SafeArea(
        child: Stack(
          children: [
            // Logo en la parte superior, separado del formulario.
            Positioned(
              top: 10,
              left: 0,
              right: 0,
              child: Center(
                child: SvgPicture.asset(
                  'assets/logo.svg',
                  height: 90,
                  width: 90,
                  placeholderBuilder: (context) => const SizedBox(
                    height: 90,
                    width: 90,
                    child: Icon(
                      Icons.account_circle,
                      size: 70,
                    ),
                  ),
                ),
              ),
            ),

            // Formulario desplazable debajo del logo.
            Positioned(
              top: 110,
              left: 0,
              right: 0,
              bottom: 0,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Center(
                  child: Container(
                    constraints: const BoxConstraints(
                      maxWidth: 360,
                    ),
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Título.
                          Text(
                            _text('login_title', 'Iniciar sesión'),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 8),

                          // Subtítulo.
                          Text(
                            _text(
                              'login_subtitle',
                              'Ingresa tus credenciales para continuar.',
                            ),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.grey.shade600,
                            ),
                          ),

                          const SizedBox(height: 28),

                          // Campo de correo electrónico.
                          TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            autofillHints: const [
                              AutofillHints.email,
                            ],
                            decoration: InputDecoration(
                              labelText: _text(
                                'email',
                                'Correo electrónico',
                              ),
                              prefixIcon: const Icon(
                                Icons.email_outlined,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Ingresa tu correo electrónico.';
                              }

                              if (!RegExp(
                                r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
                              ).hasMatch(value.trim())) {
                                return 'Ingresa un correo válido.';
                              }

                              return null;
                            },
                          ),

                          const SizedBox(height: 16),

                          // Campo de contraseña.
                          TextFormField(
                            controller: _passwordController,
                            obscureText: _obscureText,
                            autofillHints: const [
                              AutofillHints.password,
                            ],
                            decoration: InputDecoration(
                              labelText: _text(
                                'password',
                                'Contraseña',
                              ),
                              prefixIcon: const Icon(
                                Icons.lock_outline,
                              ),
                              suffixIcon: IconButton(
                                tooltip: _obscureText
                                    ? 'Mostrar contraseña'
                                    : 'Ocultar contraseña',
                                icon: Icon(
                                  _obscureText
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscureText = !_obscureText;
                                  });
                                },
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Ingresa tu contraseña.';
                              }

                              return null;
                            },
                          ),

                          const SizedBox(height: 8),

                          // Opción para recordar la sesión.
                          CheckboxListTile(
                            contentPadding: EdgeInsets.zero,
                            controlAffinity:
                                ListTileControlAffinity.leading,
                            title: Text(
                              _text('remember_me', 'Recuérdame'),
                            ),
                            value: _rememberMe,
                            onChanged: (value) {
                              setState(() {
                                _rememberMe = value ?? false;
                              });
                            },
                          ),

                          const SizedBox(height: 16),

                          // Botón de inicio de sesión.
                          SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: ElevatedButton(
                              onPressed:
                                  _isLoading ? null : _handleLogin,
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color.fromARGB(255, 80, 39, 51),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: _isLoading
                                  ? const SizedBox(
                                      height: 24,
                                      width: 24,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    )
                                  : Text(
                                      _text('login', 'Iniciar sesión'),
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );

  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
