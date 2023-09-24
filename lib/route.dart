import 'package:bootstrap_library/constants.dart';
import 'package:bootstrap_library/model/book_summry.dart';
import 'package:bootstrap_library/pages/book_shelf_page/book_shelf_page.dart';
import 'package:bootstrap_library/pages/book_summary_page.dart';
import 'package:bootstrap_library/pages/home_page/home_page.dart';
import 'package:bootstrap_library/pages/login_page.dart';
import 'package:bootstrap_library/pages/read_page.dart';
import 'package:bootstrap_library/widgets/global_logger.dart';
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
      case '/ReadPage':
        List<dynamic> data = settings.arguments as List<dynamic>;
        return PageTransition(
          child: ReadPage(
            title: data[0],
            author: data[1],
          ),
          type: PageTransitionType.rightToLeft,
          duration: const Duration(milliseconds: pageTransitionTime),
          reverseDuration: const Duration(milliseconds: pageTransitionTime),
        );
      case '/BookSummaryPage':
        List<dynamic> data = settings.arguments as List<dynamic>;
        return PageTransition(
          child: BookSummaryPage(
            bookData: data[0],
          ),
          type: PageTransitionType.rightToLeft,
          duration: const Duration(milliseconds: pageTransitionTime),
          reverseDuration: const Duration(milliseconds: pageTransitionTime),
        );
      case '/BookShelfPage':        
        return PageTransition(
          child: const BookShelfPage(),
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
