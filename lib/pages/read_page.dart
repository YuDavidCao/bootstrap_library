import 'dart:async';

import 'package:bootstrap_library/constants.dart';
import 'package:bootstrap_library/controller/user_state.dart';
import 'package:bootstrap_library/firebase/firebase_firestore_service.dart';
import 'package:bootstrap_library/widgets/global_logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

class ReadPage extends StatefulWidget {
  final String title;
  final String author;

  const ReadPage({
    super.key,
    required this.title,
    required this.author,
  });

  @override
  State<ReadPage> createState() => _ReadPageState();
}

class _ReadPageState extends State<ReadPage> {
  ScrollController scrollController = ScrollController();
  bool moved = false;
  double currentPixel = 0.0;
  List<GlobalKey> keys = [];

  @override
  void initState() {
    int bookMark = (Provider.of<UserState>(context, listen: false)
            .books
            .containsKey("${widget.author}${widget.title}"))
        ? Provider.of<UserState>(context, listen: false)
            .books["${widget.author}${widget.title}"]!["bookmark"]
        : 0;
    if (bookMark != 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        scrollToBookMark(bookMark);
      });
    }
    scrollController.addListener(() {
      currentPixel = scrollController.offset;
    });
    super.initState();
  }

  @override
  void dispose() {
    FirebaseFirestoreService.addBookAsInterest(widget.title, widget.author);
    scrollController.dispose();
    super.dispose();
  }

  void scrollToBookMark(int bookmark) async {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (keys[bookmark].currentContext != null) {
        moved = true;
        Scrollable.ensureVisible(
          keys[bookmark].currentContext!,
          alignment: 0.2,
          duration: const Duration(milliseconds: 500),
        );
        timer.cancel();
      }
    });
  }

  int binarySearchForCurrentWord(double currentPixel) {
    int low = 0;
    int high = keys.length;
    int mid = 0;
    while (low < high) {
      mid = (low + (high - low) ~/ 2);
      double widgetPixel = positionEval(mid);
      if ((widgetPixel - currentPixel).abs() < 10) {
        return mid;
      } else if (currentPixel < widgetPixel) {
        high = mid;
      } else {
        low = mid + 1;
      }
    }
    return mid;
  }

  double positionEval(int widgetIndex) {
    RenderBox renderBox =
        keys[widgetIndex].currentContext?.findRenderObject() as RenderBox;
    final RenderAbstractViewport viewport =
        RenderAbstractViewport.of(renderBox);
    RenderObject? renderObject =
        keys[widgetIndex].currentContext?.findRenderObject();
    return viewport.getOffsetToReveal(renderObject!, 0.0, rect: null).offset;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            if (moved) {
              GlobalLogger.warn("called");
              FirebaseFirestoreService.setBookmarkPosition(
                  binarySearchForCurrentWord(currentPixel),
                  widget.title,
                  widget.author);
            }
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back),
        ),
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: ListView(
        controller: scrollController,
        children: [
          FutureBuilder<String>(
            future: FirebaseFirestoreService.getBookTextWidget(
                widget.title, widget.author),
            builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
              if (snapshot.hasData) {
                List<String> texts = snapshot.data!.split(" ");
                keys = List.generate(texts.length, (i) => GlobalKey());
                return Padding(
                    padding: const EdgeInsets.all(globalEdgePadding),
                    child: Wrap(
                      children: [
                        ...texts.asMap().entries.map((entry) {
                          return Text("${entry.value} ",
                              key: keys[entry.key],
                              style: const TextStyle(height: 2));
                        }).toList()
                      ],
                    ));
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
      floatingActionButton: FloatingActionButton(onPressed: () {
        print(keys[301].currentContext?.findRenderObject() as RenderBox);
      }),
    );
  }
}
