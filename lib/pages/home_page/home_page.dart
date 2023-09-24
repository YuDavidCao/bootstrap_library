import 'package:bootstrap_library/constants.dart';
import 'package:bootstrap_library/controller/book_summary_state.dart';
import 'package:bootstrap_library/controller/user_state.dart';
import 'package:bootstrap_library/widgets/global_botton_navigation_bar.dart';
import 'package:bootstrap_library/widgets/global_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'featured_book_widget.dart';
import 'type_of_book_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<UserState>(
      builder: (context, UserState userState, child) {
        return Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(globalEdgePadding),
            child: ChangeNotifierProvider(
              create: (_) => BookSummaryState(userState.email),
              child: Consumer<BookSummaryState>(
                builder: (context, BookSummaryState bookSummaryState, child) {
                  return ListView(
                    children: [
                      GlobalSearchBar(initialText: "", performSearch: (a) {}),
                      if (bookSummaryState.featuredBook != null)
                        FeaturedBookWidget(
                            bookData: bookSummaryState.featuredBook!),
                      const SizedBox(
                        height: globalEdgePadding,
                      ),
                      ...bookSummaryState.loadedBooksummary.entries.map((e) {
                        return TypeOfBookWidget(type: e.key, bookList: e.value);
                      }).toList()
                    ],
                  );
                },
              ),
            ),
          ),
          bottomNavigationBar: const GlobalBottomAppBar(
              isSubPage: false, onPageName: "HomePage"),
          // floatingActionButton: Wrap(
          //   children: [
          //     FloatingActionButton(
          //       onPressed: () async {
          //         final ImagePicker picker = ImagePicker();
          //         XFile? img =
          //             await picker.pickImage(source: ImageSource.gallery);
          //         if (img != null && context.mounted) {
          //           await FirebaseStorageService.uploadPictureToImage(
          //               File(img.path), "Markus ZusakThe Book Thief", context);
          //         }
          //       },
          //       heroTag: null,
          //     ),
          //     const SizedBox(
          //       width: globalEdgePadding,
          //     ),
          //     FloatingActionButton(
          //       onPressed: () {
          //         // FirebaseFirestoreService.firestoreTest();
          //         FirebaseFirestoreService.uploadBookData(
          //             "Markus Zusak",
          //             "The Book Thief",
          //             "The Book Thief is a historical fiction novel by the Australian author Markus Zusak, set in Nazi Germany during World War II. Published in 2006, The Book Thief became an international bestseller and was translated into 63 languages and sold 17 million copies. It was adapted into the 2013 feature film, The Book Thief.",
          //             randtext,
          //             "Historical Fiction",
          //             context,
          //             false);
          //       },
          //       heroTag: null,
          //     )
          //   ],
          // ),
        );
      },
    );
  }
}

// String randtext = """
// By the time I was in my late teens and already a hardened science fiction reader, I had
// read many robot stories and found that they fell into two classes.
//  In the first class there was Robot-as-Menace. I don’t have to explain that overmuch. Such
// stories were a mixture of “clank-clank” and “aarghh” and “There are some things man was not
// meant to know.” After a while, they palled dreadfully and I couldn’t stand them.
//  In the second class (a much smaller one) there was Robot-as-Pathos. In such stories the
// robots were lovable and were usually put upon by cruel human beings. These charmed me. In
// late 1938 two such stories hit the stands that particularly impressed me. One was a short story by
// Eando Binder entitled “I, Robot,” about a saintly robot named Adam Link; another was a story by
// Lester del Rey, entitled “Helen O’Loy,” that touched me with its portrayal of a robot that was
// everything a loyal wife should be.
//  When, therefore, on June 10, 1939 (yes, I do keep meticulous records), I sat down to write
// my first robot story, there was no question that I fully intended to write a Robot-as-Pathos story. I
// wrote “Robbie,” about a robot nurse and a little girl and love and a prejudiced mother and a
// weak father and a broken heart and a tearful reunion. (It originally appeared under the title--one
// I hated--of “Strange Playfellow.”)
//  But something odd happened as I wrote this first story. I managed to get the dim vision
// of a robot as neither Menace nor Pathos. I began to think of robots as industrial products built by
// matter-of-fact engineers. They were built with safety features so they weren’t Menaces and they
// were fashioned for certain jobs so that no Pathos was necessarily involved.
//  As I continued to write robot stories, this notion of carefully engineered industrial robots
// permeated my stories more and more until the whole character of robot stories in serious printed
// science fiction changed--not only that of my own stories, but of just about everybody’s.
//  That made me feel good and for many years, decades even, I went about freely admitting
// that I was “the father of the modern robot story.”
//  As time went by, I made other discoveries that delighted me. I found, for instance, that
// when I used the word “robotics” to describe the study of robots, I was not using a word that
// already existed but had invented a word that had never been used before. (That was in my story
// “Runaround,” published in 1942.)
//  The word has now come into general use. There are journals and books with the word in
// the title and it is generally known in the field that I invented the term. Don’t think I’m not proud
// of that. There are not many people who have coined a useful scientific term, and although I did it
// unknowingly, I have no intention of letting anyone in the world forget it.
//  What’s more, in “Runaround” I listed my “Three Laws of Robotics” in explicit detail for
// the first time, and these, too, became famous. At least, they are quoted in and out of season, in all
// sorts of places that have nothing primarily to do with science fiction, even in general quotation
// references. And people who work in the field of artificial intelligence sometimes take occasion to
// tell me that they think the Three Laws will serve as a good guide.
//  We can go even beyond that--
//  When I wrote my robot stories I had no thought that robots would come into existence in
// my lifetime. In fact, I was certain they would not, and would have wagered vast sums that they
// would not. (At least, I would have wagered 15 cents, which is my betting limit on sure things.)
//  Yet here I am, forty-three years after I wrote my first robot story, and we do have robots.
// Indeed, we do. What’s more, they are what I envisaged them to be in a way--industrial robots,
// created by engineers to do specific jobs and with safety features built in. They are to be found in
// numerous factories, particularly in Japan, where there are automobile factories that are entirely
// roboticized. The assembly line in such places is “manned” by robots at every stage.
//  To be sure, these robots are not as intelligent as my robots are--they are not positronic;
// """;
