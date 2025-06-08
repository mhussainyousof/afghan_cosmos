import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:uuid/uuid.dart';
import '/models/message.dart';

@immutable
class ChatRepository {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  

  final String cloudName;
  final String uploadPreset;

  ChatRepository({required this.cloudName, required this.uploadPreset});

  Future sendTextMessage({
    required String textPrompt,
    required String apiKey,
  }) async {
    try {
      final textModel = GenerativeModel(
        model: 'gemini-1.5-flash',
        apiKey: apiKey,
      );
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

      final sitePages = await _getRelevantSitePages(textPrompt, limit: 5);

      if (sitePages.isEmpty) {
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

      

     final messagesSnapshot = await FirebaseFirestore.instance
    .collection('conversations')
    .doc(userId)
    .collection('messages')
    .orderBy('createdAt', descending: false) // تغییر به صعودی برای ترتیب صحیح
    .limit(10)
    .get();

final history = messagesSnapshot.docs
    .map((doc) {
      final data = doc.data();
      final isMine = data['isMine'] ?? false;
      final text = data['message'] ?? '';
      return isMine ? "User: $text" : "Assistant: $text";
    })
    .join('\n\n'); 


      final combinedContent = sitePages
          .map((doc) => "عنوان: ${doc['title']}\nمحتوا: ${doc['content']}")
          .join("\n\n---\n\n");

      final content = [
        Content.text("""
You are a kind, professional, and helpful assistant representing the Afghan Cosmos team. 
Your tone should be formal but friendly and easy to understand. 
Always reply in the same language the user used.
Respond as if you are part of the Afghan Cosmos support team, not as an outsider.
Important rules:
1. Do not greet the user unless they greet you first and you must give warm and smiling answers.
2. Keep your responses concise and to the point.
3. Use the context provided to answer questions accurately.

${history.isNotEmpty ? "Conversation history:\n$history\n\n" : ""}
${combinedContent.isNotEmpty ? "Relevant information:\n$combinedContent\n\n" : ""}
Current user message: $textPrompt
"""),
      ];

      final response = await textModel.generateContent(content);
      final responseText = response.text ?? '';

      final receivedMessageId = const Uuid().v4();

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

  Future<List<Map<String, dynamic>>> _getRelevantSitePages(
    String query, {
    int limit = 3,
  }) async {
    final snapshot =
        await _firestore
            .collection("afghancosmos_data")
            .doc("pages")
            .collection("items")
            .limit(100)
            .get();

    final docs = snapshot.docs.map((doc) => doc.data()).toList();

    docs.sort((a, b) {
      final aScoreTitle = _similarity(
        query.toLowerCase(),
        a['title'].toString().toLowerCase(),
      );
      final bScoreTitle = _similarity(
        query.toLowerCase(),
        b['title'].toString().toLowerCase(),
      );

      final aScoreContent = _similarity(
        query.toLowerCase(),
        a['content'].toString().toLowerCase(),
      );
      final bScoreContent = _similarity(
        query.toLowerCase(),
        b['content'].toString().toLowerCase(),
      );

      final aScore = aScoreTitle + aScoreContent;
      final bScore = bScoreTitle + bScoreContent;

      return bScore.compareTo(aScore);
    });

    return docs.take(limit).toList();
  }

  int _similarity(String a, String b) {
    final aWords = a.split(' ').toSet();
    final bWords = b.split(' ').toSet();
    return aWords.intersection(bWords).length;
  }


  Future<void> sendDefaultWelcomeMessageIfNeeded() async {
  final userId = _auth.currentUser!.uid;

  final messagesSnapshot = await _firestore
      .collection('conversations')
      .doc(userId)
      .collection('messages')
      .limit(1)
      .get();

  if (messagesSnapshot.docs.isEmpty) {
    final messageId = const Uuid().v4();
    final welcomeMessage = Message(
      id: messageId,
      message: "Welcome to Afghan Cosmos. How can I help you today?",
      createdAt: DateTime.now(),
      isMine: false,
    );

    await _firestore
        .collection('conversations')
        .doc(userId)
        .collection('messages')
        .doc(messageId)
        .set(welcomeMessage.toMap());
  }
}

}






// import 'dart:convert';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/foundation.dart' show immutable;
// import 'package:google_generative_ai/google_generative_ai.dart';
// import 'package:http/http.dart' as http;
// import 'package:uuid/uuid.dart';
// import '/models/message.dart';

// @immutable
// class ChatRepository {
//   final _auth = FirebaseAuth.instance;
//   final _firestore = FirebaseFirestore.instance;
  

//   final String cloudName;
//   final String uploadPreset;

//   ChatRepository({required this.cloudName, required this.uploadPreset});

//  Future sendTextMessage({
//   required String textPrompt,
//   required String apiKey,
// }) async {
//   try {
//     final userId = _auth.currentUser!.uid;
//     final sentMessageId = const Uuid().v4();

//     // ذخیره پیام کاربر
//     Message message = Message(
//       id: sentMessageId,
//       message: textPrompt,
//       createdAt: DateTime.now(),
//       isMine: true,
//     );

//     await _firestore
//         .collection('conversations')
//         .doc(userId)
//         .collection('messages')
//         .doc(sentMessageId)
//         .set(message.toMap());

//     final sitePages = await _getRelevantSitePages(textPrompt, limit: 5);

//     if (sitePages.isEmpty) {
//       final noDataResponse = "متاسفم، اطلاعات مرتبطی در دسترس نیست.";
//       final receivedMessageId = const Uuid().v4();

//       final responseMessage = Message(
//         id: receivedMessageId,
//         message: noDataResponse,
//         createdAt: DateTime.now(),
//         isMine: false,
//       );

//       await _firestore
//           .collection('conversations')
//           .doc(userId)
//           .collection('messages')
//           .doc(receivedMessageId)
//           .set(responseMessage.toMap());

//       return;
//     }

//     final messagesSnapshot = await FirebaseFirestore.instance
//         .collection('conversations')
//         .doc(userId)
//         .collection('messages')
//         .orderBy('createdAt', descending: false)
//         .limit(10)
//         .get();

//     final history = messagesSnapshot.docs
//         .map((doc) {
//           final data = doc.data();
//           final isMine = data['isMine'] ?? false;
//           final text = data['message'] ?? '';
//           return isMine ? "User: $text" : "Assistant: $text";
//         })
//         .join('\n\n');

//     final combinedContent = sitePages
//         .map((doc) => "عنوان: ${doc['title']}\nمحتوا: ${doc['content']}")
//         .join("\n\n---\n\n");

//     final prompt = """
// You are a kind, professional, and helpful assistant representing the Afghan Cosmos team. 
// Your tone should be formal but friendly and easy to understand. 
// Always reply in the same language the user used.
// Respond as if you are part of the Afghan Cosmos support team, not as an outsider.
// Important rules:
// 1. Do not greet the user unless they greet you first.
// 2. Keep your responses concise and to the point.
// 3. Use the context provided to answer questions accurately.

// ${history.isNotEmpty ? "Conversation history:\n$history\n\n" : ""}
// ${combinedContent.isNotEmpty ? "Relevant information:\n$combinedContent\n\n" : ""}
// Current user message: $textPrompt
// """;

//     // ارسال درخواست به سرور Railway
//     final response = await http.post(
//       Uri.parse('https://nodejs-production-7d428.up.railway.app/chat'),
//       headers: {'Content-Type': 'application/json'},
//       body: jsonEncode({'message': prompt}),
//     );

//     if (response.statusCode == 200) {
//       final responseData = jsonDecode(response.body);
//       final responseText = responseData['reply'] ?? '';

//       final receivedMessageId = const Uuid().v4();

//       final responseMessage = Message(
//         id: receivedMessageId,
//         message: responseText,
//         createdAt: DateTime.now(),
//         isMine: false,
//       );

//       await _firestore
//           .collection('conversations')
//           .doc(userId)
//           .collection('messages')
//           .doc(receivedMessageId)
//           .set(responseMessage.toMap());
//     } else {
//       throw Exception('Failed to get response from server');
//     }
//   } catch (e) {
//     throw Exception(e.toString());
//   }
// }

//   Future<List<Map<String, dynamic>>> _getRelevantSitePages(
//     String query, {
//     int limit = 3,
//   }) async {
//     final snapshot =
//         await _firestore
//             .collection("afghancosmos_data")
//             .doc("pages")
//             .collection("items")
//             .limit(100)
//             .get();

//     final docs = snapshot.docs.map((doc) => doc.data()).toList();

//     docs.sort((a, b) {
//       final aScoreTitle = _similarity(
//         query.toLowerCase(),
//         a['title'].toString().toLowerCase(),
//       );
//       final bScoreTitle = _similarity(
//         query.toLowerCase(),
//         b['title'].toString().toLowerCase(),
//       );

//       final aScoreContent = _similarity(
//         query.toLowerCase(),
//         a['content'].toString().toLowerCase(),
//       );
//       final bScoreContent = _similarity(
//         query.toLowerCase(),
//         b['content'].toString().toLowerCase(),
//       );

//       final aScore = aScoreTitle + aScoreContent;
//       final bScore = bScoreTitle + bScoreContent;

//       return bScore.compareTo(aScore);
//     });

//     return docs.take(limit).toList();
//   }

//   int _similarity(String a, String b) {
//     final aWords = a.split(' ').toSet();
//     final bWords = b.split(' ').toSet();
//     return aWords.intersection(bWords).length;
//   }
// }
