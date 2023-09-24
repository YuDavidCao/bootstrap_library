import 'package:bootstrap_library/constants.dart';
import 'package:bootstrap_library/firebase/firebase_storage_service.dart';
import 'package:bootstrap_library/widgets/star_clipper.dart';
import 'package:bootstrap_library/widgets/start_border_painter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NormalBookWidget extends StatefulWidget {
  final DocumentSnapshot bookData;
  const NormalBookWidget({super.key, required this.bookData});

  @override
  State<NormalBookWidget> createState() => _NormalBookWidgetState();
}

class _NormalBookWidgetState extends State<NormalBookWidget> {
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
    return GestureDetector(
      onTap: () {
        Navigator.of(context)
            .pushNamed("/BookSummaryPage", arguments: [widget.bookData]);
      },
      child: Container(
        height: 200,
        width: 100,
        // decoration: BoxDecoration(
        //   border: Border.all(color: Colors.black),
        // ),
        padding: const EdgeInsets.all(globalMarginPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
            const SizedBox(
              height: globalMarginPadding,
            ),
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
            Text(
              widget.bookData["title"],
              style: GoogleFonts.roboto(
                  textStyle: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.bold)),
            ),
            Text(widget.bookData["author"]),
          ],
        ),
      ),
    );
  }
}
