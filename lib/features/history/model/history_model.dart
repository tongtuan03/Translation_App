import 'package:cloud_firestore/cloud_firestore.dart';

class HistoryModel {
  final String id;
  final String originalText;
  final String translatedText;
  final String fromLang;
  final String toLang;
  final String userId;
  final DateTime? timestamp;

  HistoryModel({
    required this.id,
    required this.originalText,
    required this.translatedText,
    required this.fromLang,
    required this.toLang,
    required this.userId,
    this.timestamp,
  });

  factory HistoryModel.fromMap(Map<String, dynamic> map, String id) {
    return HistoryModel(
      id: id,
      originalText: map['originalText'] ?? '',
      translatedText: map['translatedText'] ?? '',
      fromLang: map['fromLang'] ?? '',
      toLang: map['toLang'] ?? '',
      userId: map['userId'] ?? '',
      timestamp: map['timestamp'] is Timestamp
          ? (map['timestamp'] as Timestamp).toDate()
          : (map['timestamp'] ?? DateTime.now()),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'originalText': originalText,
      'translatedText': translatedText,
      'fromLang': fromLang,
      'toLang': toLang,
      'userId': userId,
      'timestamp': timestamp,
    };
  }
}