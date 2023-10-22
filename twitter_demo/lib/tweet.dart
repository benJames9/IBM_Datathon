import 'package:flutter/material.dart';

class Tweet extends StatelessWidget {
  final String text;
  InlineSpan? charity;
  String user;
  String userName;

  Tweet(this.text, this.user, this.userName, {super.key, this.charity});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: const Icon(Icons.account_circle),
          title: Text(user),
          subtitle: Text(userName),
        ),
        ListTile(
          title: Text(text),
          trailing: charity == null ? null : CharityWidget(charity!),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
        ),
        const Divider(),
      ],
    );
  }
}

class CharityWidget extends StatelessWidget {
  final InlineSpan message;

  const CharityWidget(this.message, {super.key});

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      richMessage: message,
      decoration: const BoxDecoration(color: Color.fromRGBO(0, 0, 0, 0.9)),
      child: const Icon(Icons.info),
    );
  }
}
