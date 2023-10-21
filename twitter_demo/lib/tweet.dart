import 'package:flutter/material.dart';

class Tweet extends StatelessWidget {
  final String text;
  String? charity;
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
  final String message;

  const CharityWidget(this.message, {super.key});

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: message,
      child: const Icon(Icons.info),
    );
  }
}
