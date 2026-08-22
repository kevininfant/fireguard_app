import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fireguard_app/core/services/admob_service.dart';
import 'package:fireguard_app/firebase_options.dart';
import 'package:fireguard_app/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    debugPrint('Firebase initialization notice: $e');
  }

  try {
    await AdMobService().initialize();
  } catch (e) {
    debugPrint('AdMob initialization notice: $e');
  }

  runApp(const FireGuardApp());
}
