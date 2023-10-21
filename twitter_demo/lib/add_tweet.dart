import 'package:flutter/material.dart';

class InputTweet extends StatefulWidget {
  InputTweet({super.key});

  final TextEditingController controller = TextEditingController();

  @override
  State<StatefulWidget> createState() => _InputTweetState();

  String getText() {
    return controller.text;
  }

  void resetText() {
    controller.clear();
  }
}

class _InputTweetState extends State<InputTweet> {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: TextField(
        controller: widget.controller,
        keyboardType: TextInputType.multiline,
        maxLines: 5,
        decoration: const InputDecoration(
          hintText: 'Enter your tweet',
          border: OutlineInputBorder(),
        ),
      ),
    ));
  }
}
