import 'package:bootstrap_library/constants.dart';
import 'package:bootstrap_library/firebase/firebase_storage_service.dart';
import 'package:bootstrap_library/widgets/star_clipper.dart';
import 'package:bootstrap_library/widgets/start_border_painter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyBookWidget extends StatefulWidget {
  final DocumentSnapshot bookData;
  const MyBookWidget({super.key, required this.bookData});

  @override
  State<MyBookWidget> createState() => _MyBookWidgetState();
}

class _MyBookWidgetState extends State<MyBookWidget> {
  late double bookRating;
  late int roundedBookRating;

  @override
  void initState() {
    if (widget.bookData["totalReviewerCount"] == 0) {
      roundedBookRating = 0;
    } else {
      bookRating = (widget.bookData["totalReviewPoints"] /
          widget.bookData["totalReviewerCount"]);
      roundedBookRating = bookRating.round();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {
        Navigator.of(context)
            .pushNamed("/BookSummaryPage", arguments: [widget.bookData]);
      },
      child: Container(
        padding: globalMiddleWidgetPadding,
        margin: globalMiddleWidgetPadding,
        decoration: const BoxDecoration(
            color: thirtyUIColor,
            borderRadius: BorderRadius.all(Radius.circular(12))),
        height: 100,
        width: width / 2,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    ...[1, 2, 3, 4, 5].map((int index) {
                      return SizedBox(
                        height: 15,
                        width: 15,
                        child: ClipPath(
                          clipper: StarClipper(points: 5),
                          child: Container(
                            decoration: BoxDecoration(
                              color: (index <= roundedBookRating)
                                  ? Colors.amber
                                  : Colors.white,
                            ),
                            child: CustomPaint(
                              painter: StarBorderPainter(),
                              child: Container(
                                height: 400.0,
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ],
                ),
                const SizedBox(
                  height: globalMarginPadding,
                ),
                Text(
                  widget.bookData["title"],
                  style: GoogleFonts.roboto(
                      textStyle: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                ),
                Text(
                  widget.bookData["author"],
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
            FutureBuilder<Widget>(
              future:
                  FirebaseStorageService.renderBookImage(widget.bookData.id),
              builder: (BuildContext context, AsyncSnapshot<Widget> snapshot) {
                if (snapshot.hasData) {
                  return snapshot.data!;
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return const Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 1,
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
