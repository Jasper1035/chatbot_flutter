import 'package:chatbot_flutter/model.dart';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:intl/intl.dart';

class GeminiAi extends StatefulWidget {
  const GeminiAi({super.key});

  @override
  State<GeminiAi> createState() => _GeminiAiState();
}

class _GeminiAiState extends State<GeminiAi> {
  TextEditingController promptController = TextEditingController();

  static const apiKey = '';
  final model = GenerativeModel(model: 'Gemini-Pro', apiKey: apiKey);

  final List<ModelMessage> prompt = [];

  Future<void> sendMessage() async {
    final message = promptController.text;
    //for prompt
    setState(() {
      prompt.add(
        ModelMessage(isPrompt: true, message: message, time: DateTime.now()),
      );
    });
    //for response

    final content = [Content.text(message)];
    final response = await model.generateContent(content);
    setState(() {
      prompt.add(
        ModelMessage(
          isPrompt: false,
          message: response.text ?? '',
          time: DateTime.now(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[200],
      appBar: AppBar(
        centerTitle: true,
        elevation: 3,
        backgroundColor: Colors.blue[300],
        title: Text('AI ChatBot'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: prompt.length,
              itemBuilder: (context, index) {
                final message = prompt[index];
                return userPrompt(
                  isPrompt: message.isPrompt,
                  message: message.message,
                  date: DateFormat('hh:mm a').format(message.time),
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(20),
            child: Row(
              children: [
                Expanded(
                  flex: 20,
                  child: TextField(
                    controller: promptController,
                    style: TextStyle(color: Colors.black, fontSize: 20),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      hintText: 'Enter a prompt here',
                    ),
                  ),
                ),
                // SizedBox(width: 20),
                Spacer(),
                GestureDetector(
                  onTap: () {
                    sendMessage();
                  },
                  child: CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.green,
                    child: Icon(Icons.send, color: Colors.white, size: 35),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Container userPrompt({
    required final bool isPrompt,
    required String message,
    required String date,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: isPrompt ? Colors.green : Colors.grey,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          //for prompt and response
          Text(
            message,
            style: TextStyle(
              fontWeight: isPrompt ? FontWeight.bold : FontWeight.normal,
              fontSize: 18,
              color: isPrompt ? Colors.white : Colors.black,
            ),
          ),
          //for prompt and response time
          Text(
            date,

            style: TextStyle(
              fontSize: 14,
              color: isPrompt ? Colors.white : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
