import 'dart:async';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../api/api_endpoints.dart';
import '../../app/tema/colors_app.dart';
import 'package:flutter/material.dart';

class SocketService {
  static final SocketService _instance = SocketService._internal();
  factory SocketService() => _instance;
  SocketService._internal();

  IO.Socket? socket;
  final _alertController = StreamController<Map<String, dynamic>>.broadcast();

  Stream<Map<String, dynamic>> get alertStream => _alertController.stream;

  void connect() {
    // Obtenemos la base URL desde ApiEndpoints (eliminando /api si es necesario)
    final String serverUrl = ApiEndpoints.baseUrl.replaceAll('/api', '');
    
    socket = IO.io(serverUrl, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': true,
    });

    socket!.onConnect((_) {
      print('Socket conectado con éxito');
    });

    socket!.on('new_alert', (data) {
      print('¡Nueva alerta recibida vía Socket!: $data');
      _alertController.add(Map<String, dynamic>.from(data));
    });

    socket!.onDisconnect((_) => print('Socket desconectado'));
  }

  void disconnect() {
    socket?.disconnect();
  }

  void dispose() {
    _alertController.close();
    socket?.dispose();
  }
}
