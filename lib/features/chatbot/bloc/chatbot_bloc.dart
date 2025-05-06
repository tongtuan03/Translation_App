import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:translation_app/features/chatbot/bloc/chatbot_event.dart';
import 'package:translation_app/features/chatbot/bloc/chatbot_state.dart';
import 'package:translation_app/features/chatbot/model.dart';


class ChatBloc extends Bloc<ChatEvent, ChatState> {
  late final GenerativeModel _model; // Sử dụng late final

  ChatBloc() : super(const ChatInitial()) {
    _initializeModel();
    on<SendMessageEvent>(_onSendMessage);
  }

  void _initializeModel() {
    final apiKey = dotenv.env['API_KEY'];
    if (apiKey == null || apiKey.isEmpty) {
      print('Lỗi: API_KEY không được tìm thấy trong file .env');
      throw Exception('API_KEY is missing or empty in .env file');
    }
    _model = GenerativeModel(model: "gemini-2.0-flash", apiKey: apiKey);
  }


  Future<void> _onSendMessage(SendMessageEvent event, Emitter<ChatState> emit) async {
    if (event.message.trim().isEmpty) return;
    final List<ModelMessage> currentMessages = List.from(state.messages);
    final userMessage = ModelMessage(
      isPromt: true,
      message: event.message,
      time: DateTime.now(),
    );
    currentMessages.add(userMessage);
    emit(ChatLoading(messages: currentMessages));
    try {
      final content = [Content.text(event.message)];
      final chat = _model.startChat(
          history: _buildChatHistory(currentMessages.where((m) => m != userMessage).toList())
      );
      final response = await chat.sendMessage(content.first);
      final aiResponseText = response.text;
      if (aiResponseText == null || aiResponseText.isEmpty) {
        emit(ChatError(errorMessage: "AI did not return a response.", messages: currentMessages));
      } else {
        final aiMessage = ModelMessage(
          isPromt: false,
          message: aiResponseText,
          time: DateTime.now(),
        );
        final updatedMessages = List<ModelMessage>.from(currentMessages)..add(aiMessage);
        emit(ChatLoaded(messages: updatedMessages));
      }
    } catch (e) {
      print("Lỗi khi gọi Gemini API: $e");
      emit(ChatError(errorMessage: "Error generating response: ${e.toString()}", messages: currentMessages));
    }
  }

  List<Content> _buildChatHistory(List<ModelMessage> historyMessages) {
    return historyMessages.map((msg) {
      final role = msg.isPromt ? 'user' : 'model';
      return Content(role, [TextPart(msg.message)]);
    }).toList();
  }
}