import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatbotInputBox extends StatelessWidget {
  final VoidCallback? onSend;
  final FocusNode focusNode = FocusNode();
  final TextEditingController controller = TextEditingController();

  ChatbotInputBox({
    super.key,
    this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 8.w, right: 8.w, bottom: 8.h),
      child: Container(
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(10)),
          width: MediaQuery.of(context).size.width,
          height: 40.h,
          child: TextField(
            controller: controller,
            minLines: 1,
            maxLines: 6,
            cursorColor: Theme.of(context).colorScheme.inversePrimary,
            textInputAction: TextInputAction.newline,
            keyboardType: TextInputType.multiline,
            decoration: InputDecoration(
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
                hintText: 'Message',
                border: InputBorder.none,
                suffixIcon: GestureDetector(
                  onTap: () {
                    if (controller.text == '') {
                      focusNode.unfocus();
                    } else {
                      onSend?.call();
                    }
                  },
                  child: const Icon(
                    Icons.send_rounded,
                    color: Colors.blue,
                  ),
                )),
            onTapOutside: (event) => focusNode.unfocus(),
            onSubmitted: (searchedText) {
              if (searchedText == '') {
                focusNode.unfocus();
              } else {
                onSend?.call();
              }
            },
          )),
    );

    // return Card(
    //   margin: const EdgeInsets.all(8),
    //   child: Row(
    //     crossAxisAlignment: CrossAxisAlignment.end,
    //     children: [
    //       Expanded(
    //           child: TextField(
    //         controller: controller,
    //         minLines: 1,
    //         maxLines: 6,
    //         cursorColor: Theme.of(context).colorScheme.inversePrimary,
    //         textInputAction: TextInputAction.newline,
    //         keyboardType: TextInputType.multiline,
    //         decoration: const InputDecoration(
    //           contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 4),
    //           hintText: 'Message',
    //           border: InputBorder.none,
    //         ),
    //         onTapOutside: (event) =>
    //             FocusManager.instance.primaryFocus?.unfocus(),
    //       )),
    //       Padding(
    //         padding: const EdgeInsets.all(4),
    //         child: GestureDetector(
    //           onTap: onSend,
    //           child: Icon(Icons.send, color: Colors.blue),
    //         ),
    //       )
    //     ],
    //   ),
    // );
  }
}
