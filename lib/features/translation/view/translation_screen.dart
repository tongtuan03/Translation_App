import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

import '../widgets/language_dropdown.dart';
import '../widgets/translate_from.dart';
import '../widgets/translate_to.dart';

class TranslationScreen extends StatefulWidget {
  const TranslationScreen({super.key});

  @override
  State<TranslationScreen> createState() => _TranslationScreenState();
}

class _TranslationScreenState extends State<TranslationScreen> {
  String? selectedCountryFrom;
  String? selectedCountryTo;
  TextEditingController controller = TextEditingController();
  String _translatedText = '';
  bool _loading = false;

  // Function to update the state of the slected langauge from
  void _handleLanguageChangeFrom(String? newCountry) {
    setState(() {
      selectedCountryFrom = newCountry;
    });
  }

  // Function to update the state of the slected langauge to
  void _handleLanguageChangeTo(String? newCountry) {
    setState(() {
      selectedCountryTo = newCountry;
    });
  }
  void _switchLanguage(){
    setState(() {
      final tmp = selectedCountryTo;
      selectedCountryTo = selectedCountryFrom;
      selectedCountryFrom=tmp;
    });
  }

  Future<void> _translateText() async {
    final apiKey = dotenv.env['API_KEY'];
    if (apiKey == null) {
      print('No API_KEY environment variable');
      return;
    }

    final inputText = controller.text;
    final fromLang = selectedCountryFrom;
    final toLang = selectedCountryTo;

    // Validation checks
    if (inputText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('What are you translating?')),
      );
      return;
    }

    if (fromLang == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('What language are you translating from?')),
      );
      return;
    }

    if (toLang == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('What language are you translating to?')),
      );
      return;
    }

    setState(() {
      _loading = true;
    });

    try {
      final model = GenerativeModel(model: 'gemini-2.0-flash', apiKey: apiKey);
      final content = [
        Content.text('Translate only "$inputText" from $fromLang to $toLang')
      ];
      final response = await model.generateContent(content);

      setState(() {
        _translatedText = response.text!;
      });

      print('$_translatedText');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to translate text')),
      );
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F0F0),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 50.0, left: 16.0, right: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 10.0),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: const Color(0xFF6D1B7B).withOpacity(0.8),
                      width: 0.2,
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Text translation
                    Text(
                      "Text Translation",
                      style: GoogleFonts.poppins(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w300,
                        color: const Color(0xFF000000),
                      ),
                    ),
                    const Icon(
                      Icons.text_fields,
                      color: Color(0xFF000000),
                      size: 24.0,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: LanguageDropdown(
                          onLanguageChanged: _handleLanguageChangeFrom,
                          selectedCountry: selectedCountryFrom,
                      ),
                    ),
                    GestureDetector(
                      onTap: _switchLanguage,
                      child: Icon(
                        Icons.swap_horiz_rounded,
                        color: const Color(0xFF6D1B7B).withOpacity(0.3),

                      ),
                    ),
                    Expanded(child: LanguageDropdown(onLanguageChanged: _handleLanguageChangeTo,selectedCountry: selectedCountryTo,)),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20.0, left: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        style: GoogleFonts.poppins(
                          height: 1.6,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text: 'Translate From ',
                            style: GoogleFonts.poppins(
                              fontSize: 14.0,
                              fontWeight: FontWeight.w300,
                              color: const Color(0xFF000000),
                            ),
                          ),
                          if (selectedCountryFrom != null)
                            TextSpan(
                              text: '$selectedCountryFrom',
                              style: GoogleFonts.poppins(
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF000000),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
        
              // Padding around the container for translate from
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 223.0,
                  padding: const EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.0),
                    color: const Color(0xFFFFFFFF),
                    border: Border.all(
                      color: const Color(0xFF6D1B7B).withOpacity(0.8),
                      width: 0.2,
                    ),
                  ),
                  child: TranslateFrom(controller: controller),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20.0, left: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        style: GoogleFonts.poppins(
                          height: 1.6,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text: 'Translate To ',
                            style: GoogleFonts.poppins(
                              fontSize: 14.0,
                              fontWeight: FontWeight.w300,
                              color: const Color(0xFF000000),
                            ),
                          ),
                          if (selectedCountryTo != null)
                            TextSpan(
                              text: '$selectedCountryTo',
                              style: GoogleFonts.poppins(
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF000000),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 223.0,
                  padding: const EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.0),
                    color: const Color(0xFFFFFFFF),
                    border: Border.all(
                      color: const Color(0xFF6D1B7B).withOpacity(0.8),
                      width: 0.2,
                    ),
                  ),
                  child: _loading
                      ? Center(
                          child: Container(
                            padding: const EdgeInsets.all(12.0),
                            height: 50.0,
                            width: 50.0,
                            decoration: BoxDecoration(
                              color: const Color(0xFF6D1B7B).withOpacity(0.8),
                              shape: BoxShape.circle,
                            ),
                            child: const CircularProgressIndicator(
                              color: Color(0xFFFFFFFF),
                            ),
                          ),
                        )
                      : TranslateTo(translatedText: _translatedText),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 50.0),
                child: GestureDetector(
                  onTap: _translateText,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 15.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      color: const Color(0xFF6D1B7B).withOpacity(0.8),
                    ),
                    child: Center(
                      // Submit text here
                      child: Text(
                        'Translate',
                        style: GoogleFonts.inter(
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFFFFFFFF),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          // Column ends here
        ),
      ),
    );
  }
}
