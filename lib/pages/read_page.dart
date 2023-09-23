import 'package:bootstrap_library/firebase/firebase_firestore_service.dart';
import 'package:flutter/material.dart';

class ReadPage extends StatefulWidget {
  final String title;
  final String author;
  const ReadPage({super.key, required this.title, required this.author});

  @override
  State<ReadPage> createState() => _ReadPageState();
}

class _ReadPageState extends State<ReadPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          FutureBuilder<Widget>(
            future: FirebaseFirestoreService.getBookTextWidget(
                widget.title, widget.author),
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
    );
  }
}
