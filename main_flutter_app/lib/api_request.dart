import 'package:http/http.dart' as http;
import 'dart:convert';

// Define your global variables if needed
import 'globals.dart' as globals;

// Replace with your Gradio app link
const String gradioAppLink = 'https://huggingface.co/spaces/rrc0024/ladder-gradio-app';

// Function to send request to Gradio API
Future<String> getPrediction(String userInput) async {
  final Uri url = Uri.parse('$gradioAppLink/predict');
  String testResult = '';

  // Define the request body
  final Map<String, dynamic> requestBody = {
    'user_input': userInput
  };

  // Make the POST request
  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode(requestBody),
  );

  if (response.statusCode == 200) {
    // If the server returns a 200 OK response
    final Map<String, dynamic> result = jsonDecode(response.body);
    testResult = 'Result: $result';
    return testResult;
  } else {
    // If the server returns an error
    testResult = 'Failed to get prediction. Status code: ${response.statusCode}';
    return testResult;
  }
}

Future<String> main () async {
  String pred;
  pred = await getPrediction('Say hello to my new friend, ${globals.sampleResponse}');
  return pred;
}

var sampleResult = main();