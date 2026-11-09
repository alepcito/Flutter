
import 'package:flutter/material.dart';
import 'package:aplicacion2/services/graphql_service.dart';

class GraphQLTestPage extends StatefulWidget {
  const GraphQLTestPage({super.key});

  @override
  State<GraphQLTestPage> createState() => _GraphQLTestPageState();
}

class _GraphQLTestPageState extends State<GraphQLTestPage> {
  Map<String, dynamic>? perfil;
  String mensaje = 'Pulsa un botón para comenzar las pruebas.';
  bool cargando = false;

  Future<void> consultarPerfil() async {
    setState(() {
      cargando = true;
      mensaje = 'Consultando perfil...';
    });

    try {
      final resultado = await GraphQLService.obtenerPerfil();

      if (!mounted) return;

      setState(() {
        perfil = resultado;
        mensaje = 'Consulta GraphQL exitosa.';
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        mensaje = 'Error al consultar: $e';
      });
    } finally {
      if (mounted) {
        setState(() => cargando = false);
      }
    }
  }

  Future<void> actualizarTelefono() async {
    setState(() {
      cargando = true;
      mensaje = 'Actualizando teléfono...';
    });

    try {
      final resultado =
          await GraphQLService.actualizarTelefono('5512345678');

      if (!mounted) return;

      setState(() {
        perfil = resultado;
        mensaje = 'Mutación GraphQL exitosa.';
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        mensaje = 'Error al actualizar: $e';
      });
    } finally {
      if (mounted) {
        setState(() => cargando = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pruebas de GraphQL')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ElevatedButton(
                onPressed: cargando ? null : consultarPerfil,
                child: const Text('Consultar perfil'),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: cargando ? null : actualizarTelefono,
                child: const Text('Actualizar teléfono'),
              ),
              const SizedBox(height: 20),
              if (cargando)
                const Center(child: CircularProgressIndicator()),
              Text(mensaje),
              if (perfil != null) ...[
                const SizedBox(height: 16),
                const Text(
                  'Respuesta del backend:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                ...perfil!.entries.map(
                  (entrada) => ListTile(
                    dense: true,
                    title: Text(entrada.key),
                    subtitle: Text('${entrada.value}'),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
