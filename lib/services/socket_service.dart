import 'package:file_pod/core/constants.dart'; // Importación de los archivos de constantes.
import 'package:flutter/material.dart'; // Importación del paquete de Flutter para crear UI.
import 'package:socket_io_client/socket_io_client.dart' as io; // Importación del cliente de Socket.IO.


// Enumeración para representar los estados del servidor.
enum ServerStatus { 
  online, // En línea.
  offline, // Fuera de línea.
  connecting // Conectando.
}

// Clase para el servicio de Socket, implementando ChangeNotifier para notificar cambios en los listeners.
class SocketService with ChangeNotifier { 

  // Estado inicial del servidor.
  ServerStatus _serverStatus = ServerStatus.connecting; 
  
  // Instancia del socket.
  late io.Socket _socket; 

  ServerStatus get serverStatus => _serverStatus; 
  
  // Getter para obtener el estado del servidor.
  io.Socket get socket => _socket; 

  // Getter para obtener la función de emitir datos.
  Function get emit => _socket.emit; 

  // Constructor de la clase SocketService.
  SocketService(){ 
    // Inicialización de la configuración del socket.
    _initConfig(); 
  }
  
  // Método privado para inicializar la configuración del socket.
  void _initConfig() { 
    // Se crea el socket con la URI y las opciones.
    _socket = io.io(SOCKETURI, io.OptionBuilder() 
    // Se establece el transporte como WebSocket.
      .setTransports(['websocket']) 
      .disableAutoConnect()  // Se deshabilita la conexión automática.
      .setExtraHeaders({'foo': 'bar'}) // Se establecen cabeceras adicionales (opcional).
      .build()); // Se construye la configuración del socket.
      _socket.connect(); // Se conecta al servidor.

     // Evento de conexión exitosa.
    _socket.on('connect', (_) {
      _serverStatus = ServerStatus.online; // Se actualiza el estado del servidor.
      notifyListeners(); // Se notifica a los listeners sobre el cambio de estado.
    });

    // Evento de desconexión.
    _socket.on('disconnect', (_) { 
      _serverStatus = ServerStatus.offline; // Se actualiza el estado del servidor.
      notifyListeners(); // Se notifica a los listeners sobre el cambio de estado.
    });
  }
  
}
