import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../features/history/model/history_model.dart';

class TranslateHistoryService {
  final CollectionReference _historyRef =
  FirebaseFirestore.instance.collection('translation_history');

  Future<void> addHistory({
    required String originalText,
    required String translatedText,
    required String fromLang,
    required String toLang,
    required String userId,
  }) async {
    final history = HistoryModel(
      id: '',
      originalText: originalText,
      translatedText: translatedText,
      fromLang: fromLang,
      toLang: toLang,
      userId: userId,
      timestamp: DateTime.now(),
    );
    final data = history.toMap();
    data['timestamp'] = FieldValue.serverTimestamp();
    await _historyRef.add(data);
  }

  Future<List<HistoryModel>> getUserHistory(String userId) async {
    final snapshot = await _historyRef
        .where('userId', isEqualTo: userId)
        .orderBy('timestamp', descending: true)
        .get();
    return snapshot.docs
        .map((doc) => HistoryModel.fromMap(doc.data() as Map<String, dynamic>, doc.id))
        .toList();
  }

  Future<void> updateHistory(HistoryModel history) async {
    final data = history.toMap();
    if (data['timestamp'] is DateTime) {
      data['timestamp'] = Timestamp.fromDate(data['timestamp']);
    }
    await _historyRef.doc(history.id).update(data);
  }

  Future<void> deleteHistory(String id) async {
    await _historyRef.doc(id).delete();
  }
}