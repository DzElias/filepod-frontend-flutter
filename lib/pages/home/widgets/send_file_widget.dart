import 'package:clipboard/clipboard.dart';
import 'package:file_pod/core/constants.dart';
import 'package:flutter/material.dart';
import 'package:image_downloader_web/image_downloader_web.dart';
import 'package:qr_flutter/qr_flutter.dart';

class SendFileWidget extends StatefulWidget {
  final String uid;
  final int pin;
  const SendFileWidget({super.key, required this.uid, required this.pin});

  @override
  State<SendFileWidget> createState() => _SendFileWidgetState();
}

class _SendFileWidgetState extends State<SendFileWidget> {
  @override
  Widget build(BuildContext context) {
    return Material(
            type: MaterialType.transparency,
            child: Center(
              child: Container(
                padding: const EdgeInsets.all(15),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(15))
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Link de descarga generado',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 18
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      'Este link puede ser usado solo una vez, ¡Compartilo! ',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 14
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    QrImageView(
                      data:
                          "${SOCKETURI}file/preview/${widget.uid}", // Generate QR code from the URL provided as a parameter
                      version: QrVersions.auto,
                      size: 200.0,
                    ),
                    
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
                            borderRadius:BorderRadius.only(
                              topLeft: Radius.circular(10), 
                              bottomLeft: Radius.circular(10)
                            )
                          ),
                          child: Center(
                            child: Text(
                              "Copiar link generado",
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w400,
                                fontSize: 14
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),

                        
                        MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: GestureDetector(
                            onTap: () => copy("${SOCKETURI}file/preview/${widget.uid}"),
                            child: Container(
                              height: 45,
                              decoration: const BoxDecoration(
                                color: Colors.black87,
                                borderRadius:BorderRadius.only(
                                  topRight: Radius.circular(10), 
                                  bottomRight: Radius.circular(10)
                                ),
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons.copy, 
                                  color: Colors.white,
                                )
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                          width: 225,
                          height: 45,
                          padding: const EdgeInsets.all(10),
                          decoration: const BoxDecoration(
                            color: Colors.black87,
                            borderRadius:BorderRadius.all(
                              Radius.circular(10)
                            )
                          ),
                          child: Center(
                            child: Text(
                              "PIN de descarga:  ${widget.pin}",
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w400,
                                fontSize: 14
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                    
                    const SizedBox(
                      height: 10,
                    ),
                    
                  ],
                ),
              ),
            ),
          );
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