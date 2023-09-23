import 'package:flutter/material.dart';

//url https://stackoverflow.com/questions/71633268/making-a-search-bar-in-flutter

class GlobalSearchBar extends StatefulWidget {
  final Function(String) performSearch;
  final String initialText;

  const GlobalSearchBar(
      {required this.initialText, required this.performSearch, super.key});

  @override
  State<GlobalSearchBar> createState() => _GlobalSearchBarState();
}

class _GlobalSearchBarState extends State<GlobalSearchBar> {
  late TextEditingController textEditingController;

  @override
  void initState() {
    super.initState();
    textEditingController = TextEditingController(text: widget.initialText);
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
          flex: 1,
          child: TextField(
            onSubmitted: widget.performSearch,
            controller: textEditingController,
            style: const TextStyle(color: Colors.black),
            decoration: const InputDecoration(
              hintText: 'Find your book',
              border: InputBorder.none,
              hintStyle: TextStyle(color: Colors.grey, fontSize: 18),
            ),
          ),
        ),
        IconButton(
          onPressed: () {
            widget.performSearch(textEditingController.text);
          },
          icon: const Icon(
            Icons.search,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}
