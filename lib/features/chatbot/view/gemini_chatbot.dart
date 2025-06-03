import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:translation_app/features/chatbot/bloc/chatbot_bloc.dart';
import 'package:translation_app/features/chatbot/bloc/chatbot_event.dart';
import 'package:translation_app/features/chatbot/bloc/chatbot_state.dart';

class GeminiChatbotView extends StatelessWidget {
  const GeminiChatbotView({super.key});
  @override
  Widget build(BuildContext context) {
    final TextEditingController promptController = TextEditingController();
    final ScrollController scrollController = ScrollController();
    void scrollToBottom(int itemCount) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (scrollController.hasClients && itemCount > 0) {
          scrollController.animateTo(
            scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    }
    void sendMessage() {
      final message = promptController.text;
      if (message.trim().isNotEmpty) {
        context.read<ChatBloc>().add(SendMessageEvent(message));
        promptController.clear();
      }
    }
    return Column(
        children: [
          Expanded(
            child: BlocConsumer<ChatBloc, ChatState>(
              listener: (context, state) {
                if (state is ChatError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error: ${state.errorMessage}'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
                if (state is ChatLoaded || state is ChatLoading) {
                  scrollToBottom(state.messages.length);
                }
              },
              builder: (context, state) {
                if (state is ChatInitial && state.messages.isEmpty) {
                  return const Center(child: Text('Start chatting!'));
                }
                return ListView.builder(
                  controller: scrollController,
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  itemCount: state.messages.length + (state is ChatLoading ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (state is ChatLoading && index == state.messages.length) {
                      return _buildLoadingIndicator();
                    }
                    final message = state.messages[index];
                    return _buildMessageBubble(
                      context: context,
                      isPromt: message.isPromt,
                      message: message.message,
                      date: DateFormat("hh:mm a").format(message.time),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: promptController,
                    style: const TextStyle(color: Colors.black, fontSize: 18),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide(color: Colors.grey.shade400),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 2),
                      ),
                      hintText: "Enter a prompt...",
                      contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    ),
                    onSubmitted: (_) => sendMessage(),
                    textInputAction: TextInputAction.send,
                  ),
                ),
                const SizedBox(width: 10),
                BlocBuilder<ChatBloc, ChatState>(
                  builder: (context, state) {
                    final isLoading = state is ChatLoading;
                    return IconButton(
                      icon: const Icon(Icons.send, size: 30),
                      color: isLoading ? Colors.grey : Theme.of(context).primaryColor,
                      style: IconButton.styleFrom(
                          backgroundColor: isLoading ? Colors.grey.shade300 : Theme.of(context).primaryColorLight.withOpacity(0.2),
                          padding: const EdgeInsets.all(14)
                      ),
                      onPressed: isLoading ? null : sendMessage,
                      tooltip: 'Send Message',
                    );
                  },
                ),
              ],
            ),
          ),
        ],
    );
  }

  Widget _buildLoadingIndicator() {
    return const Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2)
            ),
            SizedBox(width: 10),
            Text("Typing...", style: TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageBubble({
    required BuildContext context,
    required final bool isPromt,
    required String message,
    required String date,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      margin: const EdgeInsets.symmetric(vertical: 5).copyWith(
        left: isPromt ? 60 : 10,
        right: isPromt ? 10 : 60,
      ),
      decoration: BoxDecoration(
        color: isPromt ? Theme.of(context).primaryColor.withOpacity(0.8) : Colors.grey.shade300,
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(18),
          topRight: const Radius.circular(18),
          bottomLeft: isPromt ? const Radius.circular(18) : Radius.zero,
          bottomRight: isPromt ? Radius.zero : const Radius.circular(18),
        ),
      ),
      child: Column(
        crossAxisAlignment: isPromt ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          SelectableText(
            message,
            style: TextStyle(
              fontSize: 16,
              color: isPromt ? Colors.white : Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            date,
            style: TextStyle(
              fontSize: 10,
              color: isPromt ? Colors.white70 : Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}