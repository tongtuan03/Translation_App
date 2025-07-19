// lib/screens/chat_screen.dart
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart'; // Thay image_picker bằng file_picker
import 'package:flutter_chat_core/flutter_chat_core.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'dart:typed_data';

import '../../../data/services/chat_api_service.dart'; // Cần để sử dụng Uint8List

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _chatController = InMemoryChatController();
  final String _currentUserId = 'user';
  final String _otherUserId = 'gemini_ai';
  final ChatApiService _chatApiService = ChatApiService();
  Uint8List? _selectedImageBytes;
  PlatformFile? _selectedPlatformFile;

  @override
  void dispose() {
    _chatController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
      withData: true,
    );

    if (result != null && result.files.first.bytes != null) {
      setState(() {
        _selectedPlatformFile = result.files.first;
        _selectedImageBytes = result.files.first.bytes;
      });
    }
  }
  Future<void> _sendMessage(String text) async {
    if (text.isEmpty) {
      return;
    }
    _chatController.insertMessage(
      TextMessage(
        id: '${Random().nextInt(1000000) + 1}',
        authorId: _currentUserId,
        createdAt: DateTime.now().toUtc(),
        text: text,
      ),
    );
    try {
      String response;
      if (_selectedPlatformFile != null) {
        response = await _chatApiService.chatWithImage(
          _selectedPlatformFile!,
          text,
        );
      } else {
        response = await _chatApiService.chat(
          text,
        );
      }

      _chatController.insertMessage(
        TextMessage(
          id: '${Random().nextInt(1000000) + 1}',
          authorId: _otherUserId,
          createdAt: DateTime.now().toUtc(),
          text: response,
        ),
      );
      setState(() {
        _selectedImageBytes = null; // Xóa ảnh hiển thị
        _selectedPlatformFile = null; // Xóa PlatformFile đã gửi
      });
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          if (_selectedImageBytes != null && _selectedPlatformFile != null)
            Container(
              margin: const EdgeInsets.all(8),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                border: Border.all(color: Colors.blueAccent),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Image.memory(
                    _selectedImageBytes!,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _selectedPlatformFile!.name,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.red),
                    onPressed: () {
                      setState(() {
                        _selectedPlatformFile = null;
                        _selectedImageBytes = null;
                      });
                    },
                  ),
                ],
              ),
            ),
          Expanded(
            child: Chat(
              chatController: _chatController,
              currentUserId: _currentUserId,
              onAttachmentTap: _pickImage,
              onMessageSend: (text) {
                _sendMessage(text);
              },
              resolveUser: (id) async {
                if (id == _currentUserId) {
                  return const User(id: 'user1', name: 'Bạn');
                } else if (id == _otherUserId) {
                  return const User(id: 'gemini_ai', name: 'Gemini AI');
                }
                return User(id: id, name: 'Người dùng khác');
              },
            ),
          ),
        ],
      ),
    );
  }
}