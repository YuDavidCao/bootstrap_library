import 'package:bootstrap_library/constants.dart';
import 'package:bootstrap_library/pages/home_page.dart';
import 'package:bootstrap_library/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/HomePage':
        return PageTransition(
          child: const HomePage(),
          type: PageTransitionType.rightToLeft,
          duration: const Duration(milliseconds: pageTransitionTime),
          reverseDuration: const Duration(milliseconds: pageTransitionTime),
        );
      case '/LoginPage':
        return PageTransition(
          child: const LoginPage(),
          type: PageTransitionType.rightToLeft,
          duration: const Duration(milliseconds: pageTransitionTime),
          reverseDuration: const Duration(milliseconds: pageTransitionTime),
        );
      default:
        return PageTransition(
          child: const Placeholder(),
          type: PageTransitionType.rightToLeft,
          duration: const Duration(milliseconds: pageTransitionTime),
          reverseDuration: const Duration(milliseconds: pageTransitionTime),
        );
    }
  }
}
