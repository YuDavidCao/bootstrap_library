import 'package:bootstrap_library/constants.dart';
import 'package:bootstrap_library/firebase/firebase_storage_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NormalBookWidget extends StatelessWidget {
  final DocumentSnapshot bookData;
  const NormalBookWidget({super.key, required this.bookData});

  Future<Widget> renderBookImage() async {
    return Image.network(
        await FirebaseStorageService.getImageBookImageUrl(bookData.id));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        //TODO
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
              future: renderBookImage(),
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
            Text(
              bookData["title"],
              style: GoogleFonts.roboto(
                  textStyle: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.bold)),
            ),
            Text(bookData["author"]),
          ],
        ),
      ),
    );
  }
}