import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_app/models/theme_model.dart';
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
            builder: (ctx) => const Scaffold(body:  HomeScreen()),
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
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedLogo(isLightTheme: isLightTheme),
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
  const AnimatedLogo({
    super.key,
    required this.isLightTheme,
  });
  final bool isLightTheme;
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
    return AnimatedBuilder(
      animation: animationController,
      builder: (_, __) => Column(
        children: [
          Image.asset(
            "assets/splash_screen_logo.png",
            width: sizeAnimation.value,
            height: sizeAnimation.value,
            color: !widget.isLightTheme ? Colors.white : null,
          ),
          12.verticalSpace,
          Text(
            "Todo App using BLoC",
            style: TextStyle(
              fontSize: 22,
              color: !widget.isLightTheme ? Colors.white : null,
            ),
          ),
        ],
      ),
    );
  }
}
