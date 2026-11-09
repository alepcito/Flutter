
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketTestPage extends StatefulWidget {
  const WebSocketTestPage({super.key});

  @override
  State<WebSocketTestPage> createState() => _WebSocketTestPageState();
}

class _WebSocketTestPageState extends State<WebSocketTestPage> {
  WebSocketChannel? _channel;
  StreamSubscription<dynamic>? _subscription;

  final TextEditingController _messageController =
      TextEditingController();

  final List<String> _messages = [];

  bool _connected = false;
  String _status = 'Conectando al servidor...';

  @override
  void initState() {
    super.initState();
    _connect();
  }

  void _connect() {
    try {
      final channel = WebSocketChannel.connect(
        Uri.parse('ws://localhost:8000/ws/chat'),
      );

      _channel = channel;

      channel.ready.then<void>((_) {
        if (!mounted) return;

        setState(() {
          _connected = true;
          _status = 'Conectado al servidor WebSocket.';
        });
      }).catchError((Object error) {
        if (!mounted) return;

        setState(() {
          _connected = false;
          _status = 'Error de conexión: $error';
        });
      });

      _subscription = channel.stream.listen(
        (mensaje) {
          if (!mounted) return;

          setState(() {
            _messages.add('Servidor: $mensaje');
          });
        },
        onError: (Object error) {
          if (!mounted) return;

          setState(() {
            _connected = false;
            _status = 'Error de WebSocket: $error';
          });
        },
        onDone: () {
          if (!mounted) return;

          setState(() {
            _connected = false;
            _status = 'Conexión cerrada.';
          });
        },
      );
    } catch (error) {
      setState(() {
        _connected = false;
        _status = 'No se pudo conectar: $error';
      });
    }
  }

  void _sendMessage() {
    final mensaje = _messageController.text.trim();

    if (mensaje.isEmpty ||
        !_connected ||
        _channel == null) {
      return;
    }

    _channel!.sink.add(mensaje);

    setState(() {
      _messages.add('Tú: $mensaje');
    });

    _messageController.clear();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    _channel?.sink.close();
    _messageController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pruebas de WebSocket'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              _status,
              style: TextStyle(
                color: _connected ? Colors.green : Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    dense: true,
                    title: Text(_messages[index]),
                  );
                },
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    enabled: _connected,
                    decoration: const InputDecoration(
                      labelText: 'Escribe un mensaje',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: _connected ? _sendMessage : null,
                  icon: const Icon(Icons.send),
                  tooltip: 'Enviar mensaje',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
