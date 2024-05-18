import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:envi_metrix/features/chatbot/cubits/chatbot_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatbotPage extends StatefulWidget {
  const ChatbotPage({super.key, required this.chatbotCubit});

  final ChatbotCubit chatbotCubit;

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
      messages: widget.chatbotCubit.messages,
      messageOptions: const MessageOptions(
        currentUserTextColor: Colors.white,
        currentUserContainerColor: Colors.blue,
      ),
    );
  }

  void _sendMessage(ChatMessage chatMessage) {
    FocusManager.instance.primaryFocus?.unfocus;

    setState(() {
      widget.chatbotCubit.messages = [chatMessage, ...widget.chatbotCubit.messages];
    });

    try {
      String question = chatMessage.text;
      gemini.streamGenerateContent(question).listen((event) {
        ChatMessage? lastMessage = widget.chatbotCubit.messages.firstOrNull;

        // lastMessage?.isMarkdown = true;

        if (lastMessage != null && lastMessage.user == geminiUser) {
          lastMessage = widget.chatbotCubit.messages.removeAt(0);
          String response = event.content?.parts?.fold(
                  '', (previous, current) => '$previous ${current.text}') ??
              '';

          lastMessage.text += response;

          setState(() {
            widget.chatbotCubit.messages = [lastMessage!, ...widget.chatbotCubit.messages];
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
            widget.chatbotCubit.messages = [message, ...widget.chatbotCubit.messages];
          });
        }
      });
    } catch (e) {
      FocusManager.instance.primaryFocus?.unfocus;
      debugPrint(e.toString());
    }
  }
}
