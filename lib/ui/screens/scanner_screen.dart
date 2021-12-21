import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class ScannerScreen extends StatefulWidget {
  // convenience starter
  static Future<dynamic> start(
    BuildContext context,
  ) {
    return Navigator.push(context, MaterialPageRoute(builder: (_) {
      return ScannerScreen();
    }));
  }

  const ScannerScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  late QRViewController controller;
  bool showingResult = false;
  bool flash = false;

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller.pauseCamera();
    } else if (Platform.isIOS) {
      controller.resumeCamera();
    }
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) async {
      if (showingResult) return;
      showingResult = true;

      await showModalBottomSheet(
          backgroundColor: Colors.transparent,
          context: context,
          builder: (_) {
            return ResultPage(data: scanData.code);
          });

      showingResult = false;
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Stack(
        children: [
          QRView(
            overlay: QrScannerOverlayShape(borderColor: Colors.white),
            key: qrKey,
            onQRViewCreated: _onQRViewCreated,
          ),
          Align(
            alignment: Alignment(0.8, -0.8),
            child: GestureDetector(
                onTap: () {
                  controller.toggleFlash();
                  setState(() {
                    flash = !flash;
                  });
                },
                child: Icon(
                  flash ? Icons.flash_off : Icons.flash_on,
                  color: Colors.white,
                  size: 42,
                )),
          ),
          Align(
            alignment: Alignment(-0.8, -0.8),
            child: GestureDetector(
                onTap: () {
                  controller.flipCamera();
                },
                child: Icon(
                  Icons.cameraswitch,
                  color: Colors.white,
                  size: 42,
                )),
          ),
          Align(
            alignment: Alignment(0, 0.8),
            child: OutlinedButton(
                style: ButtonStyle(
                    padding: MaterialStateProperty.all(EdgeInsets.all(8)),
                    fixedSize: MaterialStateProperty.all(Size.fromWidth(
                        MediaQuery.of(context).size.width * 0.9)),
                    backgroundColor:
                        MaterialStateProperty.all(Color(0xffff0066)),
                    foregroundColor: MaterialStateProperty.all(Colors.white),
                    textStyle:
                        MaterialStateProperty.all(TextStyle(fontSize: 24)),
                    side: MaterialStateProperty.all(
                        BorderSide(style: BorderStyle.none)),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)))),
                onPressed: () => Navigator.pop(context),
                child: I18nText("end")),
          )
        ],
      ),
    ));
  }
}

class ResultPage extends StatelessWidget {
  final String data;

  const ResultPage({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12), topRight: Radius.circular(12))),
      child: Column(children: [
        Text(FlutterI18n.translate(context, "detected"),
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Divider(),
        ),
        Expanded(child: SingleChildScrollView(child: SelectableText(data))),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Divider(),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: OutlinedButton(
              style: ButtonStyle(
                  fixedSize: MaterialStateProperty.all(
                      Size.fromWidth(MediaQuery.of(context).size.width * 0.9)),
                  padding: MaterialStateProperty.all(EdgeInsets.all(8)),
                  backgroundColor: MaterialStateProperty.all(Color(0xffff0066)),
                  foregroundColor: MaterialStateProperty.all(Colors.white),
                  textStyle: MaterialStateProperty.all(TextStyle(fontSize: 24)),
                  side: MaterialStateProperty.all(
                      BorderSide(style: BorderStyle.none)),
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)))),
              onPressed: () => Navigator.pop(context),
              child: I18nText("got_it")),
        )
      ]),
    );
  }
}
