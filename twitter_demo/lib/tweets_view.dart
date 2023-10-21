import 'package:flutter/material.dart';

class TweetsView extends StatelessWidget {
  const TweetsView({super.key, required this.tweets});
  final List<Widget> tweets;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: tweets,
    );
  }
}
