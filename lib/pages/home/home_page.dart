import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:file_pod/pages/home/widgets/insert_pin_dialog.dart';
import 'package:file_pod/pages/home/widgets/send_file_widget.dart';
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
    socketService.socket.on('file-received', _showShareFileDialog);

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
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  _buildBody() {
    return Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Ink(
              height: 200,
              width: 200,
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  color: Colors.white10),
              child: InkWell(
                borderRadius: BorderRadius.circular(15),
                onTap: picksinglefile,
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.send,
                        color: Colors.amberAccent.shade400,
                        size: 50,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        'Enviar un archivo',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),

          SizedBox(width: 40,),

          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Ink(
              height: 200,
              width: 200,
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  color: Colors.white10),
              child: InkWell(
                borderRadius: BorderRadius.circular(15),
                onTap: _insertPinDialog,
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.password,
                        color: Colors.pinkAccent,
                        size: 50,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        '¡Tengo un PIN!',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> picksinglefile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      file = result.files.first;

      final socketService = Provider.of<SocketService>(context, listen: false);

      socketService.socket.emit('upload-file', [{
        'filename': file!.name,
        'filedata': file!.bytes,
        'filesize': file!.size,
        'downloads': 1
      }]);
    }
  }

  _showShareFileDialog(data) async {
    return showDialog(
      context: context,
      builder: (_) {
        return SendFileWidget(pin: data["pin"], uid: data["uid"]);
      }
    );
  }

  _insertPinDialog() {
    return showDialog(
      context: context,
      builder: (_) {
        return InsertPinDialog();
      }
    );

  }
  
  _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      title: Row(
        children: [
          SizedBox(
            height: 30,
            width: 30,
            child: Image.asset('assets/images/logo.png', fit: BoxFit.cover),

          ),
          const SizedBox(width: 10,),
          const Text(
            "FilePod",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold


            )
          ),
        ],
      ),
    );
  }

  

  
}
