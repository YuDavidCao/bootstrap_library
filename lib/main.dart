import 'package:bootstrap_library/route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'pages.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
      overlays: [SystemUiOverlay.top]);  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'PubLib',
        theme: ThemeData(
          primarySwatch: const MaterialColor(0xFF517551, {
            50: Color(0xFF517551),
            100: Color(0xFF517551),
            200: Color(0xFF517551),
            300: Color(0xFF517551),
            400: Color(0xFF517551),
            500: Color(0xFF517551),
            600: Color(0xFF517551),
            700: Color(0xFF517551),
            800: Color(0xFF517551),
            900: Color(0xFF517551),
          }),
        ),
          home: const HomePage(),
          onGenerateRoute: RouteGenerator.generateRoute,
      ),
    );
  }
}
