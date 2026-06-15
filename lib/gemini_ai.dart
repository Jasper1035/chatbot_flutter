import 'package:chatbot_flutter/model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/intl.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;

class GeminiAi extends StatefulWidget {
  const GeminiAi({super.key});

  @override
  State<GeminiAi> createState() => _GeminiAiState();
}

class _GeminiAiState extends State<GeminiAi> {
  TextEditingController promptController = TextEditingController();

  static final apiKey = dotenv.env['groq_api_key'];

  final List<ModelMessage> prompt = [];

  // Future<void> sendMessage() async {
  //   final message = promptController.text;
  //   //for prompt
  //   setState(() {
  //     prompt.add(
  //       ModelMessage(isPrompt: true, message: message, time: DateTime.now()),
  //     );
  //   });
  //   //for response

  //   final content = [Content.text(message)];
  //   final response = await model.generateContent(content);
  //   setState(() {
  //     prompt.add(
  //       ModelMessage(
  //         isPrompt: false,
  //         message: response.text ?? '',
  //         time: DateTime.now(),
  //       ),
  //     );
  //   });
  // }
  Future<void> sendMessage() async {
    final message = promptController.text.trim();

    if (message.isEmpty) return;

    setState(() {
      prompt.add(
        ModelMessage(isPrompt: true, message: message, time: DateTime.now()),
      );
    });

    promptController.clear();

    try {
      final response = await http.post(
        Uri.parse('https://api.groq.com/openai/v1/chat/completions'),
        headers: {
          'Authorization': 'Bearer $apiKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "model": "llama-3.1-8b-instant",
          "messages": [
            {"role": "user", "content": message},
          ],
        }),
      );

      final data = jsonDecode(response.body);

      final reply = data['choices'][0]['message']['content'];

      setState(() {
        prompt.add(
          ModelMessage(isPrompt: false, message: reply, time: DateTime.now()),
        );
      });
    } catch (e) {
      print("ERROR: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[200],
      appBar: AppBar(
        centerTitle: true,
        elevation: 3,
        backgroundColor: Colors.blue[300],
        title: const Text('AI ChatBot'),
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
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Expanded(
                  flex: 20,
                  child: TextField(
                    controller: promptController,
                    style: const TextStyle(color: Colors.black, fontSize: 20),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      hintText: 'Enter a prompt here',
                    ),
                  ),
                ),
                // SizedBox(width: 20),
                const Spacer(),
                GestureDetector(
                  onTap: () async {
                    await sendMessage();
                  },
                  child: const CircleAvatar(
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
      padding: const EdgeInsets.all(15),
      margin: const EdgeInsets.symmetric(
        vertical: 15,
      ).copyWith(left: isPrompt ? 80 : 15, right: isPrompt ? 15 : 80),
      decoration: BoxDecoration(
        color: isPrompt ? Colors.green : Colors.grey,
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(20),
          topRight: const Radius.circular(20),
          bottomLeft: isPrompt ? const Radius.circular(20) : Radius.zero,
          bottomRight: isPrompt ? Radius.zero : const Radius.circular(20),
        ),
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
