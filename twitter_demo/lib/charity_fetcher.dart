import 'dart:convert';
import 'package:http/http.dart' as http;

class CharityProvider {
  final String apiUrl = "http://127.0.0.1:5000/api";

  Future<String> getCharity(String tweet) async {
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

    return charity;
  }
}
