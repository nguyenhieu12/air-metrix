import 'package:envi_metrix/widgets/chatbot_input_box.dart';
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
  final controller = TextEditingController();
  final gemini = Gemini.instance;
  bool _loading = false;

  bool get loading => _loading;

  set loading(bool set) => setState(() => _loading = set);
  final List<Content> chats = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
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
      body: DecoratedBox(
        decoration: BoxDecoration(color: Colors.black.withOpacity(0.93)),
        child: Column(
          children: [
            Expanded(
                child: chats.isNotEmpty
                    ? Align(
                        alignment: Alignment.bottomCenter,
                        child: SingleChildScrollView(
                          reverse: true,
                          child: ListView.builder(
                            itemBuilder: chatItem,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: chats.length,
                            reverse: false,
                          ),
                        ),
                      )
                    : Center(
                        child: Text(
                        'Chat something',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.w,
                            fontWeight: FontWeight.w300),
                      ))),
            if (loading) const CircularProgressIndicator(),
            ChatbotInputBox(
              onSend: () {
                final searchedText = controller.text;
                chats.add(
                    Content(role: 'user', parts: [Parts(text: searchedText)]));
                controller.clear();
                loading = true;

                gemini.streamChat(chats).listen((value) {
                  loading = false;
                  setState(() {
                    if (chats.isNotEmpty &&
                        chats.last.role == value.content?.role) {
                      chats.last.parts!.last.text =
                          '${chats.last.parts!.last.text}${value.output}';
                    } else {
                      chats.add(Content(
                          role: 'model', parts: [Parts(text: value.output)]));
                    }
                  });
                });

                // if (controller.text.isNotEmpty) {
                //   final searchedText = controller.text;
                //   chats.add(Content(
                //       role: 'user', parts: [Parts(text: searchedText)]));
                //   controller.clear();
                //   loading = true;

                //   gemini.streamChat(chats).listen((value) {
                //     loading = false;
                //     setState(() {
                //       if (chats.isNotEmpty &&
                //           chats.last.role == value.content?.role) {
                //         chats.last.parts!.last.text =
                //             '${chats.last.parts!.last.text}${value.output}';
                //       } else {
                //         chats.add(Content(
                //             role: 'model', parts: [Parts(text: value.output)]));
                //       }
                //     });
                //   });
                // } else {
                //   FocusManager.instance.rootScope.unfocus();
                // }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget chatItem(BuildContext context, int index) {
    final Content content = chats[index];

    return Padding(
      padding: EdgeInsets.only(left: 8.w, right: 8.w, bottom: 4.h),
      child: Card(
        elevation: 0,
        color: content.role == 'model'
            ? Colors.blueAccent.shade400.withOpacity(0.95)
            : Colors.white.withOpacity(0.95),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                content.role == 'model' ? 'Gemini AI' : 'User',
                style: TextStyle(
                    fontSize: 16.w,
                    fontWeight: FontWeight.w500,
                    color:
                        content.role == 'model' ? Colors.white : Colors.black),
              ),
              Markdown(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                data:
                    content.parts?.lastOrNull?.text ?? 'cannot generate data!',
                styleSheet: MarkdownStyleSheet(
                  p: TextStyle(
                    fontSize: 14.5.w,
                    color:
                        content.role == 'model' ? Colors.white : Colors.black,
                  ),
                  listBullet: TextStyle(
                      color: content.role == 'model'
                          ? Colors.white
                          : Colors.black),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
