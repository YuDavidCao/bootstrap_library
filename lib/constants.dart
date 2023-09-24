import 'package:flutter/material.dart';

const double globalEdgePadding = 20.0;

const double globalMarginPadding = 10.0;

const double defaultBottomAppBarHeight = 76.0;

const int pageTransitionTime = 200;

const Color sixtyUIColor = Colors.white;

const Color thirtyUIColor = Color(0xFF517551);

const Color tenUIColor = Colors.amber;

const EdgeInsets globalMiddleWidgetPadding = EdgeInsets.fromLTRB(
    globalEdgePadding,
    globalMarginPadding,
    globalEdgePadding,
    globalMarginPadding);

RegExp emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

const LinearGradient linearGradientHolder = LinearGradient(
  begin: Alignment(0, -1),
  end: Alignment(0, 1),
  colors: [
    thirtyUIColor,
    tenUIColor
  ],
);
