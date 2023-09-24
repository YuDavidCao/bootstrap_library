import 'package:bootstrap_library/constants.dart';
import 'package:bootstrap_library/controller/user_state.dart';
import 'package:bootstrap_library/firebase/firebase_firestore_service.dart';
import 'package:bootstrap_library/firebase/firebase_storage_service.dart';
import 'package:bootstrap_library/widgets/star_clipper.dart';
import 'package:bootstrap_library/widgets/start_border_painter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class BookSummaryPage extends StatefulWidget {
  final DocumentSnapshot bookData;
  const BookSummaryPage({super.key, required this.bookData});

  @override
  State<BookSummaryPage> createState() => _BookSummaryPageState();
}

class _BookSummaryPageState extends State<BookSummaryPage> {
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
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.bookData["title"]),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          FutureBuilder<Widget>(
            future: FirebaseStorageService.renderBookImage(widget.bookData.id),
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
          Padding(
            padding: const EdgeInsets.all(globalEdgePadding),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${widget.bookData['title']} · ${widget.bookData['author']}",
                  style: GoogleFonts.roboto(fontSize: 20),
                ),
                ...[1, 2, 3, 4, 5].map((int index) {
                  return GestureDetector(
                    onTap: () {
                      FirebaseFirestoreService.setRating(
                          widget.bookData['title'],
                          widget.bookData['author'],
                          index,
                          Provider.of<UserState>(context, listen: false).email);
                    },
                    child: SizedBox(
                      height: 24,
                      width: 24,
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
                    ),
                  );
                }).toList(),
              ],
            ),
          ),
          const Divider(
            indent: globalEdgePadding,
            endIndent: globalEdgePadding,
            thickness: 2,
            color: Colors.grey,
          ),
          Padding(
            padding: const EdgeInsets.all(globalEdgePadding),
            child: Text(widget.bookData["summary"]),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed("/ReadPage", arguments: [
            widget.bookData["title"],
            widget.bookData["author"],
          ]);
        },
        backgroundColor: tenUIColor,
        child: const Text(
          "Read",
          style: TextStyle(color: Colors.black),
        ),
      ),
    );
  }
}
