import 'package:http/http.dart' as http;

class CharityProvider {
  final String apiUrl = "URL";

  Future<String> getCharity(String tweet) async {
    String charity = "None";

    var response = await http.post(
      Uri.parse(apiUrl),
      body: {'tweet': tweet},
    );

    if (response.body.trim() != "") {
      charity = response.body.trim();
    }

    return charity;
  }
}
