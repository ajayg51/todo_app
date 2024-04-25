import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/blocs/app_locale_block/app_locale_bloc.dart';
import 'package:todo_app/blocs/app_locale_block/app_locale_event.dart';
import 'package:todo_app/blocs/app_locale_block/app_locale_state.dart';
import 'package:todo_app/blocs/app_theme_block/theme_bloc.dart';
import 'package:todo_app/blocs/app_theme_block/theme_event.dart';
import 'package:todo_app/utils/extensions.dart';
import 'package:todo_app/utils/separator.dart';

class CommonAppBar extends StatelessWidget {
  const CommonAppBar({
    super.key,
    required this.isLightTheme,
  });
  final bool isLightTheme;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          child: Row(
            children: [
              Image.asset(
                "assets/the_pet_nest_logo.png",
                width: 100,
              ),
              6.horizontalSpace,
              Expanded(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    AppLocaleChangeWidget(
                      isLightTheme: isLightTheme,
                    ),
                    12.horizontalSpace,
                    ThemeChangeWidget(
                      isLightTheme: isLightTheme,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const Separator(),
        36.verticalSpace,
      ],
    );
  }
}

class AppLocaleChangeWidget extends StatefulWidget {
  const AppLocaleChangeWidget({
    super.key,
    required this.isLightTheme,
  });
  final bool isLightTheme;
  @override
  State<AppLocaleChangeWidget> createState() => _AppLocaleChangeWidgetState();
}

class _AppLocaleChangeWidgetState extends State<AppLocaleChangeWidget> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppLocaleBloc, LocaleState>(
      bloc: BlocProvider.of<AppLocaleBloc>(context),
      listener: (_, state) {},
      builder: (_, state) {
        if (state is AppLocaleState) {
          return Row(
            children: [
              Text(
                "ही",
                style: TextStyle(
                  color: widget.isLightTheme ? null : Colors.white,
                ),
              ),
              Switch(
                value: state.isEnglish,
                thumbColor: MaterialStateProperty.resolveWith((states) {
                  if (states.contains(MaterialState.selected)) {
                    return widget.isLightTheme ? Colors.white : Colors.black;
                  }
                  return null;
                }),
                trackColor: MaterialStateProperty.resolveWith((states) {
                  if (states.contains(MaterialState.selected)) {
                    return widget.isLightTheme ? Colors.black : Colors.white;
                  }
                  return null;
                }),
                onChanged: (value) {
                  BlocProvider.of<AppLocaleBloc>(context).add(
                    AppLocaleChangeEvent(isEnglish: value),
                  );
                },
              ),
              Text(
                "En",
                style: TextStyle(
                  color: widget.isLightTheme ? null : Colors.white,
                ),
              ),
            ],
          );
        }
        // return const Text("App locale init state");
        return const SizedBox.shrink();
      },
    );
  }
}

class ThemeChangeWidget extends StatelessWidget {
  const ThemeChangeWidget({
    super.key,
    required this.isLightTheme,
  });

  final bool isLightTheme;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.nights_stay,
          color: isLightTheme ? null : Colors.white,
        ),
        Switch(
          value: isLightTheme,
          thumbColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.selected)) {
              return Colors.amber;
            }
            return null;
          }),
          trackColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.selected)) {
              return isLightTheme ? Colors.black : Colors.white;
            }
            return null;
          }),
          onChanged: (value) {
            if (value == true) {
              BlocProvider.of<ThemeBloc>(context).add(LightModeEvent());
            } else {
              BlocProvider.of<ThemeBloc>(context).add(DarkModeEvent());
            }
          },
        ),
        const Icon(
          Icons.sunny,
          color: Colors.amber,
        ),
      ],
    );
  }
}
