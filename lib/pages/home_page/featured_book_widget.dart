import 'package:bootstrap_library/constants.dart';
import 'package:bootstrap_library/firebase/firebase_storage_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FeaturedBookWidget extends StatelessWidget {
  final DocumentSnapshot bookData;
  const FeaturedBookWidget({super.key, required this.bookData});

  @override
  Widget build(BuildContext context) {
    return Stack(
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
                      bookData["title"],
                      style: GoogleFonts.roboto(
                          textStyle: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(
                      height: globalEdgePadding,
                    ),
                    Text(
                      bookData["author"],
                      style: const TextStyle(color: Colors.white),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 100,
                child: FutureBuilder<Widget>(
                  future: FirebaseStorageService.renderBookImage(bookData.id),
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
    );
  }
}
