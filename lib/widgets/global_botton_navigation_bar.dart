import 'package:firebase_auth/firebase_auth.dart';
import 'package:bootstrap_library/widgets/icon_text_button.dart';
import 'package:flutter/material.dart';
import '../constants.dart';

class GlobalBottomAppBar extends StatelessWidget {
  final bool isSubPage;
  final String onPageName;
  const GlobalBottomAppBar(
      {required this.isSubPage, required this.onPageName, super.key});

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      height: defaultBottomAppBarHeight + globalEdgePadding,
      child: SizedBox(
        height: defaultBottomAppBarHeight,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconTextButton(
                      iconDescriptionText: "Explore",
                      targetPageName: "HomePage",
                      iconTooltip: "Explore",
                      currentPageName: onPageName,
                      iconData: Icons.explore),
                  IconTextButton(
                      iconDescriptionText: "Bookshelf",
                      targetPageName: "BookShelfPage",
                      iconTooltip: "Bookshelf",
                      currentPageName: onPageName,
                      iconData: Icons.book),
                  Column(
                    children: [
                      const SizedBox(
                        height: globalMarginPadding,
                      ),
                      IconButton(
                        tooltip: "Log out",
                        icon: const Icon(
                          Icons.person,
                          color: thirtyUIColor,
                        ),
                        onPressed: () async {                          
                          await FirebaseAuth.instance.signOut();
                          if (context.mounted) {
                            Navigator.of(context).pushReplacementNamed(
                              '/LoginPage',
                            );
                          }
                        },
                      ),
                      const Text(
                        "Logout",
                        style: TextStyle(fontSize: 10, color: thirtyUIColor),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
