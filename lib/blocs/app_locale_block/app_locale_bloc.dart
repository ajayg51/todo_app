import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_app/blocs/app_locale_block/app_locale_event.dart';
import 'package:todo_app/blocs/app_locale_block/app_locale_state.dart';
import 'package:todo_app/models/locale_model.dart';
import 'package:todo_app/utils/app_localization.dart';

class AppLocaleBloc extends Bloc<LocaleChangeEvent, LocaleState> {
  AppLocaleBloc() : super(AppLocaleDummyState()) {
    Box<LocaleModel> hiveBox;

    hiveBox = Hive.box("locale");

    on<LocaleChangeEvent>((event, emit) async {
      
      if (event is AppLocaleChangeInitialEvent) {
        final localeList = hiveBox.values.toList();
        if (localeList.isNotEmpty) {
          String langCode = localeList[0].langCode.toString();
          await AppLocalizations.setLanguageCode(langCode: langCode);
          if (langCode == "en") {
            emit(AppLocaleState(isEnglish: true));
          } else {
            emit(AppLocaleState(isEnglish: false));
          }
        } else {
          await AppLocalizations.setLanguageCode(langCode: "en");
          emit(AppLocaleState(isEnglish: true));
        }
      }

      if (event is AppLocaleChangeEvent) {
        debugPrint("Applocale 0");

        hiveBox.clear();

        if (event.isEnglish) {
          hiveBox.put(0, LocaleModel(langCode: "en"));
          await AppLocalizations.setLanguageCode(langCode: "en");
        } else {
          hiveBox.put(0, LocaleModel(langCode: "hi"));
          await AppLocalizations.setLanguageCode(langCode: "hi");
        }
        emit(AppLocaleState(isEnglish: event.isEnglish));
      }
    });
  }
}
