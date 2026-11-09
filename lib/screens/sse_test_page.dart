
import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_client_sse/flutter_client_sse.dart';
import 'package:flutter_client_sse/constants/sse_request_type_enum.dart';
import 'package:http/http.dart' as http;

class SseTestPage extends StatefulWidget {
  const SseTestPage({super.key});

  @override
  State<SseTestPage> createState() => _SseTestPageState();
}

class _SseTestPageState extends State<SseTestPage> {
  StreamSubscription<dynamic>? _subscription;

  final List<String> _notificaciones = [];

  bool _conectado = false;
  bool _generando = false;
  String _estado = 'Desconectado';

  void _conectar() {
    if (_conectado) return;

    setState(() {
      _estado = 'Conectando al servidor...';
    });

    try {
      _subscription = SSEClient.subscribeToSSE(
        method: SSERequestType.GET,
        url: 'http://localhost:8000/notificaciones/eventos',
        header: {
          'Accept': 'text/event-stream',
          'Cache-Control': 'no-cache',
        },
      ).listen(
        (evento) {
          if (!mounted) return;

          setState(() {
            _conectado = true;
            _estado = 'Conectado: escuchando notificaciones';

            try {
              final datos = jsonDecode(evento.data ?? '{}');

              _notificaciones.insert(
                0,
                'ID: ${datos['id']}\n'
                'Mensaje: ${datos['mensaje']}\n'
                'Hora: ${datos['hora']}',
              );
            } catch (_) {
              _notificaciones.insert(
                0,
                'Evento recibido: ${evento.data ?? ''}',
              );
            }
          });
        },
        onError: (Object error) {
          if (!mounted) return;

          setState(() {
            _conectado = false;
            _estado = 'Error SSE: $error';
          });
        },
        onDone: () {
          if (!mounted) return;

          setState(() {
            _conectado = false;
            _estado = 'Conexión SSE cerrada';
          });
        },
      );

      setState(() {
        _conectado = true;
        _estado = 'Suscripción iniciada; esperando eventos...';
      });
    } catch (error) {
      setState(() {
        _conectado = false;
        _estado = 'No se pudo conectar: $error';
      });
    }
  }

  Future<void> _generarNotificacion() async {
    if (_generando) return;

    setState(() {
      _generando = true;
    });

    try {
      final respuesta = await http.post(
        Uri.parse('http://localhost:8000/notificaciones/generar'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'mensaje': 'Notificación de prueba desde Flutter',
        }),
      );

      if (!mounted) return;

      if (respuesta.statusCode == 200) {
        setState(() {
          _estado = 'Notificación generada correctamente';
        });
      } else {
        setState(() {
          _estado =
              'Error HTTP ${respuesta.statusCode}: ${respuesta.body}';
        });
      }
    } catch (error) {
      if (!mounted) return;

      setState(() {
        _estado = 'Error al generar notificación: $error';
      });
    } finally {
      if (mounted) {
        setState(() {
          _generando = false;
        });
      }
    }
  }

  void _desconectar() {
    _subscription?.cancel();
    _subscription = null;

    SSEClient.unsubscribeFromSSE();

    setState(() {
      _conectado = false;
      _estado = 'Desconectado';
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    SSEClient.unsubscribeFromSSE();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pruebas de SSE'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              _estado,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: _conectado ? Colors.green : Colors.red,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _conectado ? null : _conectar,
              child: const Text('Conectar SSE'),
            ),
            ElevatedButton(
              onPressed: _conectado ? _desconectar : null,
              child: const Text('Desconectar SSE'),
            ),
            ElevatedButton.icon(
              onPressed: _generando ? null : _generarNotificacion,
              icon: const Icon(Icons.notifications_active),
              label: Text(
                _generando
                    ? 'Generando...'
                    : 'Generar notificación',
              ),
            ),
            const Divider(height: 32),
            const Text(
              'Notificaciones recibidas',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: _notificaciones.isEmpty
                  ? const Center(
                      child: Text(
                        'Todavía no se han recibido notificaciones.',
                      ),
                    )
                  : ListView.builder(
                      itemCount: _notificaciones.length,
                      itemBuilder: (context, index) {
                        return Card(
                          child: ListTile(
                            leading: const Icon(
                              Icons.notifications,
                            ),
                            title: Text(
                              _notificaciones[index],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
