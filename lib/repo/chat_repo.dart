import 'package:afghan_cosmos/cloudaniry/data/fire_base_storage_repo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import '/extensions/extensions.dart';
import '/models/message.dart';


@immutable
class ChatRepository {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  final String cloudName;
  final String uploadPreset;

  ChatRepository({
    required this.cloudName,
    required this.uploadPreset,
  });

Future sendTextMessage({
  required String textPrompt,
  required String apiKey,
}) async {
  try {
    final textModel = GenerativeModel(model: 'gemini-1.5-flash', apiKey: apiKey);
    final userId = _auth.currentUser!.uid;
    final sentMessageId = const Uuid().v4();

    // ذخیره پیام کاربر
    Message message = Message(
      id: sentMessageId,
      message: textPrompt,
      createdAt: DateTime.now(),
      isMine: true,
    );

    await _firestore
        .collection('conversations')
        .doc(userId)
        .collection('messages')
        .doc(sentMessageId)
        .set(message.toMap());

    // گرفتن صفحات سایت از فایراستور (کل محتواهای مرتبط)
    final sitePages = await _getRelevantSitePages(textPrompt, limit: 5);

    if (sitePages.isEmpty) {
      // اگر داده‌ای نداریم، مستقیم جواب پیش‌فرض بفرست
      final noDataResponse = "متاسفم، اطلاعات مرتبطی در دسترس نیست.";
      final receivedMessageId = const Uuid().v4();

      final responseMessage = Message(
        id: receivedMessageId,
        message: noDataResponse,
        createdAt: DateTime.now(),
        isMine: false,
      );

      await _firestore
          .collection('conversations')
          .doc(userId)
          .collection('messages')
          .doc(receivedMessageId)
          .set(responseMessage.toMap());

      return;
    }

    // ساختن یک متن واحد و کامل از محتواهای مرتبط
    final combinedContent = sitePages.map((doc) => "عنوان: ${doc['title']}\nمحتوا: ${doc['content']}").join("\n\n---\n\n");

    // ساختن محتوا برای مدل فقط با متن سایت و پرسش کاربر
    final content = [
      Content.text(combinedContent),
      Content.text("سوال: $textPrompt"),
    ];

    // فرستادن به Gemini
    final response = await textModel.generateContent(content);
    final responseText = response.text ?? '';

    final receivedMessageId = const Uuid().v4();

    // ذخیره پاسخ مدل
    final responseMessage = Message(
      id: receivedMessageId,
      message: responseText,
      createdAt: DateTime.now(),
      isMine: false,
    );

    await _firestore
        .collection('conversations')
        .doc(userId)
        .collection('messages')
        .doc(receivedMessageId)
        .set(responseMessage.toMap());

  } catch (e) {
    throw Exception(e.toString());
  }
}

  //! گرفتن پیام‌های اخیر چت
  Future<List<Message>> _getRecentMessages(String userId, {int limit = 10}) async {
    final snapshot = await _firestore
        .collection('conversations')
        .doc(userId)
        .collection('messages')
        .orderBy('createdAt', descending: true)
        .limit(limit)
        .get();

    return snapshot.docs.map((doc) => Message.fromMap(doc.data())).toList().reversed.toList();
  }

  //! گرفتن صفحات مرتبط از Firestore
 Future<List<Map<String, dynamic>>> _getRelevantSitePages(String query, {int limit = 3}) async {
  final snapshot = await _firestore
      .collection("afghancosmos_data")
      .doc("pages")
      .collection("items")
      .limit(100) // بیشتر بگیر
      .get();

  final docs = snapshot.docs.map((doc) => doc.data()).toList();

  // مرتب سازی بر اساس شباهت به عنوان و محتوا
  docs.sort((a, b) {
    final aScoreTitle = _similarity(query.toLowerCase(), a['title'].toString().toLowerCase());
    final bScoreTitle = _similarity(query.toLowerCase(), b['title'].toString().toLowerCase());

    final aScoreContent = _similarity(query.toLowerCase(), a['content'].toString().toLowerCase());
    final bScoreContent = _similarity(query.toLowerCase(), b['content'].toString().toLowerCase());

    final aScore = aScoreTitle + aScoreContent;
    final bScore = bScoreTitle + bScoreContent;

    return bScore.compareTo(aScore);
  });

  return docs.take(limit).toList();
}


  //! تابع ساده تشخیص شباهت (تعداد کلمات مشترک)
  int _similarity(String a, String b) {
    final aWords = a.split(' ').toSet();
    final bWords = b.split(' ').toSet();
    return aWords.intersection(bWords).length;
  }
}



// Future sendMessage({
//     required String apiKey,
//     required XFile? image,
//     required String promptText,
//   }) async {
//     final userId = _auth.currentUser!.uid;
//     final sentMessageId = const Uuid().v4();

//     final textModel = GenerativeModel(model: 'gemini-2.5-pro', apiKey: apiKey);
//     final imageModel = GenerativeModel(model: 'gemini-1.5-flash', apiKey: apiKey);

//     Message message = Message(
//       id: sentMessageId,
//       message: promptText,
//       createdAt: DateTime.now(),
//       isMine: true,
//     );

//     if (image != null) {
//       final downloadUrl = await StorageRepository(
//         cloudName: cloudName,
//         uploadPreset: uploadPreset,
//       ).saveImageToStorage(
//         image: image,
//         messageId: sentMessageId,
//       );
//       message = message.copyWith(imageUrl: downloadUrl);
//     }

//     // Save user message
//     await _firestore
//         .collection('conversations')
//         .doc(userId)
//         .collection('messages')
//         .doc(sentMessageId)
//         .set(message.toMap());

//     try {
//       final recentMessages = await _getRecentMessages(userId);
//       final contentHistory = recentMessages.map((m) => Content.text(m.message)).toList();

//       late GenerateContentResponse response;

//       if (image == null) {
//         contentHistory.add(Content.text(promptText));
//         response = await textModel.generateContent(contentHistory);
//       } else {
//         final imageBytes = await image.readAsBytes();
//         final mimeType = image.getMimeTypeFromExtension();
//         final imagePart = DataPart(mimeType, imageBytes);
//         contentHistory.add(Content.multi([
//           TextPart(promptText),
//           imagePart,
//         ]));
//         response = await imageModel.generateContent(contentHistory);
//       }

//       final responseText = response.text;
//       final receivedMessageId = const Uuid().v4();

//       final responseMessage = Message(
//         id: receivedMessageId,
//         message: responseText ?? '',
//         createdAt: DateTime.now(),
//         isMine: false,
//       );

//       await _firestore
//           .collection('conversations')
//           .doc(userId)
//           .collection('messages')
//           .doc(receivedMessageId)
//           .set(responseMessage.toMap());
//     } catch (e) {
//       throw Exception(e.toString());
//     }
//   }
