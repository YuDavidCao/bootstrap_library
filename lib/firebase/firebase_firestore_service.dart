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

  static void uploadBookData(
      String author,
      String title,
      String summary,
      String fullText,
      String bookType,
      BuildContext buildContext,
      bool featured) async {
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
        "bookType": bookType,
        "totalReviewerCount": 0,
        "totalReviewPoints": 0,
        "length": fullText.split(" ").length,
        "featured": featured
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

  static Future<DocumentSnapshot> getBookSummaryById(String id) async {
    return FirebaseFirestore.instance.collection("BookSummary").doc(id).get();
  }

  static Future<DocumentSnapshot> getBookText(
      String title, String author) async {
    return FirebaseFirestore.instance
        .collection("BookContent")
        .doc("$author$title")
        .get();
  }

  static Future<String> getBookTextWidget(String title, String author) async {
    return (await getBookText(title, author))["text"];
  }

  static void addBookAsInterest(
      String title, String author, String userEmail) async {
    DocumentReference documentReference = FirebaseFirestore.instance
        .collection("User")
        .doc(userEmail)
        .collection("books")
        .doc("$author$title");
    if (!(await documentReference.get()).exists) {
      documentReference
          .set({"note": "", "rated": false, "rating": 0, "bookmark": 0});
    }
  }

  static void setBookmarkPosition(int bookmarkPosition, String title,
      String author, String userEmail) async {
    DocumentReference documentReference = FirebaseFirestore.instance
        .collection("User")
        .doc(userEmail)
        .collection("books")
        .doc("$author$title");
    if (!(await documentReference.get()).exists) {
      documentReference
          .set({"note": "", "rated": false, "rating": 0, "bookmark": bookmarkPosition});
    } else {
      documentReference.update({"bookmark": bookmarkPosition});
    }
  }

  static void setRating(
      String title, String author, int rating, String userEmail) async {
    DocumentReference userReference = FirebaseFirestore.instance
        .collection("User")
        .doc(userEmail)
        .collection("books")
        .doc("$author$title");
    DocumentReference bookreference = FirebaseFirestore.instance
        .collection("BookSummary")
        .doc("$author$title");
    if (!(await userReference.get()).exists) {
      bookreference.update({
        "totalReviewerCount": FieldValue.increment(1),
        "totalReviewPoints": FieldValue.increment(rating),
      });
      userReference
          .set({"note": "", "rated": true, "rating": rating, "bookmark": 0});
    } else {
      DocumentSnapshot documentSnapshot = await userReference.get();
      if (!documentSnapshot["rated"]) {
        bookreference.update({
          "totalReviewerCount": FieldValue.increment(1),
          "totalReviewPoints": FieldValue.increment(rating),
        });
        userReference.update({"rated": true, "rating": rating});
      } else {
        int previousRating = documentSnapshot["rating"];
        bookreference.update({
          "totalReviewPoints": FieldValue.increment(rating - previousRating),
        });
        userReference.update({"rating": rating});
      }
    }
  }

  static firestoreTest() {}
}
