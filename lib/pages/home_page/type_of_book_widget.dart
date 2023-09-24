import 'package:bootstrap_library/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'normal_book_widget.dart';

class TypeOfBookWidget extends StatelessWidget {
  final String type;
  final List<DocumentSnapshot> bookList;
  const TypeOfBookWidget(
      {super.key, required this.type, required this.bookList});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: globalMarginPadding,
        ),
        Text(
          type,
          style: GoogleFonts.roboto(
              textStyle: const TextStyle(fontWeight: FontWeight.bold)),
        ),
        const Divider(
          color: Colors.grey,
          thickness: 2,
        ),
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: bookList.length,
            itemBuilder: (context, index) {
              return NormalBookWidget(bookData: bookList[index]);
            },
          ),
        ),
      ],
    );
  }
}
