import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BookSummaryState with ChangeNotifier {
  StreamSubscription<QuerySnapshot>? _subscription;
  List<DocumentSnapshot> _loadedBooksummary = [];
  late String _currentUserEmail;

  String get currentUserEmail => _currentUserEmail;

  set currentUserEmail(String value) {
    _currentUserEmail = value;
  }

  final Query<Map<String, dynamic>> _currentQuery =
      FirebaseFirestore.instance.collection("BookSummary");

  List<DocumentSnapshot> get loadedBooksummary => _loadedBooksummary;

  set loadedClassroom(List<DocumentSnapshot> value) {
    _loadedBooksummary = value;
  }

  BookSummaryState(String currentUserEmail) {
    _currentUserEmail = currentUserEmail;
    loadClassroom();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  void loadClassroom() {
    _subscription?.cancel();
    _subscription = _currentQuery.snapshots().listen((querySnapshot) {
      _loadedBooksummary = querySnapshot.docs;
      notifyListeners();
    });
  }
}
