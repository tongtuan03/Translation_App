import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

import '../../features/chatbot/model/model.dart';

class GeminiService {
  late final GenerativeModel _model;

  GeminiService() {
    final apiKey = dotenv.env['API_KEY'];
    if (apiKey == null) {
      throw Exception('API_KEY not found in .env');
    }

    _model = GenerativeModel(
      model: 'gemini-2.0-flash',
      apiKey: apiKey,
    );
  }

  Future<String> translateText({
    required String text,
    required String fromLang,
    required String toLang,
  }) async {
    try {
      final content = [
        Content.text(
            'You are a professional translator. Please translate the following text from $fromLang to $toLang, preserving the original meaning, tone, and context. Understand idioms, cultural references, and conversational flow. Only return the translated text, without explanation:\n\n"$text"'
        )
      ];

      final response = await _model.generateContent(content);
      return response.text ?? '';
    } catch (e) {
      rethrow;
    }
  }

  Future<ModelMessage> sendMessage({
    required String message,
    required List<ModelMessage> previousMessages,
  }) async {
    final chat = _model.startChat(
      history: _buildChatHistory(
        previousMessages.where((m) => m.isPromt || !m.isPromt).toList(),
      ),
    );
    final response = await chat.sendMessage(Content.text(message));
    final aiText = response.text;
    if (aiText == null || aiText.isEmpty) {
      throw Exception("AI did not return a response.");
    }
    return ModelMessage(
      isPromt: false,
      message: aiText,
      time: DateTime.now(),
    );
  }
  List<Content> _buildChatHistory(List<ModelMessage> messages) {
    return messages.map((msg) {
      return Content.text(msg.message);
    }).toList();
  }
}
