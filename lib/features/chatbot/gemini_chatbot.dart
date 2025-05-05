import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:intl/intl.dart';

import 'model.dart';

class GeminiChatbot extends StatefulWidget {
  const GeminiChatbot({super.key});

  @override
  State<GeminiChatbot> createState() => _GeminiChatbotState();
}

class _GeminiChatbotState extends State<GeminiChatbot> {
  TextEditingController promtController = TextEditingController();
  static var apiKey = dotenv.env['API_KEY'] ?? '';
  final model = GenerativeModel(model: "gemini-2.0-flash", apiKey: apiKey);
  final List<ModelMessage> promt = [];
  final isPromt = true;

  Future<void> sendMessage() async {
    final message = promtController.text;
    setState(() {
      promtController.clear();
      promt.add(
        ModelMessage(isPromt: true, message: message, time: DateTime.now()),
      );
    });
    final content = [Content.text(message)];
    final response = await model.generateContent(content);
    setState(() {
      promt.add(
        ModelMessage(
          isPromt: false,
          message: response.text ?? "",
          time: DateTime.now(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: promt.length,
              itemBuilder: (context, index) {
                final message = promt[index];
                return userPromt(
                  isPromt: message.isPromt,
                  message: message.message,
                  date: DateFormat("hh:mm a").format(message.time),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(25),
            child: Row(
              children: [
                Expanded(
                  flex: 20,
                  child: TextField(
                    controller: promtController,
                    style: const TextStyle(color: Colors.black, fontSize: 20),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      hintText: "Enter a promt here",
                    ),
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    sendMessage();
                  },
                  child: const CircleAvatar(
                    radius: 29,
                    backgroundColor: Colors.black,
                    child: Icon(Icons.send, color: Colors.white, size: 32),
                  ),
                ),
              ],
            ),
          ),
        ],
    );
  }

  Container userPromt({
    required final bool isPromt,
    required String message,
    required String date,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      margin: const EdgeInsets.symmetric(vertical: 15).copyWith(
          left: isPromt ? 80 : 15, right: isPromt ? 15 : 80),
      decoration: BoxDecoration(
        color: isPromt == true ? Colors.green : Colors.grey,
        borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(20),
            topRight: const Radius.circular(20),
            bottomLeft: isPromt ? const Radius.circular(20) : Radius.zero,
            bottomRight: isPromt?  Radius.zero:const Radius.circular(20),

        ),

      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //for promt and response
          Text(
            message,
            style: TextStyle(
              fontWeight: isPromt ? FontWeight.bold : FontWeight.normal,
              fontSize: 18,
              color: isPromt ? Colors.white : Colors.black,
            ),
          ),
          //for  promt and response time
          Text(
            date,
            style: TextStyle(
              fontSize: 14,
              color: isPromt ? Colors.white : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
