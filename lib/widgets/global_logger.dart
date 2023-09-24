import 'package:logger/logger.dart';

class GlobalLogger {
  static void log(Object? message) {
    var logger = Logger();
    logger.i(message.toString());
  }

  static void warn(Object? message) {
    var logger = Logger();
    logger.w(message.toString());
  }

  static void error(Object? message) {
    var logger = Logger();
    logger.e(message.toString());
  }
}
