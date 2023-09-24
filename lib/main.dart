import 'package:bootstrap_library/controller/user_state.dart';
import 'package:bootstrap_library/firebase_options.dart';
import 'package:bootstrap_library/pages/home_page/home_page.dart';
import 'package:bootstrap_library/pages/login_page.dart';
import 'package:bootstrap_library/route.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
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
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => UserState()),
        ],
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
          home: const LoginPage(),
          onGenerateRoute: RouteGenerator.generateRoute,
        ),
      ),
    );
  }
}
