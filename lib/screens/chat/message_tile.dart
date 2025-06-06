import 'package:afghan_cosmos/utils/helper/persion_fuction.dart';
import 'package:afghan_cosmos/utils/theme/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:iconsax/iconsax.dart';

import '/models/message.dart';

class MessageTile extends StatelessWidget {
  final Message message;
  final bool isOutgoing;

  const MessageTile({
    super.key,
    required this.message,
    required this.isOutgoing,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = isOutgoing ? TColors.textWhite : TColors.textPrimary;

    final align = isOutgoing ? Alignment.centerRight : Alignment.centerLeft;

    final avatar =
        isOutgoing
            ? const CircleAvatar(
              radius: 16,
              backgroundColor: Colors.white,
              child: Icon(Iconsax.user, color: Colors.blue),
            )
            : const CircleAvatar(
              radius: 18,
              backgroundImage: AssetImage('assets/icons/logo.png'),
              backgroundColor: TColors.primaryBackground,
            );

    return Align(
      alignment: align,
      child: Row(
        mainAxisAlignment:
            isOutgoing ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isOutgoing) avatar,
          if (!isOutgoing) const SizedBox(width: 4),

          Flexible(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.75,
              ),
              margin: const EdgeInsets.symmetric(vertical: 6),
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              decoration: BoxDecoration(
                gradient:
                    isOutgoing
                        ? LinearGradient(
                          colors: [TColors.primary, TColors.accent],
                          begin: Alignment.bottomRight,
                          end: Alignment.topLeft,
                        )
                        : const LinearGradient(
                          colors: [
                            TColors.lightContainer,
                            TColors.lightContainer,
                          ],
                        ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(isOutgoing ? 16 : 0),
                  topRight: Radius.circular(isOutgoing ? 0 : 16),
                  bottomLeft: const Radius.circular(16),
                  bottomRight: const Radius.circular(16),
                ),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 3,
                    color: Colors.black.withOpacity(0.05),
                    offset: const Offset(0, 1),
                  ),
                ],
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Directionality(
                    textDirection:
                        isPersianText(message.message)
                            ? TextDirection.rtl
                            : TextDirection.ltr,
                    child: GestureDetector(
                      onLongPress: () async {
                        final userId = FirebaseAuth.instance.currentUser!.uid;
                        await FirebaseFirestore.instance
                            .collection('conversations')
                            .doc(userId)
                            .collection('messages')
                            .doc(message.id)
                            .delete();
                      },

                      child: MarkdownBody(
                        data: message.message,
                        styleSheet: MarkdownStyleSheet(
                          p: TextStyle(
                            color: textColor,
                            fontSize: 16,
                            height: 1.4,
                            fontWeight: FontWeight.w400,
                          ),
                          strong: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: textColor,
                          ),
                          em: TextStyle(
                            fontStyle: FontStyle.italic,
                            color: textColor.withOpacity(0.7),
                          ),
                          code: TextStyle(
                            backgroundColor: Colors.grey.shade200,
                            color: Colors.deepPurple,
                            fontFamily: 'monospace',
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isOutgoing) const SizedBox(width: 4),
          if (isOutgoing) avatar,
        ],
      ),
    );
  }
}
