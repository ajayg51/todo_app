import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:todo_app/blocs/app_locale_block/app_locale_bloc.dart';
import 'package:todo_app/blocs/app_theme_block/theme_bloc.dart';
import 'package:todo_app/blocs/home_screen_block/home_screen_bloc.dart';
import 'package:todo_app/models/locale_model.dart';
import 'package:todo_app/models/task_model.dart';
import 'package:todo_app/models/theme_model.dart';
import 'package:todo_app/utils/app_localization.dart';
import 'package:todo_app/utils/locale_adapter.dart';
import 'package:todo_app/utils/task_adapter.dart';
import 'package:todo_app/utils/theme_adapter.dart';
import 'package:todo_app/widgets/home_screen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Directory directory = await getApplicationDocumentsDirectory();
  
  Hive.registerAdapter<TaskModel>(TaskAdapter());
  Hive.registerAdapter<ThemeModel>(ThemeAdapter());
  Hive.registerAdapter<LocaleModel>(LocaleAdapter());


  await Hive.initFlutter('${directory.path} apk02');
  
  await Hive.openBox<TaskModel>("tasks");
  await Hive.openBox<ThemeModel>("theme");
  await Hive.openBox<LocaleModel>("locale");

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<TasksBloc>(
          create: (context) => TasksBloc(),
        ),
        BlocProvider<ThemeBloc>(
          create: (context) => ThemeBloc(),
        ),
        BlocProvider<AppLocaleBloc>(
          create: (context) => AppLocaleBloc(),
        ),
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        supportedLocales: [
          Locale("en", ""),
          Locale("hi", ""),
        ],
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        home: SafeArea(
          child: Scaffold(
            body: HomeScreen(),
          ),
        ),
      ),
    );
  }
}
