import 'package:bootstrap_library/constants.dart';
import 'package:bootstrap_library/firebase/firebase_storage_service.dart';
import 'package:bootstrap_library/widgets/star_clipper.dart';
import 'package:bootstrap_library/widgets/start_border_painter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FeaturedBookWidget extends StatefulWidget {
  final DocumentSnapshot bookData;
  const FeaturedBookWidget({super.key, required this.bookData});

  @override
  State<FeaturedBookWidget> createState() => _FeaturedBookWidgetState();
}

class _FeaturedBookWidgetState extends State<FeaturedBookWidget> {
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
      child: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
                color: thirtyUIColor,
                borderRadius: BorderRadius.all(Radius.circular(12))),
            padding: const EdgeInsets.all(globalEdgePadding),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.bookData["title"],
                        style: GoogleFonts.roboto(
                            textStyle: const TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(
                        height: globalEdgePadding,
                      ),
                      Row(
                        children: [
                          Text(
                            widget.bookData["author"],
                            style: const TextStyle(color: Colors.white),
                          ),
                          const SizedBox(
                            width: globalEdgePadding,
                          ),
                          ...[1, 2, 3, 4, 5].map((int index) {
                            return SizedBox(
                              height: 20,
                              width: 20,
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
                          }).toList()
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 100,
                  child: FutureBuilder<Widget>(
                    future: FirebaseStorageService.renderBookImage(
                        widget.bookData.id, true),
                    builder:
                        (BuildContext context, AsyncSnapshot<Widget> snapshot) {
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
                ),
              ],
            ),
          ),
          Positioned(
            top: -10,
            right: -10,
            child: SizedBox(
              height: 70,
              width: 70,
              child: Image.asset("assets/featured.png"),
            ),
          )
        ],
      ),
    );
  }
}
