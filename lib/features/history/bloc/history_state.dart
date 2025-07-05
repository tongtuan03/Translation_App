import '../../../features/history/model/history_model.dart';

abstract class HistoryState {}

class HistoryInitial extends HistoryState {}

class HistoryLoading extends HistoryState {}

class HistoryLoaded extends HistoryState {
  final List<HistoryModel> history;
  HistoryLoaded(this.history);
}

class HistoryError extends HistoryState {
  final String message;
  HistoryError(this.message);
}