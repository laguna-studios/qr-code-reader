import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsScreen extends StatelessWidget {
  // convenience starter
  static Future<dynamic> start(BuildContext context) {
    return Navigator.push(context, MaterialPageRoute(builder: (_) {
      return SettingsScreen();
    }));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: Color(0xffff0066),
              title: I18nText("settings.name"),
              centerTitle: true,
            ),
            body: ListView(children: [
              ListTile(
                  title: I18nText("settings.contact.name"),
                  subtitle: I18nText("settings.contact.description"),
                  onTap: () => _showContact(context)),
              ListTile(
                  title: I18nText("settings.privacyPolicy.name"),
                  subtitle: I18nText("settings.privacyPolicy.description"),
                  onTap: () => _showPrivacyPolicy(context)),
              ListTile(
                  title: I18nText("settings.termsOfUse.name"),
                  subtitle: I18nText("settings.termsOfUse.description"),
                  onTap: () => _showTermsOfUse(context)),
              ListTile(
                  title: I18nText("settings.about.name"),
                  subtitle: I18nText("settings.about.description"),
                  onTap: () => showAboutDialog(
                      context: context,
                      applicationLegalese:
                          FlutterI18n.translate(context, "about_dialog.text")))
            ])));
  }

  // default callbacks
  Future<void> _launch(String url) async {
    if (await canLaunch(url)) {
      launch(url);
    }
  }

  Future<void> _showContact(BuildContext context) async {
    String url = FlutterI18n.translate(context, "url.contact");
    _launch(url);
  }

  Future<void> _showPrivacyPolicy(BuildContext context) async {
    String url = FlutterI18n.translate(context, "url.privacyPolicy");
    _launch(url);
  }

  Future<void> _showTermsOfUse(BuildContext context) async {
    String url = FlutterI18n.translate(context, "url.termsOfUse");
    _launch(url);
  }
}
