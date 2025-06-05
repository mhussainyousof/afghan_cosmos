import 'package:afghan_cosmos/provider/ui_state_providers.dart';
import 'package:flutter/foundation.dart' show debugPrint, immutable, kIsWeb;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
  
@immutable
class AuthRepository {
  final FirebaseAuth _firebaseAuth;


  AuthRepository({
    FirebaseAuth? firebaseAuth,

  })  : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  Future <void> signInAnonymously() async {
    try {
       if (_firebaseAuth.currentUser == null) {
        await _firebaseAuth.signInAnonymously();
      }
    } catch (e) {
      debugPrint('Anonymous sign-in error: $e');
    }
  }

  Future<void> signout(WidgetRef ref) async {
    ref.read(isLoadingProvider.notifier).state = true;
    try {
      if (!kIsWeb) {
        await _firebaseAuth.signOut();
      }
     
    } finally {
      ref.read(isLoadingProvider.notifier).state = false;
    }
  }
}