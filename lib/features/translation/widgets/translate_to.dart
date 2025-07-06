import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';

import '../../../data/services/text_to_speech_service.dart';

class TranslateTo extends StatefulWidget {
  final String translatedText;
  final String language;
  const TranslateTo({
    super.key,
    required this.translatedText,
    required this.language,
  });

  @override
  State<TranslateTo> createState() => _TranslateToState();
}

class _TranslateToState extends State<TranslateTo> {
  String _text = '';
  final TextToSpeechService _flutterTts = TextToSpeechService();

  @override
  void initState() {
    super.initState();
    _text = widget.translatedText;
  }
  @override
  void didUpdateWidget(covariant TranslateTo oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.translatedText != oldWidget.translatedText) {
      setState(() {
        _text = widget.translatedText;
      });
    }
  }

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text)).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Copied to clipboard')),
      );
    });
  }

  Future<void> _handleVolumeUpTap() async {
    await _flutterTts.setLanguage(widget.language);
    await _flutterTts.setSpeechRate(1);
    await _flutterTts.speak(_text);
  }

  void _handleClear() {
    setState(() {
      _text = '';
    });
  }

  @override
  void dispose() {
    _flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Text(
              _text,
              style: GoogleFonts.poppins(
                fontSize: 16.0,
                fontWeight: FontWeight.w300,
                color: const Color(0xFF000000),
              ),
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.only(top: 12.0),
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(
                color: const Color(0xFF6D1B7B).withOpacity(0.8),
                width: 0.2,
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (_text.isNotEmpty)
                GestureDetector(
                  onTap: _handleClear,
                  child: Icon(
                    Icons.clear,
                    color: Colors.grey.withOpacity(0.8),
                  ),
                ),
              const SizedBox(width: 8.0),
              GestureDetector(
                onTap: () => _copyToClipboard(_text),
                child: Icon(
                  Icons.copy_all_outlined,
                  color: const Color(0xFF6D1B7B).withOpacity(0.8),
                ),
              ),
              const SizedBox(width: 8.0),
              GestureDetector(
                onTap: _handleVolumeUpTap,
                child: Icon(
                  Icons.volume_up_outlined,
                  color: const Color(0xFF6D1B7B).withOpacity(0.8),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
