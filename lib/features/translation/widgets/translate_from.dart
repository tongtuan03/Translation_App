import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_tts/flutter_tts.dart';

import '../../../data/services/text_to_speech_service.dart';

class TranslateFrom extends StatefulWidget {
  final TextEditingController controller;
  final String language;

  const TranslateFrom(
      {super.key, required this.controller, required this.language});

  @override
  State<TranslateFrom> createState() => _TranslateFromState();
}

class _TranslateFromState extends State<TranslateFrom> {
  int _wordCount = 0;
  final int _wordLimit = 50;
  final TextToSpeechService _flutterTts = TextToSpeechService();

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_updateWordCount);
  }

  void _updateWordCount() {
    final text = widget.controller.text;
    setState(() {
      _wordCount = _countWords(text);
      if (_wordCount > _wordLimit) {
        // Truncate the text if word limit is exceeded
        widget.controller.value = widget.controller.value.copyWith(
          text: _truncateTextToWordLimit(text, _wordLimit),
          selection: TextSelection.fromPosition(
            TextPosition(offset: widget.controller.text.length),
          ),
        );
        _wordCount = _wordLimit;
      }
    });
  }

  int _countWords(String text) {
    if (text.isEmpty) {
      return 0;
    }
    final words = text.trim().split(RegExp(r'\s+'));
    return words.length;
  }

  String _truncateTextToWordLimit(String text, int wordLimit) {
    final words = text.trim().split(RegExp(r'\s+'));
    if (words.length <= wordLimit) {
      return text;
    }
    return words.take(wordLimit).join(' ');
  }

  Future<void> _handleVolumeUpTap() async {
    final text = widget.controller.text;
    await _flutterTts.setLanguage(widget.language);
    await _flutterTts.setSpeechRate(0.5);
    await _flutterTts.speak(text);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_updateWordCount);
    widget.controller.dispose();
    _flutterTts.stop();
    super.dispose();
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [

          Expanded(
            child: TextFormField(
              controller: widget.controller,
              maxLines: 6,
              decoration: InputDecoration(
                hintText: 'Have something to translate?',
                hintStyle: GoogleFonts.poppins(
                  fontSize: 28.0,
                  color: const Color(0xFF6D1B7B).withOpacity(0.1),
                ),
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                labelStyle: GoogleFonts.poppins(
                  color: const Color(0xFF000000),
                  fontSize: 16.0,
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '$_wordCount/$_wordLimit words',
                  style: GoogleFonts.poppins(
                    fontSize: 12.0,
                    fontWeight: FontWeight.w300,
                    color: const Color(0xFF000000),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (widget.controller.text.isNotEmpty)
                      IconButton(
                        onPressed: () {
                          setState(() {
                            widget.controller.clear();
                            _wordCount = 0;
                          });
                        },
                        icon: const Icon(Icons.clear, color: Colors.grey),
                      ),
                    GestureDetector(
                      onTap: _handleVolumeUpTap,
                      child: Icon(
                        Icons.volume_up_outlined,
                        color: const Color(0xFF6D1B7B).withOpacity(0.8),
                      ),
                    ),
                  ],
                )

              ],
            ),
          ),
        ],
      ),
    );
  }


}
