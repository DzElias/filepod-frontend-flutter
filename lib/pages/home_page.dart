import 'package:file_picker/file_picker.dart';
import 'package:file_pod/services/socket_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PlatformFile? file;

   @override
  void initState() {
    final socketService = Provider.of<SocketService>(context, listen: false);
    socketService.socket.on('archivo-guardado', _showShareFileDialog);

    super.initState();
  }

  @override
  void dispose() {
    final socketService = Provider.of<SocketService>(context);
    socketService.socket.off('archivo-guardado');
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: _buildBody(),
    );
  }

  _buildBody() {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
        ),
      
        child: Ink(
          height: 200,
          width: 200,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(15)),
            color: Colors.white10
          ),
      
          child: InkWell(
            borderRadius: BorderRadius.circular(15),
            onTap: picksinglefile,
            child: const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.send, color: Colors.pinkAccent, size: 50,),
                  SizedBox(height: 20,),
                  Text(
                    'Enviar archivo', 
                    style: TextStyle(
                      color: Colors.white, 
                      fontSize: 16, 
                      fontWeight: FontWeight.bold
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> picksinglefile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      file = result.files.first;
      
        final socketService = Provider.of<SocketService>(context, listen: false);
        
        socketService.socket.emit('enviar-archivo', [file!.name, file!.bytes]);
      
    }
  }
  

  _showShareFileDialog(data) {
    var link = data;
    print("http://$link");
  }
}