import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FirebaseFirestoreService {
  static void addUserData(String email, String username) async {
    final CollectionReference collectionReference =
        FirebaseFirestore.instance.collection('User');
    DocumentSnapshot documentSnapshot =
        await collectionReference.doc(email).get();
    if (!documentSnapshot.exists) {
      collectionReference.doc(email).set({
        "email": email,
        "name": username,
        "readBooks": <String>[],
      });
    }
  }

  static void uploadBookData(String author, String title, String summary,
      String fullText, String bookType, BuildContext buildContext) async {
    final CollectionReference summaryCollectionReference =
        FirebaseFirestore.instance.collection('BookSummary');
    final CollectionReference textCollectionReference =
        FirebaseFirestore.instance.collection('BookContent');
    DocumentSnapshot summarySnapshot =
        await summaryCollectionReference.doc("$author$title").get();
    DocumentSnapshot textSnapshot =
        await textCollectionReference.doc("$author$title").get();
    if (summarySnapshot.exists && textSnapshot.exists) {
      if (buildContext.mounted) {
        ScaffoldMessenger.of(buildContext).showSnackBar(
            const SnackBar(content: Text('This book already exists.')));
      }
    } else if (summarySnapshot.exists || textSnapshot.exists) {
      if (buildContext.mounted) {
        ScaffoldMessenger.of(buildContext).showSnackBar(
            const SnackBar(content: Text('Server inconsistent.')));
      }
    } else {
      summaryCollectionReference.doc("$author$title").set({
        "author": author,
        "title": title,
        "summary": summary,
        "totalReviewerCount": 0,
        "totalReviewPoints": 0,
        "length": fullText.split(" ").length
      });
      textCollectionReference.doc("$author$title").set({"text": fullText});
    }
  }

  static Future<DocumentSnapshot> getBookSummary(
      String title, String author) async {
    return FirebaseFirestore.instance
        .collection("BookSummary")
        .doc("$author$title")
        .get();
  }

  static Future<DocumentSnapshot> getBookText(
      String title, String author) async {
    return FirebaseFirestore.instance
        .collection("BookContent")
        .doc("$author$title")
        .get();
  }
}
