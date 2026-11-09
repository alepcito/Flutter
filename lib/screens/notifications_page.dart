import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_client_sse/flutter_client_sse.dart';
import 'package:flutter_client_sse/constants/sse_request_type_enum.dart';
import 'package:http/http.dart' as http;
import '../widgets/academic_screen.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  StreamSubscription<dynamic>? _subscription;

  final List<String> _notificaciones = [];

  bool _conectado = false;
  bool _generando = false;
  String _estado = 'Desconectado';

  @override
  void initState() {
    super.initState();
    _conectar();
  }

  void _conectar() {
    if (_conectado) return;

    _subscription?.cancel();
    SSEClient.unsubscribeFromSSE();

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
          if (evento.data == null || evento.data!.trim().isEmpty) return;

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
      final respuesta = await http
          .post(
            Uri.parse('http://localhost:8000/notificaciones/generar'),
            headers: {
              'Content-Type': 'application/json',
            },
            body: jsonEncode({
              'mensaje': 'Notificación de prueba desde Flutter',
            }),
          )
          .timeout(const Duration(seconds: 15));

      if (!mounted) return;

      if (respuesta.statusCode >= 200 && respuesta.statusCode < 300) {
        setState(() {
          _estado = 'Notificación generada correctamente';
        });
      } else {
        setState(() {
          _estado = 'Error HTTP ${respuesta.statusCode}: ${respuesta.body}';
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
    return AcademicScreen(
      title: 'Notificaciones',
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              _estado,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: _conectado ? Colors.green : Colors.red,
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 8,
              runSpacing: 8,
              children: [
                OutlinedButton(
                  style:
                      OutlinedButton.styleFrom(foregroundColor: academicGuinda),
                  onPressed: _conectado ? null : _conectar,
                  child: const Text('Recibir notificaciones'),
                ),
                OutlinedButton(
                  style:
                      OutlinedButton.styleFrom(foregroundColor: academicGuinda),
                  onPressed: _conectado ? _desconectar : null,
                  child: const Text('Pausar notificaciones'),
                ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: academicGuinda,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8))),
                  onPressed: _generando ? null : _generarNotificacion,
                  icon: const Icon(Icons.notifications_active),
                  label: Text(
                    _generando ? 'Generando...' : 'Generar notificación',
                  ),
                ),
              ],
            ),
            const Divider(height: 32),
            const Text(
              'Notificaciones recibidas',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: academicGuinda,
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: _notificaciones.isEmpty
                  ? const Center(
                      child: Text(
                        'No hay notificaciones nuevas',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _notificaciones.length,
                      itemBuilder: (context, index) {
                        return Card(
                          color: const Color(0xFFF5F5F5),
                          surfaceTintColor: Colors.transparent,
                          elevation: 0,
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: ListTile(
                            leading: const Icon(
                              Icons.notifications,
                              color: academicGuinda,
                            ),
                            title: Text(
                              _notificaciones[index],
                              style: const TextStyle(color: Colors.black87),
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
