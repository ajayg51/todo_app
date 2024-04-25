import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_app/blocs/app_theme_block/theme_event.dart';
import 'package:todo_app/blocs/app_theme_block/theme_state.dart';
import 'package:todo_app/models/theme_model.dart';

class ThemeBloc extends Bloc<ThemeChangeEvent, ThemeState> {
  ThemeBloc() : super(DummyThemeState()) {
    on<ThemeChangeEvent>((event, emit) async {
      // !!Beware!!

      // final hiveBox = Hive.box("abcd") gives error

      Box<ThemeModel> hiveBox;

      hiveBox = Hive.box("theme");

      if (event is InitialThemeEvent) {
        final hiveBoxList = hiveBox.values.toList();
        // debugPrint("initial theme event 0");
        if (hiveBoxList.isNotEmpty) {
          // debugPrint("initial theme event 1");
          if (hiveBoxList[0].isLightMode) {
            // debugPrint("initial theme event 2");
            emit(AppThemeState(isLightTheme: true));
          }
          // debugPrint("initial theme event 3");
          emit(AppThemeState(isLightTheme: false));
        }
        emit(AppThemeState(isLightTheme: true));
      }

      if (event is DarkModeEvent) {
        debugPrint("DarkMode :: ");
        await hiveBox.clear();
        hiveBox.put(0, ThemeModel(isLightMode: false));
        emit(AppThemeState(isLightTheme: false));
      }

      if (event is LightModeEvent) {
        debugPrint("LightMode :: ");
        await hiveBox.clear();
        hiveBox.put(0, ThemeModel(isLightMode: true));
        emit(AppThemeState(isLightTheme: true));
      }
    });
  }
}
