class Language {
  final String languageId;
  final String languageName;

  Language({required this.languageId, required this.languageName});

  factory Language.fromMap(Map<String, dynamic> map) {
    return Language(
      languageId: map['languageId'] ?? '',
      languageName: map['languageName'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'languageId': languageId,
      'languageName': languageName,
    };
  }
}
