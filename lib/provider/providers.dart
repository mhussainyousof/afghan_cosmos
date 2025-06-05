import 'package:afghan_cosmos/repo/auth_repo.dart';
import 'package:afghan_cosmos/repo/chat_repo.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


final chatProvider = Provider((ref) => ChatRepository(cloudName: 'dqdl8nui0', uploadPreset: 'ShopEasee'));
final authProvider = Provider((ref) => AuthRepository());