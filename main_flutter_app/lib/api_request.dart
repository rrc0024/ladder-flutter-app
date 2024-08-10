import 'package:http/http.dart' as http;
import 'dart:convert';

// Define your global variables if needed
import 'globals.dart' as globals;

// Replace with your Gradio app link
const String gradioAppLink = 'https://huggingface.co/spaces/rrc0024/ladder-gradio-app';

// Function to send request to Gradio API
Future<void> getPrediction(String userInput) async {
  final Uri url = Uri.parse('$gradioAppLink/predict');

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
    globals.sampleResult = 'Result: $result';
  } else {
    // If the server returns an error
    globals.sampleResult = 'Failed to get prediction. Status code: ${response.statusCode}';
  }
}

void main() {
  getPrediction('Say hello to my new friend, ${globals.sampleResponse}');
}