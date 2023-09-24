import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BookSummaryState with ChangeNotifier {
  StreamSubscription<QuerySnapshot>? _subscription;
  Map<String, List<DocumentSnapshot>> _loadedBooksummary = {};

  Map<String, List<DocumentSnapshot>> get loadedBooksummary =>
      _loadedBooksummary;

  Map<String, DocumentSnapshot> _booksByName = {};

  Map<String, DocumentSnapshot> get booksByName => _booksByName;

  set booksByName(Map<String, DocumentSnapshot> value) {
    _booksByName = value;
  }

  set loadedBooksummary(Map<String, List<DocumentSnapshot>> value) {
    _loadedBooksummary = value;
  }

  DocumentSnapshot? _featuredBook;

  DocumentSnapshot? get featuredBook => _featuredBook;

  set featuredBook(DocumentSnapshot? value) {
    _featuredBook = value;
  }

  late String _currentUserEmail;

  String get currentUserEmail => _currentUserEmail;

  set currentUserEmail(String value) {
    _currentUserEmail = value;
  }

  final Query<Map<String, dynamic>> _currentQuery =
      FirebaseFirestore.instance.collection("BookSummary");

  BookSummaryState(String currentUserEmail) {
    _currentUserEmail = currentUserEmail;
    loadBook();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  void loadBook() {
    _subscription?.cancel();
    _subscription = _currentQuery.snapshots().listen((querySnapshot) {
      List<DocumentSnapshot> temp = querySnapshot.docs;
      _loadedBooksummary = {};
      for (int i = 0; i < temp.length; i++) {
        _booksByName[temp[i].id] = temp[i];
        if (temp[i]["featured"]) {
          _featuredBook = temp[i];
          continue;
        }
        if (_loadedBooksummary.containsKey(temp[i]["bookType"])) {
          _loadedBooksummary[temp[i]["bookType"]]!.add(temp[i]);
        } else {
          _loadedBooksummary[temp[i]["bookType"]] = [temp[i]];
        }
      }
      notifyListeners();
    });
  }
}
