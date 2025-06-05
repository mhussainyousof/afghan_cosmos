import 'package:afghan_cosmos/firebase_options.dart';
import 'package:afghan_cosmos/repo/auth_repo.dart';
import 'package:afghan_cosmos/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

    final auth = AuthRepository();
  await auth.signInAnonymously(); 
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}
//! main page
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.deepPurple,
      brightness: Brightness.light, 
    ),
  ),
      debugShowCheckedModeBanner: false,
      home: HomeScreen()
    );
  }
}