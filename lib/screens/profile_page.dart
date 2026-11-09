import 'package:flutter/material.dart';
import '../services/graphql_service.dart';

/// Consulta y edición del perfil remoto mediante GraphQL.
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _phone = TextEditingController();
  Map<String, dynamic>? _profile;
  bool _busy = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final profile = await GraphQLService.obtenerPerfil();
      if (!mounted) return;
      setState(() {
        _profile = profile;
        _phone.text = profile['telefono']?.toString() ?? '';
      });
    } catch (_) {
      if (mounted) {
        setState(() => _error =
            'No se pudo cargar el perfil. Verifica la conexión con el servidor.');
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final profile =
          await GraphQLService.actualizarTelefono(_phone.text.trim());
      if (!mounted) return;
      setState(() {
        _profile = profile;
        _phone.text = profile['telefono']?.toString() ?? '';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Teléfono actualizado')),
      );
    } catch (_) {
      if (mounted) {
        setState(() =>
            _error = 'No se pudo actualizar el teléfono. Inténtalo de nuevo.');
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  void dispose() {
    _phone.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mi cuenta'), actions: [
        IconButton(
            onPressed: _busy ? null : _load,
            tooltip: 'Actualizar perfil',
            icon: const Icon(Icons.refresh)),
      ]),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            if (_busy) const LinearProgressIndicator(),
            if (_error != null) ...[
              Text(_error!),
              TextButton(
                  onPressed: _busy ? null : _load,
                  child: const Text('Volver a consultar')),
            ],
            if (_profile != null) ...[
              ListTile(
                  leading: const Icon(Icons.person),
                  title: const Text('Nombre'),
                  subtitle:
                      Text(_profile!['nombre']?.toString() ?? 'Sin nombre')),
              ListTile(
                  leading: const Icon(Icons.email),
                  title: const Text('Correo electrónico'),
                  subtitle:
                      Text(_profile!['email']?.toString() ?? 'Sin correo')),
              const SizedBox(height: 16),
              TextFormField(
                  controller: _phone,
                  enabled: !_busy,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                      labelText: 'Teléfono', border: OutlineInputBorder()),
                  validator: (value) {
                    final phone = value?.trim() ?? '';
                    if (!RegExp(r'^\+?[0-9 ()-]{7,20}$').hasMatch(phone) ||
                        phone.replaceAll(RegExp(r'\D'), '').length < 7) {
                      return 'Ingresa un teléfono válido.';
                    }
                    return null;
                  }),
              const SizedBox(height: 16),
              ElevatedButton(
                  onPressed: _busy ? null : _save,
                  child: const Text('Guardar teléfono')),
            ],
          ]),
        ),
      ),
    );
  }
}
