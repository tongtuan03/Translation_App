import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ExpandableText extends StatelessWidget {
  final String text;

  const ExpandableText(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: GoogleFonts.poppins(
        fontSize: 12,
        fontWeight: FontWeight.w300,
        color: Colors.black,
      ),
    );
  }
}
