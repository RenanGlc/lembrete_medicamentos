import 'package:flutter/material.dart';
import 'package:lembrete_medicamentos/HomePage.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);

  OneSignal.shared.setAppId("ce09d619-4f11-41cc-9125-e8da6ddcc2ec");

  runApp(
      const MaterialApp(
        home: HomePage(),
        debugShowCheckedModeBanner: false,
      )
  );
}
