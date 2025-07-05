// history_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/services/firebase_services/auth_service.dart';
import '../model/history_model.dart';
import 'history_event.dart';
import 'history_state.dart';
import '../../../data/services/firebase_services/translate_service.dart';

class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  final TranslateHistoryService _historyService= TranslateHistoryService();
  final AuthService _authService = AuthService();
  HistoryBloc() : super(HistoryInitial()) {
    on<LoadHistoryEvent>(_onLoadHistory);
    on<DeleteHistoryEvent>(_onDeleteHistory);
  }
  Future<void> _onLoadHistory(
      LoadHistoryEvent event, Emitter<HistoryState> emit) async {

    emit(HistoryLoading());
    try {
      final user = await _authService.getCurrentUser();
      if (user == null) {
        emit(HistoryError('User not authenticated.'));
        return;
      }
      final history = await _historyService.getUserHistory(user.uid);
      emit(HistoryLoaded(history));
    } catch (e) {
      print(e.toString());
      emit(HistoryError(e.toString()));
    }
  }
  Future<void> _onDeleteHistory(
      DeleteHistoryEvent event,
      Emitter<HistoryState> emit,
      ) async {
    try {
      await _historyService.deleteHistory(event.historyId);
      final user = await _authService.getCurrentUser();
      if (user == null) {
        emit(HistoryError('User not authenticated.'));
        return;
      }
      final List<HistoryModel> histories =
      await _historyService.getUserHistory(user.uid);
      emit(HistoryLoaded(histories));
    } catch (e) {
      emit(HistoryError('Lỗi khi xoá: $e'));
    }
  }
}
