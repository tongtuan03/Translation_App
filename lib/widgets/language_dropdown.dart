import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:translation_app/models/language_model.dart';

import '../utils/convert_country_name.dart';

class LanguageDropdown extends StatefulWidget {
  final ValueChanged<String?> onLanguageChanged;
  final String? selectedLanguages;
  final List<Language> languageData;

  const LanguageDropdown(
      {super.key,
      required this.onLanguageChanged,
      required this.selectedLanguages,
      required this.languageData});

  @override
  State<LanguageDropdown> createState() => _LanguageDropdownState();
}

class _LanguageDropdownState extends State<LanguageDropdown> {

  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0),
          color: const Color(0xFFFFFFFF),
          border: Border.all(
            color: const Color(0xFF6D1B7B).withOpacity(0.8),
            width: 0.1,
          ),
        ),
        child: DropdownButton2<String>(
          isExpanded: true,
          hint: Text(
            'Select Language',
            style: GoogleFonts.poppins(
              fontSize: 12  ,
              fontWeight: FontWeight.w300,
              color: Colors.black,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            softWrap: false,
          ),
          value: widget.selectedLanguages,
          items: widget.languageData
              .map((item) => DropdownMenuItem<String>(
                    value: item.languageId,
                    child: Text(
                      item.languageName,
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.w300,
                        color: Colors.black,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      softWrap: false,
                    ),
                  ))
              .toList(),
          onChanged: widget.onLanguageChanged,
          dropdownSearchData: DropdownSearchData(
            searchController: searchController,
            searchInnerWidgetHeight: 50,
            searchInnerWidget: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: searchController,
                decoration: const InputDecoration(
                  isDense: true,
                  hintText: 'Search...',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            searchMatchFn: (item, searchValue) {
              final textWidget = item.child as Text;  
              final textValue = textWidget.data ?? '';
              return textValue.toLowerCase().contains(searchValue.toLowerCase());
            },
          ),
          dropdownStyleData: DropdownStyleData(
            maxHeight: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
          ),
          buttonStyleData: const ButtonStyleData(
            // padding: EdgeInsets.symmetric(horizontal: 16),

          ),
        ));
  }
}
