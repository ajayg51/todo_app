import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_app/blocs/app_locale_block/app_locale_bloc.dart';
import 'package:todo_app/blocs/app_locale_block/app_locale_event.dart';
import 'package:todo_app/blocs/app_locale_block/app_locale_state.dart';
import 'package:todo_app/blocs/app_theme_block/theme_bloc.dart';
import 'package:todo_app/blocs/app_theme_block/theme_event.dart';
import 'package:todo_app/blocs/app_theme_block/theme_state.dart';
import 'package:todo_app/models/theme_model.dart';
import 'package:todo_app/utils/app_localization.dart';
import 'package:todo_app/utils/common_appbar.dart';
import 'package:todo_app/utils/extensions.dart';
import 'package:todo_app/widgets/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Future.delayed(const Duration(seconds: 3), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (ctx) => const SafeArea(child:  Scaffold(body: HomeScreen())),
          ),
        );
      });
    });
  }

  bool isLightMode() {
    Box<ThemeModel> hiveBox = Hive.box("theme");

    if (hiveBox.isNotEmpty) {
      final hiveBoxList = hiveBox.values.toList();
      if (!(hiveBoxList[0].isLightMode)) {
        return false;
      }
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    bool isLightTheme = isLightMode();

    return SafeArea(
      child: Scaffold(
        backgroundColor:
            isLightTheme ? Colors.white : const Color.fromARGB(255, 50, 49, 49),
        body: Column(
          children: [
            CommonAppBar(isLightTheme: isLightTheme),
            const Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedLogo(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AnimatedLogo extends StatefulWidget {
  const AnimatedLogo({super.key});
  @override
  State<AnimatedLogo> createState() => _AnimatedLogoState();
}

class _AnimatedLogoState extends State<AnimatedLogo>
    with TickerProviderStateMixin {
  late final AnimationController animationController;
  late final Animation<double> sizeAnimation;

  @override
  void initState() {
    super.initState();

    BlocProvider.of<ThemeBloc>(context).add(InitialThemeEvent());
    BlocProvider.of<AppLocaleBloc>(context).add(AppLocaleChangeInitialEvent());

    animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 400))
      ..repeat(reverse: true);

    sizeAnimation =
        Tween<double>(begin: 100, end: 300).animate(animationController);
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ThemeBloc, ThemeState>(
      bloc: BlocProvider.of<ThemeBloc>(context),
      listener: (_, state) {},
      builder: (_, state) {
        bool isLightTheme = true;
        if (state is AppThemeState) {
          isLightTheme = state.isLightTheme;
        }
        return AnimatedBuilder(
          animation: animationController,
          builder: (_, __) => Column(
            children: [
              Image.asset(
                "assets/splash_screen_logo.png",
                width: sizeAnimation.value,
                height: sizeAnimation.value,
                color: isLightTheme ? null : Colors.white,
              ),
              12.verticalSpace,
              BlocConsumer<AppLocaleBloc, LocaleState>(
                bloc: BlocProvider.of<AppLocaleBloc>(context),
                listener: (_, state) {},
                builder: (_, state) {
                  if (state is AppLocaleState) {
                    return Text(
                      AppLocalizations.translate("splash_screen_info"),
                      style: TextStyle(
                        fontSize: 22,
                        color: isLightTheme ? null : Colors.white,
                      ),
                    );
                  }
                  // return Text("splash screen init state");
                  return const SizedBox.shrink();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
