import 'package:flutter/material.dart';

class GeminiAi extends StatefulWidget {
  const GeminiAi({super.key});

  @override
  State<GeminiAi> createState() => _GeminiAiState();
}

class _GeminiAiState extends State<GeminiAi> {
  TextEditingController promptController = TextEditingController();
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
          Padding(
            padding: EdgeInsets.all(20),
            child: Row(
              children: [
                Expanded(
                  flex: 20,
                  child: TextField(
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
                  onTap: () {},
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
}
