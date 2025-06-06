import 'package:afghan_cosmos/firebase_options.dart';
import 'package:afghan_cosmos/provider/them_mode.dart';
import 'package:afghan_cosmos/repo/auth_repo.dart';
import 'package:afghan_cosmos/screens/main_screen.dart';
import 'package:afghan_cosmos/theme/theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final auth = AuthRepository();
  await auth.signInAnonymously();
  runApp(const ProviderScope(child: MyApp()));
}

//! main page
class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    return MaterialApp(
      theme: TAppTheme.lightTheme,
      darkTheme: TAppTheme.darkTheme,
      themeMode: themeMode,
      debugShowCheckedModeBanner: false,
      home: AnimatedTheme(
        data:
            themeMode == ThemeMode.light
                ? TAppTheme.lightTheme
                : TAppTheme.darkTheme,
        duration: const Duration(milliseconds: 500),

        child: MainScreen(),
      ),
    );
  }
}
