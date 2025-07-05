import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/history_bloc.dart';
import '../bloc/history_event.dart';
import '../bloc/history_state.dart';
import '../widgets/history_item.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  void initState() {
    super.initState();
    context.read<HistoryBloc>().add(LoadHistoryEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HistoryBloc, HistoryState>(
      builder: (context, state) {
        if (state is HistoryLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is HistoryLoaded) {
          final history = state.history;
          if (history.isEmpty) {
            return const Center(child: Text('No history found.'));
          }
          return ListView.builder(
            itemCount: history.length,
            itemBuilder: (context, index) {
              final item = history[index];
              return HistoryItem(item: item,onDelete: () {
                context.read<HistoryBloc>().add(DeleteHistoryEvent(item.id));
              },); // widget mới
            },
          );
        } else if (state is HistoryError) {
          return Center(child: Text(state.message));
        }
        return const SizedBox.shrink();
      },
    );
  }
}
