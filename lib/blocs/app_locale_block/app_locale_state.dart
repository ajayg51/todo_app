abstract class LocaleState {}

class AppLocaleDummyState extends LocaleState {}

class AppLocaleState extends LocaleState {
  final bool isEnglish;
  AppLocaleState({required this.isEnglish});
}
