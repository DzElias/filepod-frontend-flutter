import 'package:clipboard/clipboard.dart';
import 'package:file_picker/file_picker.dart';
import 'package:file_pod/core/constants.dart';
import 'package:file_pod/services/socket_service.dart';
import 'package:flutter/material.dart';
import 'package:image_downloader_web/image_downloader_web.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';

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
              color: Colors.white10),
          child: InkWell(
            borderRadius: BorderRadius.circular(15),
            onTap: picksinglefile,
            child: const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.send,
                    color: Colors.pinkAccent,
                    size: 50,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Enviar archivo',
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

  _showShareFileDialog(data) async {
    showDialog(
        context: context,
        builder: (_) {
          return Material(
            type: MaterialType.transparency,
            child: Center(
              child: Container(
                padding: const EdgeInsets.all(15),
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(15))),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Link de descarga generado',style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                        'Este link puede ser usado solo una vez, ¡Compartilo! ',style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14),),
                                      const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 200,
                          height: 45,
                          padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                      color: Colors.black87,
                      borderRadius:BorderRadius.only(topLeft: Radius.circular(10), bottomLeft: Radius.circular(10))
                    ),
                          child: Center(
                            child: Text(
                              "${SOCKETURI}download/$data"
                                                    ,style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 14),overflow: TextOverflow.ellipsis,),
                          ),
                        ),
                        MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: GestureDetector(
                            onTap: () => copy("${SOCKETURI}download/$data "),
                            child: Container(
                              height: 45,
                              decoration: const BoxDecoration(
                      color: Colors.black87,
                      borderRadius:BorderRadius.only(topRight: Radius.circular(10), bottomRight: Radius.circular(10)),
                      
                    ),
                    child: Center(child: Icon(Icons.copy, color: Colors.white,)),
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    QrImageView(
                      data:
                          "${SOCKETURI}download/$data", // Generate QR code from the URL provided as a parameter
                      version: QrVersions.auto,
                      size: 200.0,
                    ),
                    GestureDetector(
                        onTap: () => _shareQRImage(data),
                        child: MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: const BoxDecoration(
                                    color: Colors.black87,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                child: const Text(
                                  'Descargar qr',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                      ),
                                ))))
                  ],
                ),
              ),
            ),
          );
        });
  }

  Future _shareQRImage(data) async {
    var link = "${SOCKETURI}download/$data";
    final image = await QrPainter(
      data: link,
      version: QrVersions.auto,
      gapless: false,
      color: Colors.black,
      emptyColor: Colors.white,
    ).toImageData(200.0);

    var bytes = image!.buffer.asUint8List(); // Get the image bytes
    await WebImageDownloader.downloadImageFromUInt8List(
        uInt8List: bytes, name: 'Mi qr');
    setState(() {
      
    });
  }
  
  void copy(String text) async {
    await FlutterClipboard.copy(text);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: Colors.green,
      content: Text(
        "📝 Link copiado al portapapeles",
        style: TextStyle(color: Colors.white, fontSize: 18),
      ),
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.symmetric(vertical: 20),
    ));
  }
}
