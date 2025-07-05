import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../widgets/ExpandableText.dart';
import '../model/history_model.dart';

class HistoryItem extends StatelessWidget {
  final HistoryModel item;
  final VoidCallback onDelete;
  const HistoryItem({super.key, required this.item, required this.onDelete});
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'From: ${item.fromLang}',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: onDelete,
                ),
              ],
            ),
            ExpandableText(item.originalText),
            const SizedBox(height: 4),
            Text(
              'To: ${item.toLang}',
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
            ExpandableText(item.translatedText),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

}
