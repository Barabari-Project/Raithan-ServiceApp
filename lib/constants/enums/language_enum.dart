enum LanguageEnum{
  en,
  te,
  hi;

  static String fromString(String value) {
    switch (value) {
      case 'te':
        return LanguageEnum.te.label;
      case 'hi':
        return LanguageEnum.hi.label;
      default :
        return LanguageEnum.en.label;
    }
  }
}

extension LanguageEnumExtension on LanguageEnum {
  String get label {
    switch (this) {
      case LanguageEnum.te:
        return 'తెలుగు';
      case LanguageEnum.hi:
        return "हिन्दी";
      default :
        return "English";
    }
  }
}

