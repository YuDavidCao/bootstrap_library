import 'package:flutter/material.dart';
import '../constants.dart';

class IconTextButton extends StatelessWidget {
  final String iconDescriptionText;
  final String currentPageName;
  final String targetPageName;
  final String iconTooltip;
  final IconData iconData;
  final bool isSubPage;
  final double textSize;
  const IconTextButton(
      {super.key,
      required this.iconDescriptionText,
      required this.currentPageName,
      required this.targetPageName,
      required this.iconTooltip,
      required this.iconData,
      this.isSubPage = false,
      this.textSize = 10});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: globalMarginPadding,
        ),
        IconButton(
          tooltip: iconTooltip,
          icon: Icon(
            iconData,
            color: thirtyUIColor,
          ),
          onPressed: () {
            if (isSubPage) {
              Navigator.pop(context);
              if (ModalRoute.of(context)?.settings.name != '/$targetPageName') {
                Navigator.of(context).pushReplacementNamed(
                  '/$targetPageName',
                );
              }
            } else {
              if (targetPageName != currentPageName) {
                Navigator.of(context).pushReplacementNamed(
                  '/$targetPageName',
                );
              }
            }
          },
        ),
        Text(
          iconDescriptionText,
          style: TextStyle(fontSize: textSize, color: thirtyUIColor),
        )
      ],
    );
  }
}
