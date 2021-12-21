import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:qr_code_reader/ui/screens/scanner_screen.dart';
import 'package:qr_code_reader/ui/screens/settings_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class MainScreen extends StatelessWidget {
  // convenience starter
  static Future<dynamic> start(
    BuildContext context,
  ) {
    return Navigator.push(context, MaterialPageRoute(builder: (_) {
      return MainScreen();
    }));
  }

  const MainScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Color(0xffff0066),
            shadowColor: Colors.transparent,
            title: Text("QR Code Scanner"),
            centerTitle: true,
            actions: [
              IconButton(
                  icon: Icon(Icons.settings),
                  onPressed: () => SettingsScreen.start(context))
            ],
          ),
          drawer: Drawer(
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(FlutterI18n.translate(context, "more"),
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xffff0066))),
                ),
                ListTile(
                  leading: const Icon(Icons.favorite),
                  title: I18nText("drawer.like"),
                  onTap: () => _likeApp(context),
                ),
                ListTile(
                  leading: const Icon(Icons.apps),
                  title: I18nText("drawer.more"),
                  onTap: () => _showMoreApps(context),
                )
              ],
            ),
          ),
          body: Column(
            children: [
              Spacer(),
              Align(
                child: Image.asset("assets/icon.png",
                    height: MediaQuery.of(context).size.width * 0.7),
              ),
              Spacer(flex: 3),
              Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).size.height * 0.1),
                child: OutlinedButton(
                    style: ButtonStyle(
                        padding: MaterialStateProperty.all(EdgeInsets.all(8)),
                        fixedSize: MaterialStateProperty.all(Size.fromWidth(
                            MediaQuery.of(context).size.width * 0.9)),
                        backgroundColor:
                            MaterialStateProperty.all(Color(0xffff0066)),
                        foregroundColor:
                            MaterialStateProperty.all(Colors.white),
                        textStyle:
                            MaterialStateProperty.all(TextStyle(fontSize: 24)),
                        side: MaterialStateProperty.all(
                            BorderSide(style: BorderStyle.none)),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)))),
                    onPressed: () => _showScanner(context),
                    child: I18nText("start")),
              ),
            ],
          )),
    );
  }

  Future<void> _showScanner(BuildContext context) async {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (_) {
          return ScannerScreen();
        });
  }

  // default callbacks
  Future<void> _launch(String url) async {
    if (await canLaunch(url)) {
      launch(url);
    }
  }

  Future<void> _likeApp(BuildContext context) async {
    String url = FlutterI18n.translate(context, "url.like");
    _launch(url);
  }

  Future<void> _showMoreApps(BuildContext context) async {
    String url = FlutterI18n.translate(context, "url.moreApps");
    _launch(url);
  }
}
