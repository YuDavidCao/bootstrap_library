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
                      targetPageName: "BookshelfPage",
                      iconTooltip: "Bookshelf",
                      currentPageName: onPageName,
                      iconData: Icons.book),
                  IconTextButton(
                      iconDescriptionText: "Profile",
                      targetPageName: "ProfilePage",
                      iconTooltip: "Profile",
                      currentPageName: onPageName,
                      iconData: Icons.person),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
