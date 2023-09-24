import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserState with ChangeNotifier {
  StreamSubscription? _subscription;
  Map<String, DocumentSnapshot> books = {};
  User? _user = FirebaseAuth.instance.currentUser;
  String? _username;

  User? get user => _user;
  String get email => _user!.email ?? "";
  String get id => _user!.uid;
  String? get username => _username;

  set username(String? value) {
    _username = value;
  }

  UserState() {
    FirebaseAuth.instance.authStateChanges().listen((event) {
      _user = event;
      if (_user != null) {
        getUserInfo();
        reinitialize();
        notifyListeners();
      }
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  void getUserInfo() async {
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection("User")
        .doc(_user!.email)
        .get();
    if (documentSnapshot.exists) {
      username = documentSnapshot["name"];
    }
  }

  void reinitialize() {
    _subscription?.cancel();
    if (FirebaseAuth.instance.currentUser != null) {
      _subscription = FirebaseFirestore.instance
          .collection("User")
          .doc(_user!.email)
          .collection("books")
          .snapshots()
          .listen((querySnapshot) async {
        List<DocumentSnapshot> temp = querySnapshot.docs;
        books = {};
        for (int i = 0; i < temp.length; i++) {
          books[temp[i].id] = temp[i];
        }
        notifyListeners();
      });
    }
  }
}
