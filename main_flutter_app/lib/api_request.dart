import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:logging/logging.dart';

// Define your global variables if needed
import 'globals.dart' as globals;

// Replace with your Gradio app link
//const String gradioAppLink = 'https://huggingface.co/spaces/rrc0024/ladder-gradio-app';
const String gradioAppLink = 'http://127.0.0.1:7860';

void main () {
 // Configure logging
  Logger.root.level = Level.ALL; // Set log level
  Logger.root.onRecord.listen((record) {
  print('${record.level.name}: ${record.time}: ${record.message}');
  });
  final logger = globals.logger;
  logger.info('Info message'); // Info level
}

// Function to send request to Gradio API
void getPrediction(String userInput) async {
  final Uri url = Uri.parse('$gradioAppLink/predict');
  String testResult = '';

  // Define the request body
  final Map<String, dynamic> requestBody = {
    'user_input': userInput,
  };

  // Make the POST request
  final response = await http.post(
    url,
    headers: <String, String>{'Content-Type': 'application/json'},
    body: jsonEncode(requestBody),
  );

  if (response.statusCode == 200) {
    // If the server returns a 200 OK response
    final Map<String, dynamic> result = jsonDecode(response.body);
    testResult = 'Result: $result';
    globals.sampleResult = testResult;
    globals.logger.info(globals.sampleResult);
  } else {
    // If the server returns an error
    testResult = 'Failed to get prediction. Status code: ${response.statusCode}';
    globals.sampleResult = testResult;
    globals.logger.info(globals.sampleResult);
  }
}