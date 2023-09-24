import 'package:bootstrap_library/controller/book_summary_state.dart';
import 'package:bootstrap_library/controller/user_state.dart';
import 'package:bootstrap_library/firebase/firebase_firestore_service.dart';
import 'package:bootstrap_library/pages/book_shelf_page/my_book_widget.dart';
import 'package:bootstrap_library/widgets/global_botton_navigation_bar.dart';
import 'package:bootstrap_library/widgets/global_logger.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BookShelfPage extends StatefulWidget {
  const BookShelfPage({super.key});

  @override
  State<BookShelfPage> createState() => _BookShelfPageState();
}

class _BookShelfPageState extends State<BookShelfPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<UserState>(
        builder: (context, UserState userState, child) {
          return ListView(
            children: [
              ...userState.books.entries.map((entry) {
                return FutureBuilder<DocumentSnapshot>(
                  future:
                      FirebaseFirestoreService.getBookSummaryById(entry.key),
                  builder: (BuildContext context,
                      AsyncSnapshot<DocumentSnapshot> snapshot) {
                    if (snapshot.hasData) {
                      return MyBookWidget(bookData: snapshot.data!);
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
                );
              }).toList()
            ],
          );
        },
      ),
      bottomNavigationBar: const GlobalBottomAppBar(
        isSubPage: false,
        onPageName: "BookShelfPage",
      ),
    );
  }
}

// import 'package:bootstrap_library/controller/book_summary_state.dart';
// import 'package:bootstrap_library/controller/user_state.dart';
// import 'package:bootstrap_library/pages/book_shelf_page/my_book_widget.dart';
// import 'package:bootstrap_library/widgets/global_botton_navigation_bar.dart';
// import 'package:bootstrap_library/widgets/global_logger.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// class BookShelfPage extends StatefulWidget {
//   const BookShelfPage({super.key});

//   @override
//   State<BookShelfPage> createState() => _BookShelfPageState();
// }

// class _BookShelfPageState extends State<BookShelfPage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Consumer<UserState>(
//         builder: (context, UserState userState, child) {
//           return ChangeNotifierProvider(
//             create: (_) => BookSummaryState(userState.email),
//             child: Consumer<BookSummaryState>(
//               builder: (context, BookSummaryState bookSummaryState, child) {
//                 return ListView(
//                   children: [
//                     ...userState.books.entries.map((entry) {
//                       GlobalLogger.log(entry.key);
//                       return MyBookWidget(
//                           bookData: Provider.of<BookSummaryState>(context,
//                                   listen: false)
//                               .booksByName[entry.key]!);
//                     }).toList()
//                   ],
//                 );
//               },
//             ),
//           );
//         },
//       ),
//       bottomNavigationBar: const GlobalBottomAppBar(
//         isSubPage: false,
//         onPageName: "BookShelfPage",
//       ),
//     );
//   }
// }
