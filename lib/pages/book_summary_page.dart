import 'package:bootstrap_library/constants.dart';
import 'package:bootstrap_library/firebase/firebase_storage_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BookSummaryPage extends StatefulWidget {
  final DocumentSnapshot bookData;
  const BookSummaryPage({super.key, required this.bookData});

  @override
  State<BookSummaryPage> createState() => _BookSummaryPageState();
}

class _BookSummaryPageState extends State<BookSummaryPage> {
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
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "${widget.bookData['title']} · ${widget.bookData['author']}",
                  style: GoogleFonts.roboto(fontSize: 20),
                ),
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
          Navigator.of(context).pushNamed("/ReadPage",
              arguments: [widget.bookData["title"], widget.bookData["author"]]);
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
