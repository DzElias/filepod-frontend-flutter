
import 'package:file_pod/core/constants.dart';
import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:socket_io_client/socket_io_client.dart';
enum ServerStatus {
  online,
  offline,
  connecting
}

class SocketService with ChangeNotifier {

  ServerStatus _serverStatus = ServerStatus.connecting;
  late io.Socket _socket;

  ServerStatus get serverStatus => _serverStatus;
  
  io.Socket get socket => _socket;
  Function get emit => _socket.emit;

  SocketService(){
    _initConfig();
  }
  
  void _initConfig() {
    _socket = io.io(SOCKETURI, OptionBuilder()
      .setTransports(['websocket']) // for Flutter or Dart VM
      .disableAutoConnect()  // disable auto-connection
      .setExtraHeaders({'foo': 'bar'}) // optional
      .build());
      _socket.connect();

    _socket.on('connect', (_) {
      _serverStatus = ServerStatus.online;
      print("conectado");
      notifyListeners();
    });

    _socket.on('disconnect', (_) {
      _serverStatus = ServerStatus.offline;
      notifyListeners();
    });
  }
  
}
