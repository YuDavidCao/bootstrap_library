import 'package:bootstrap_library/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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
        Text(type),
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
        const SizedBox(
          height: globalMarginPadding,
        ),
      ],
    );
  }
}
