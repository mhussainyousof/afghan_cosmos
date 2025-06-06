import 'package:afghan_cosmos/provider/providers.dart';
import 'package:afghan_cosmos/screens/home/widget_messages_list.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';


class HomeScreen extends ConsumerStatefulWidget {
  final ScrollController scrollController;
  const HomeScreen({
    required this.scrollController,
    super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {


  late final TextEditingController _messageController;
  final apiKey = dotenv.env['API_KEY'] ?? '';
  late final ScrollController _scrollController;
  bool _showScrollToBottomBtn = false;
  bool _isSending = false;

  @override
  void initState() {
    _messageController = TextEditingController();
    _scrollController = ScrollController();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    _scrollController.addListener(() {
      final atBottom =
          _scrollController.offset <=
          _scrollController.position.minScrollExtent + 20;

      if (atBottom && _showScrollToBottomBtn) {
        setState(() => _showScrollToBottomBtn = false);
      } else if (!atBottom && !_showScrollToBottomBtn) {
        setState(() => _showScrollToBottomBtn = true);
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    
    return  SafeArea(
      child: Padding(
        
           padding: EdgeInsets.only(
            left: 10,
            right: 5,
            top: 12,
            bottom: MediaQuery.of(context).viewInsets.bottom ,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Message List
              Expanded(
                child: MessagesList(
                  scrollController: widget.scrollController,
                  userId: FirebaseAuth.instance.currentUser!.uid,
                ),
              ),
              
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 3,
                ),
              
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Row(
                  children: [
                    //! Message Text field
                    Expanded(
                      child: TextField(
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                        style: TextStyle(color: Colors.black87),
                        controller: _messageController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Ask Afghan Cosmos ...',
                          hintStyle: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade400,
                            fontStyle: FontStyle.italic,
                          ),
                         
                        ),
                      ),
                    ),
              
                    //! Send Button
                    IconButton(
                      onPressed: _isSending ? null : sendMessage,
                      icon:
                          _isSending
                              ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                              : const Icon(Iconsax.send_1, color: Colors.black,),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
    );
    
  }

  Future sendMessage() async {
    final message = _messageController.text.trim();

    if (message.isEmpty) return;
    setState(() {
      _isSending = true;
      _messageController.clear();
    });

    try {
      await ref
          .read(chatProvider)
          .sendTextMessage(textPrompt: message, apiKey: apiKey);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      setState(() {
        _isSending = false;
      });
    }
  }
}
