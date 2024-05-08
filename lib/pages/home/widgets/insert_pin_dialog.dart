import 'package:clipboard/clipboard.dart';
import 'package:file_pod/core/constants.dart';
import 'package:file_pod/services/socket_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_downloader_web/image_downloader_web.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'dart:js' as js;

class InsertPinDialog extends StatefulWidget {
  const InsertPinDialog({
    super.key,
  });

  @override
  State<InsertPinDialog> createState() => _InsertPinDialogState();
}

class _InsertPinDialogState extends State<InsertPinDialog> {
  @override
  void initState() {
    final socketService = Provider.of<SocketService>(context, listen: false);
    socketService.socket.on("check-result",  _checkResult);
    super.initState();
  }

  TextEditingController pinCtrl = TextEditingController();
  @override
  Widget build(BuildContext context) {
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
              Text(
                'Ingrese el PIN de descarga',
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                width: 300,
                child: PinCodeTextField(
                  appContext: context,
                  length: 6,
                  obscureText: false,
                  animationType: AnimationType.fade,
                  pinTheme: PinTheme(
                      shape: PinCodeFieldShape.box,
                      borderRadius: BorderRadius.circular(5),
                      fieldHeight: 50,
                      fieldWidth: 40,
                      activeFillColor: Colors.white,
                      activeColor: Colors.pinkAccent,
                      inactiveColor: Colors.pinkAccent,
                      inactiveFillColor: Colors.black87,
                      selectedFillColor: Colors.pinkAccent,
                      selectedColor: Colors.black87),
                  animationDuration: const Duration(milliseconds: 300),
                  backgroundColor: Colors.blue.shade50,
                  enableActiveFill: true,
                  controller: pinCtrl,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () {
                    final socketService =
                        Provider.of<SocketService>(context, listen: false);

                    socketService.socket
                        .emit("check-pin", [int.parse(pinCtrl.text)]);
                  },
                  child: Container(
                    width: 225,
                    height: 45,
                    padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                        color: Colors.black87,
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: Center(
                      child: Text(
                        "Confirmar",
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w400,
                            fontSize: 14),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _checkResult(data) {
    String status = data["status"];
    print(data);
    if (status == "ok") {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        backgroundColor: Colors.green,
        content: Text(
          "✅ PIN validado correctamente, redireccionando...",
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.symmetric(vertical: 20),
      ));

      js.context.callMethod('open', ["${SOCKETURI}file/preview/${data["uid"]}"]);


      Navigator.of(context).pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        backgroundColor: Colors.redAccent,
        content: Text(
          "❌ PIN incorrecto, intente de nuevo...",
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.symmetric(vertical: 20),
      ));
      pinCtrl.clear();
    }
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
    setState(() {});
  }

  void copy(String text) async {
    await FlutterClipboard.copy(text);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
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
