import 'dart:io';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:http_parser/http_parser.dart';

import '../../features/chat_v2/models/chat_request.dart';

class ChatApiService {
  final Dio _dio = Dio();
  final String _baseUrl = 'http://localhost:8080';

  ChatApiService() {
    _dio.options.connectTimeout = const Duration(seconds: 5);
    _dio.options.receiveTimeout = const Duration(seconds: 3);
  }

  Future<String> chat(String message, {String? userId}) async {
    try {
      final chatRequest = ChatRequest(message: message, userId: userId);
      final response = await _dio.post(
        '$_baseUrl/chat',
        data: chatRequest.toJson(),
        options: Options(headers: {'Content-Type': 'application/json'}),
      );
      if (response.statusCode == 200) {
        return response.data.toString();
      } else {
        throw Exception('Failed to chat: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in chat: $e');
      throw Exception('Failed to send chat message: $e');
    }
  }

  Future<String> chatWithImage(dynamic imageData, String message, {String? fileName}) async {
    try {
      FormData formData;
      String name = fileName ?? 'image.jpg';


      if (imageData is PlatformFile) {
        if (kIsWeb) {
          if (imageData.bytes == null) {
              throw Exception('File bytes are null for web upload.');
          }
          final type = imageData.extension ?? 'jpg';
          formData = FormData.fromMap({
            "file": MultipartFile.fromBytes(imageData.bytes!, filename: imageData.name,contentType:MediaType('image', type) ),
            "message": message,
          });
        } else {
          if (imageData.path == null) {
            throw Exception('File path is null for mobile upload.');
          }
          formData = FormData.fromMap({
            "file": await MultipartFile.fromFile(imageData.path!, filename: imageData.name),
            "message": message,
          });
        }
      }
      else if (imageData is File) {
        String filePath = imageData.path;
        name = fileName ?? filePath.split('/').last;
        formData = FormData.fromMap({
          "file": await MultipartFile.fromFile(filePath, filename: name),
          "message": message,
        });
      }
      else if (imageData is Uint8List) {
        name = fileName ?? 'image.jpg';
        formData = FormData.fromMap({
          "file": MultipartFile.fromBytes(imageData, filename: name),
          "message": message,
        });
      }
      else {
        throw Exception('Unsupported image data type. Expected PlatformFile, File, or Uint8List.');
      }

      final response = await _dio.post(
        '$_baseUrl/chat-with-image',
        data: formData,
        options: Options(headers: {'Content-Type': 'multipart/form-data'}),
      );

      if (response.statusCode == 200) {
        return response.data.toString();
      } else {
        throw Exception('Failed to chat with image: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in chatWithImage: $e');
      throw Exception('Failed to send image and message: $e');
    }
  }

}