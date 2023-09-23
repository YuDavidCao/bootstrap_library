import 'package:bootstrap_library/controller/user_state.dart';
import 'package:bootstrap_library/widgets/global_botton_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<UserState>(
      builder: (context, UserState userState, child) {
        return Scaffold(
          // appBar: AppBar(),
          body: const Column(
            children: [Text("hello")],
          ),
          bottomNavigationBar: const GlobalBottomAppBar(
              isSubPage: false, onPageName: "HomePage"),
        );
      },
    );
  }
}
