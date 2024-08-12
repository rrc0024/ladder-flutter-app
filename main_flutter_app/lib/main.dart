import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ChatGPT Gradio Broker Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ChatPage(),
    );
  }
}

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _controller = TextEditingController();
  String _response = '';
  bool _isLoading = false;

  final String apiEndpoint = 'http://192.168.1.33:7861/api/chat';

  Future<void> _sendRequest(String prompt) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse(apiEndpoint),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode({
          'data': [prompt]
        }), // Sending as array inside 'data' key
      );

      if (response.statusCode == 200) {
        // Assuming the response is a list and we want to display the first item
        List<dynamic> responseData = json.decode(response.body)['data'];
        setState(() {
          _response =
              responseData.isNotEmpty ? responseData[0] : 'No response data';
        });
      } else {
        print('Response Body: ${response.body}');
        setState(() {
          _response = 'Error: ${response.statusCode} ${response.reasonPhrase}';
        });
      }
    } catch (e) {
      setState(() {
        _response = 'Error: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _sendUserInput() {
    String userInput = _controller.text.trim();
    if (userInput.isNotEmpty) {
      _sendRequest(userInput);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ChatGPT Gradio Broker Demo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Enter your question',
              ),
              onSubmitted: (value) {
                _sendUserInput();
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isLoading ? null : _sendUserInput,
              child: Text('Send'),
            ),
            SizedBox(height: 20),
            _isLoading ? CircularProgressIndicator() : Text(_response),
          ],
        ),
      ),
    );
  }
}
