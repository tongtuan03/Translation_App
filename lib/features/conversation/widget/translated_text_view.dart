import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TranslatedTextView extends StatelessWidget {
  final String translatedText;
  final bool isFlip;

  const TranslatedTextView({
    super.key,
    required this.translatedText,
    this.isFlip = false,
  });

  @override
  Widget build(BuildContext context) {
    final double lineHeight = 18.0 * 1.2; // fontSize * height
    final double maxHeight = lineHeight * 4;

    return Container(
      padding: const EdgeInsets.all(4),
      // decoration: BoxDecoration(
      //   border: Border.all(
      //     color: Colors.black54,
      //     width: 1.0,
      //   ),
      //   borderRadius: BorderRadius.circular(10),
      //   color: Colors.white,
      // ),
      child: Transform.rotate(
        angle: isFlip ? 3.14 : 0,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: maxHeight,
          ),
          child: SingleChildScrollView(
            child: Text(
              translatedText.isEmpty ? 'Bản dịch' : translatedText,
              style: GoogleFonts.poppins(
                fontSize: 18.0,
                color: const Color(0xFF685B6A).withOpacity(0.7),
                height: 1.2,
              ),
            ),
          ),
        ),
      ),
    );
  }
}