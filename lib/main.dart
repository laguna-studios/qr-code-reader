import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_i18n/loaders/decoders/yaml_decode_strategy.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'ui/screens/mainscreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "QR Code Reader",
      theme: ThemeData(primarySwatch: Colors.blue),
      supportedLocales: const [
        Locale("en"),
        Locale("de"),
      ],
      localizationsDelegates: [
        FlutterI18nDelegate(
          translationLoader:
              FileTranslationLoader(decodeStrategies: [YamlDecodeStrategy()]),
        ),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate
      ],
      home: MainScreen(),
    );
  }
}
