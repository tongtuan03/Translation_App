// history_event.dart
abstract class HistoryEvent {}

class LoadHistoryEvent extends HistoryEvent {
  LoadHistoryEvent();
}
class DeleteHistoryEvent extends HistoryEvent {
  final String historyId;
  DeleteHistoryEvent(this.historyId);
}
