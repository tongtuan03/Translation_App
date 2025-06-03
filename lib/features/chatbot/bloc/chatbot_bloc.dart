import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:translation_app/data/services/gemini_service.dart';
import 'package:translation_app/features/chatbot/bloc/chatbot_event.dart';
import 'package:translation_app/features/chatbot/bloc/chatbot_state.dart';

import '../model/model.dart';


class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final GeminiService _geminiService=GeminiService();
  ChatBloc() : super(const ChatInitial()) {
    on<SendMessageEvent>(_onSendMessage);
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
      final aiMessage = await _geminiService.sendMessage(
        message: event.message,
        previousMessages: currentMessages.where((m) => m != userMessage).toList(),
      );

      final updatedMessages = List<ModelMessage>.from(currentMessages)..add(aiMessage);
      emit(ChatLoaded(messages: updatedMessages));
    } catch (e) {
      emit(ChatError(
        errorMessage: "Error generating response: ${e.toString()}",
        messages: currentMessages,
      ));
    }
  }
}