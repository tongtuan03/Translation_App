// lib/screens/chat_screen.dart
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart'; // Thay image_picker bằng file_picker
import 'dart:typed_data';

import '../../../data/services/chat_api_service.dart'; // Cần để sử dụng Uint8List

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ChatApiService _chatApiService = ChatApiService();
  String _chatResponse = '';

  Uint8List? _selectedImageBytes; // Để hiển thị ảnh
  PlatformFile? _selectedPlatformFile; // Để gửi đi

  Future<void> _pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );

    if (result != null) {
      PlatformFile pickedFile = result.files.first;
      setState(() {
        _selectedImageBytes = pickedFile.bytes;
        _selectedPlatformFile = pickedFile;
      });
    }
  }

  Future<void> _sendMessage() async {
    if (_messageController.text.isEmpty && _selectedPlatformFile == null) {
      setState(() {
        _chatResponse = 'Please enter a message or select an image.';
      });
      return;
    }

    try {
      String response;
      if (_selectedPlatformFile != null) {
        response = await _chatApiService.chatWithImage(
          _selectedPlatformFile!,
          _messageController.text,
        );
      } else {
        response = await _chatApiService.chat(
          _messageController.text,
        );
      }
      setState(() {
        _chatResponse = response;
      });
      _messageController.clear();
      setState(() {
        _selectedImageBytes = null; // Xóa ảnh hiển thị
        _selectedPlatformFile = null; // Xóa PlatformFile đã gửi
      });
    } catch (e) {
      setState(() {
        _chatResponse = 'Error: ${e.toString()}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Text(_chatResponse),
              ),
            ),
            _selectedImageBytes != null
                ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.memory(_selectedImageBytes!, height: 100),
            )
                : const SizedBox.shrink(),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: 'Enter your message',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.image),
                  onPressed: _pickImage,
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}