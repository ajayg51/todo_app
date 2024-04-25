abstract class LocaleChangeEvent {}

class AppLocaleChangeInitialEvent extends LocaleChangeEvent {}

class AppLocaleChangeEvent extends LocaleChangeEvent {
  final bool isEnglish;
  AppLocaleChangeEvent({required this.isEnglish});
}
