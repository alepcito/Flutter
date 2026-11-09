import 'dart:async';

import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../widgets/academic_screen.dart';

class WebSocketTestPage extends StatefulWidget {
  const WebSocketTestPage({super.key});

  @override
  State<WebSocketTestPage> createState() => _WebSocketTestPageState();
}

class _WebSocketTestPageState extends State<WebSocketTestPage> {
  WebSocketChannel? _channel;
  StreamSubscription<dynamic>? _subscription;

  final TextEditingController _messageController = TextEditingController();

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

    if (mensaje.isEmpty || !_connected || _channel == null) {
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
    return AcademicScreen(
      title: 'ChatBot',
      header: Column(
        children: [
          SvgPicture.asset('assets/Pantera.svg',
              height: 50,
              width: 50,
              semanticsLabel: 'Icono ChatBot',
              colorFilter:
                  const ColorFilter.mode(academicGuinda, BlendMode.srcIn)),
          const SizedBox(height: 4),
          const Text('ChatBot',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: academicGuinda)),
          const Text('Tu asistente virtual',
              style: TextStyle(fontSize: 12, color: Colors.grey)),
          const SizedBox(height: 4),
          Tooltip(
              message: _status,
              child: Text(_status,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 12,
                      color: _connected ? Colors.green : Colors.red))),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: Column(
          children: [
            Expanded(
              child: _messages.isEmpty
                  ? const Center(
                      child: Text(
                          'Envía un mensaje para conversar con el servidor.',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey, fontSize: 14)))
                  : ListView.builder(
                      itemCount: _messages.length,
                      itemBuilder: (context, index) {
                        final isMine = _messages[index].startsWith('Tú:');
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: Text(_messages[index],
                              style: TextStyle(
                                  color: isMine
                                      ? academicGuinda
                                      : Colors.black87)),
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
                      hintText: 'Escribe tu mensaje...',
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(24)),
                          borderSide: BorderSide(color: Colors.grey)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(24)),
                          borderSide: BorderSide(color: academicGuinda)),
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: _connected ? _sendMessage : null,
                  icon: const Icon(Icons.send),
                  tooltip: 'Enviar mensaje',
                  style: IconButton.styleFrom(
                    minimumSize: const Size(50, 50),
                    backgroundColor: academicGuinda,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: academicBeige,
                    shape: const CircleBorder(),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
