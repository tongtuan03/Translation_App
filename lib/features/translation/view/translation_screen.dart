import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../data/services/firebase_services/country_service.dart';
import '../../../models/language_model.dart';
import '../widgets/translate_from.dart';
import '../bloc/translation_bloc.dart';
import '../bloc/translation_event.dart';
import '../bloc/translation_state.dart';
import '../../../widgets/language_dropdown.dart';
import '../widgets/translate_to.dart';

class TranslationScreen extends StatefulWidget {
  const TranslationScreen({super.key});

  @override
  State<TranslationScreen> createState() => _TranslationScreenState();
}

class _TranslationScreenState extends State<TranslationScreen> {
  late TextEditingController controller;
  final List<Language> supportedLanguages = [
    Language(languageId: 'vi-VN', languageName: 'Tiếng Việt (Vietnamese)'),
    Language(languageId: 'en-US', languageName: 'Tiếng Anh (English - US)'),
    Language(languageId: 'en-GB', languageName: 'Tiếng Anh (English - UK)'),
    Language(languageId: 'fr-FR', languageName: 'Tiếng Pháp (French)'),
    Language(languageId: 'de-DE', languageName: 'Tiếng Đức (German)'),
    Language(languageId: 'es-ES', languageName: 'Tiếng Tây Ban Nha (Spanish)'),
    Language(languageId: 'it-IT', languageName: 'Tiếng Ý (Italian)'),
    Language(
        languageId: 'pt-BR',
        languageName: 'Tiếng Bồ Đào Nha (Brazilian Portuguese)'),
    Language(
        languageId: 'pt-PT', languageName: 'Tiếng Bồ Đào Nha (Portuguese)'),
    Language(languageId: 'ja-JP', languageName: 'Tiếng Nhật (Japanese)'),
    Language(languageId: 'ko-KR', languageName: 'Tiếng Hàn (Korean)'),
    Language(
        languageId: 'zh-CN',
        languageName: 'Tiếng Trung Giản Thể (Chinese Simplified)'),
    Language(
        languageId: 'zh-TW',
        languageName: 'Tiếng Trung Phồn Thể (Chinese Traditional)'),
    Language(languageId: 'ru-RU', languageName: 'Tiếng Nga (Russian)'),
    Language(languageId: 'hi-IN', languageName: 'Tiếng Hindi'),
    Language(languageId: 'th-TH', languageName: 'Tiếng Thái (Thai)'),
    Language(languageId: 'id-ID', languageName: 'Tiếng Indonesia'),
    Language(languageId: 'ms-MY', languageName: 'Tiếng Mã Lai (Malay)'),
    Language(languageId: 'tr-TR', languageName: 'Tiếng Thổ Nhĩ Kỳ (Turkish)'),
    Language(
        languageId: 'ar-SA',
        languageName: 'Tiếng Ả Rập (Arabic - Saudi Arabia)'),
    Language(languageId: 'pl-PL', languageName: 'Tiếng Ba Lan (Polish)'),
    Language(languageId: 'nl-NL', languageName: 'Tiếng Hà Lan (Dutch)'),
    Language(languageId: 'sv-SE', languageName: 'Tiếng Thụy Điển (Swedish)'),
    Language(languageId: 'fi-FI', languageName: 'Tiếng Phần Lan (Finnish)'),
    Language(languageId: 'no-NO', languageName: 'Tiếng Na Uy (Norwegian)'),
    Language(languageId: 'da-DK', languageName: 'Tiếng Đan Mạch (Danish)'),
    Language(languageId: 'cs-CZ', languageName: 'Tiếng Séc (Czech)'),
    Language(languageId: 'sk-SK', languageName: 'Tiếng Slovak'),
    Language(languageId: 'ro-RO', languageName: 'Tiếng Romania'),
    Language(languageId: 'hu-HU', languageName: 'Tiếng Hungary'),
    Language(languageId: 'he-IL', languageName: 'Tiếng Do Thái (Hebrew)'),
    Language(languageId: 'el-GR', languageName: 'Tiếng Hy Lạp (Greek)'),
    Language(languageId: 'uk-UA', languageName: 'Tiếng Ukraina (Ukrainian)'),
    Language(languageId: 'bn-BD', languageName: 'Tiếng Bengal (Bengali)'),
    Language(languageId: 'ta-IN', languageName: 'Tiếng Tamil'),
    Language(languageId: 'te-IN', languageName: 'Tiếng Telugu'),
    Language(languageId: 'mr-IN', languageName: 'Tiếng Marathi'),
    Language(languageId: 'gu-IN', languageName: 'Tiếng Gujarati'),
    Language(languageId: 'pa-IN', languageName: 'Tiếng Punjabi'),
    Language(languageId: 'ur-PK', languageName: 'Tiếng Urdu'),
    Language(languageId: 'fa-IR', languageName: 'Tiếng Ba Tư (Persian)'),
    Language(languageId: 'sr-RS', languageName: 'Tiếng Serbia'),
    Language(languageId: 'hr-HR', languageName: 'Tiếng Croatia'),
    Language(languageId: 'sl-SI', languageName: 'Tiếng Slovenia'),
    Language(languageId: 'bg-BG', languageName: 'Tiếng Bulgaria'),
    Language(languageId: 'lt-LT', languageName: 'Tiếng Litva (Lithuanian)'),
    Language(languageId: 'lv-LV', languageName: 'Tiếng Latvia'),
    Language(languageId: 'et-EE', languageName: 'Tiếng Estonia'),
    Language(languageId: 'km-KH', languageName: 'Tiếng Khmer'),
    Language(languageId: 'lo-LA', languageName: 'Tiếng Lào (Lao)'),
  ];

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
    CountryService sv = CountryService();
    // sv.deleteAllCountries();
    // sv.uploadCountriesToFirestore(supportedLanguages);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TranslationBloc, TranslationState>(
      builder: (context, state) {
        final bloc = context.read<TranslationBloc>();
        return SingleChildScrollView(
          padding: const EdgeInsets.only(top: 50.0, left: 16.0, right: 16.0),
          child: Column(
            children: [
              _buildHeader(),
              Row(
                children: [
                  Expanded(
                    child: LanguageDropdown(
                      languageData: state.languages,
                      selectedLanguages: state.languageFrom,
                      onLanguageChanged: (lang) =>
                          bloc.add(LanguageFromChanged(lang)),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.swap_horiz_rounded,
                        color: const Color(0xFF6D1B7B).withOpacity(0.3)),
                    onPressed: () => bloc.add(SwitchLanguages(controller.text)),
                  ),
                  Expanded(
                    child: LanguageDropdown(
                      languageData: state.languages,
                      selectedLanguages: state.languageTo,
                      onLanguageChanged: (lang) =>
                          bloc.add(LanguageToChanged(lang)),
                    ),
                  ),
                ],
              ),
              _buildLanguageLabel("Translate From", state.languageFrom),
              _buildInputBox(TranslateFrom(
                  controller: controller,
                  language: state.languageFrom ?? "vn-VN")),
              _buildLanguageLabel("Translate To", state.languageTo),
              _buildOutputBox(state),
              const SizedBox(height: 40.0),
              _buildTranslateButton(context, state),
            ],
          ),
        );
      },
      listenWhen: (previous, current) =>
          previous.inputText != current.inputText,
      listener: (context, state) {
        controller.text = state.inputText;
        controller.selection = TextSelection.fromPosition(
          TextPosition(offset: controller.text.length),
        );
      },
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("Text Translation",
              style: GoogleFonts.poppins(
                fontSize: 18.0,
                fontWeight: FontWeight.w300,
                color: Colors.black,
              )),
          const Icon(Icons.text_fields, color: Colors.black),
        ],
      ),
    );
  }

  Widget _buildLanguageLabel(String label, String? lang) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0, left: 10.0),
      child: Row(
        children: [
          RichText(
            text: TextSpan(
              style: GoogleFonts.poppins(height: 1.6),
              children: [
                TextSpan(
                  text: '$label ',
                  style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w300,
                      color: Colors.black),
                ),
                if (lang != null)
                  TextSpan(
                    text: lang,
                    style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputBox(Widget child) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: Container(
        height: 223.0,
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0),
          color: Colors.white,
          border: Border.all(
              color: const Color(0xFF6D1B7B).withOpacity(0.8), width: 0.2),
        ),
        child: child,
      ),
    );
  }

  Widget _buildOutputBox(TranslationState state) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: Container(
        height: 223.0,
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0),
          color: Colors.white,
          border: Border.all(
              color: const Color(0xFF6D1B7B).withOpacity(0.8), width: 0.2),
        ),
        child: state.isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  color: Color(0xFF6D1B7B),
                ),
              )
            : TranslateTo(
                translatedText: state.translatedText,
                language: state.languageTo ?? "",
              ),
      ),
    );
  }

  Widget _buildTranslateButton(BuildContext context, TranslationState state) {
    return GestureDetector(
      onTap: () {
        if (controller.text.isNotEmpty) {
          context
              .read<TranslationBloc>()
              .add(TranslateTextRequested(controller.text));
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          color: const Color(0xFF6D1B7B).withOpacity(0.8),
        ),
        child: Center(
          child: Text(
            'Translate',
            style: GoogleFonts.inter(
              fontSize: 14.0,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
