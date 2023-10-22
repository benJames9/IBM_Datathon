import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CharityProvider {
  final String apiUrl = "http://127.0.0.1:5000/api";

  Future<InlineSpan?> getCharity(String tweet) async {
    String charity = "No Charity";

    var response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'text': tweet,
      }),
    );

    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      charity = jsonResponse['message'];
    }

    // Embed links in text
    if (charity != "No Charity") {
      List<String> urls = charity.split('\n');

      return TextSpan(children: [
        TextSpan(text: '${urls[0]}\n\n'),
        TextSpan(
          text: '${urls[1]}\n\n',
          style: const TextStyle(color: Colors.blue),
        ),
        TextSpan(
          text: '${urls[2]}\n\n',
          style: const TextStyle(color: Colors.blue),
        ),
        TextSpan(
          text: urls[3],
          style: const TextStyle(color: Colors.blue),
        ),
      ]);
    } else {
      return null;
    }
  }
}
