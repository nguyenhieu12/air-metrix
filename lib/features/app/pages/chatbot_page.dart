import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatbotPage extends StatefulWidget {
  const ChatbotPage({super.key});

  @override
  State<ChatbotPage> createState() => _ChatbotPageState();
}

class _ChatbotPageState extends State<ChatbotPage> {
  final Gemini gemini = Gemini.instance;
  ChatUser currentUser = ChatUser(id: '0', firstName: 'You');
  ChatUser geminiUser = ChatUser(
    id: '1',
    firstName: 'Gemini',
  );

  List<ChatMessage> messages = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        leading: GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Icon(
              Icons.arrow_back,
              color: Colors.white,
              size: 25.w,
            )),
        centerTitle: true,
        title: const Text(
          'Chat with Gemini',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: _buildUI(),
    );
  }

  Widget _buildUI() {
    return DashChat(
      currentUser: currentUser,
      onSend: _sendMessage,
      messages: messages,
      messageOptions: const MessageOptions(
        currentUserTextColor: Colors.white,
        currentUserContainerColor: Colors.blue,
      ),
    );
  }

  void _sendMessage(ChatMessage chatMessage) {
    FocusManager.instance.primaryFocus?.unfocus;
    // chatMessage.isMarkdown = true;

    // for (int i = 0; i < messages.length; i++) {
    //   messages[i].isMarkdown = true;
    // }

    setState(() {
      messages = [chatMessage, ...messages];
    });

    try {
      String question = chatMessage.text;
      gemini.streamGenerateContent(question).listen((event) {
        ChatMessage? lastMessage = messages.firstOrNull;

        // lastMessage?.isMarkdown = true;

        if (lastMessage != null && lastMessage.user == geminiUser) {
          lastMessage = messages.removeAt(0);
          String response = event.content?.parts?.fold(
                  '', (previous, current) => '$previous ${current.text}') ??
              '';

          lastMessage.text += response;

          setState(() {
            messages = [lastMessage!, ...messages];
          });
        } else {
          String response = event.content?.parts?.fold(
                  '', (previous, current) => '$previous ${current.text}') ??
              '';

          ChatMessage message = ChatMessage(
              user: geminiUser,
              isMarkdown: true,
              createdAt: DateTime.now(),
              text: response);

          setState(() {
            messages = [message, ...messages];
          });
        }
      });
    } catch (e) {
      FocusManager.instance.primaryFocus?.unfocus;
      debugPrint(e.toString());
    }
  }
}
