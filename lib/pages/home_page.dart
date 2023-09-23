import 'dart:io';

import 'package:bootstrap_library/constants.dart';
import 'package:bootstrap_library/controller/book_summary_state.dart';
import 'package:bootstrap_library/controller/user_state.dart';
import 'package:bootstrap_library/firebase/firebase_firestore_service.dart';
import 'package:bootstrap_library/firebase/firebase_storage_service.dart';
import 'package:bootstrap_library/widgets/global_botton_navigation_bar.dart';
import 'package:bootstrap_library/widgets/global_search_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

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
          floatingActionButton: Wrap(
            children: [
              FloatingActionButton(onPressed: () async {
                final ImagePicker picker = ImagePicker();
                XFile? img =
                    await picker.pickImage(source: ImageSource.gallery);
                if (img != null && context.mounted) {
                  await FirebaseStorageService.uploadPictureToImage(
                      File(img.path), "David111TestTitle1", context);
                }
              }),
              const SizedBox(
                width: globalEdgePadding,
              ),
              FloatingActionButton(onPressed: () {
                FirebaseFirestoreService.uploadBookData(
                    "David111",
                    "TestTitle1",
                    "TestSummary",
                    randtext,
                    "test11",
                    context,
                    false);
              })
            ],
          ),
        );
      },
    );
  }
}

class TypeOfBookWidget extends StatelessWidget {
  final String type;
  final List<DocumentSnapshot> bookList;
  const TypeOfBookWidget(
      {super.key, required this.type, required this.bookList});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: globalMarginPadding,
        ),
        Text(type),
        const Divider(
          color: Colors.grey,
          thickness: 2,
        ),
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: bookList.length,
            itemBuilder: (context, index) {
              return NormalBookWidget(bookData: bookList[index]);
            },
          ),
        ),
        const SizedBox(
          height: globalMarginPadding,
        ),
      ],
    );
  }
}

class FeaturedBookWidget extends StatelessWidget {
  final DocumentSnapshot bookData;
  const FeaturedBookWidget({super.key, required this.bookData});

  Future<Widget> renderBookImage() async {
    return Image.network(
        await FirebaseStorageService.getImageBookImageUrl(bookData.id));
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
              color: thirtyUIColor,
              borderRadius: BorderRadius.all(Radius.circular(12))),
          padding: const EdgeInsets.all(globalEdgePadding),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      bookData["title"],
                      style: GoogleFonts.roboto(
                          textStyle: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(
                      height: globalEdgePadding,
                    ),
                    Text(
                      bookData["author"],
                      style: const TextStyle(color: Colors.white),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 100,
                child: FutureBuilder<Widget>(
                  future: renderBookImage(),
                  builder:
                      (BuildContext context, AsyncSnapshot<Widget> snapshot) {
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
              ),
            ],
          ),
        ),
        Positioned(
          top: -10,
          right: -10,
          child: SizedBox(
            height: 70,
            width: 70,
            child: Image.asset("assets/featured.png"),
          ),
        )
      ],
    );
  }
}

class NormalBookWidget extends StatelessWidget {
  final DocumentSnapshot bookData;
  const NormalBookWidget({super.key, required this.bookData});

  Future<Widget> renderBookImage() async {
    return Image.network(
        await FirebaseStorageService.getImageBookImageUrl(bookData.id));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        //TODO
      },
      child: Container(
        height: 200,
        width: 100,
        // decoration: BoxDecoration(
        //   border: Border.all(color: Colors.black),
        // ),
        padding: const EdgeInsets.all(globalMarginPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FutureBuilder<Widget>(
              future: renderBookImage(),
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
            const SizedBox(
              height: globalMarginPadding,
            ),
            Text(
              bookData["title"],
              style: GoogleFonts.roboto(
                  textStyle: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.bold)),
            ),
            Text(bookData["author"]),
          ],
        ),
      ),
    );
  }
}

String randtext =
    "Piqued favour stairs it enable exeter as seeing. Remainder met improving but engrossed sincerity age. Better but length gay denied abroad are. Attachment astonished to on appearance imprudence so collecting in excellence. Tiled way blind lived whose new. The for fully had she there leave merit enjoy forth. Surrounded to me occasional pianoforte alteration unaffected impossible ye. For saw half than cold. Pretty merits waited six talked pulled you. Conduct replied off led whether any shortly why arrived adapted. Numerous ladyship so raillery humoured goodness received an. So narrow formal length my highly longer afford oh. Tall neat he make or at dull ye. In alteration insipidity impression by travelling reasonable up motionless. Of regard warmth by unable sudden garden ladies. No kept hung am size spot no. Likewise led and dissuade rejoiced welcomed husbands boy. Do listening on he suspected resembled. Water would still if to. Position boy required law moderate was may. At distant inhabit amongst by. Appetite welcomed interest the goodness boy not. Estimable education for disposing pronounce her. John size good gay plan sent old roof own. Inquietude saw understood his friendship frequently yet. Nature his marked ham wished. Whole wound wrote at whose to style in. Figure ye innate former do so we. Shutters but sir yourself provided you required his. So neither related he am do believe. Nothing but you hundred had use regular. Fat sportsmen arranging preferred can. Busy paid like is oh. Dinner our ask talent her age hardly. Neglected collected an attention listening do abilities. Letter wooded direct two men indeed income sister. Impression up admiration he by partiality is. Instantly immediate his saw one day perceived. Old blushes respect but offices hearted minutes effects. Written parties winding oh as in without on started. Residence gentleman yet preserved few convinced. Coming regret simple longer little am sister on. Do danger in to adieus ladies houses oh eldest. Gone pure late gay ham. They sigh were not find are rent. Repulsive questions contented him few extensive supported. Of remarkably thoroughly he appearance in. Supposing tolerably applauded or of be. Suffering unfeeling so objection agreeable allowance me of. Ask within entire season sex common far who family. As be valley warmth assure on. Park girl they rich hour new well way you. Face ye be me been room we sons fond. Is at purse tried jokes china ready decay an. Small its shy way had woody downs power. To denoting admitted speaking learning my exercise so in. Procured shutters mr it feelings. To or three offer house begin taken am at. As dissuade cheerful overcame so of friendly he indulged unpacked. Alteration connection to so as collecting me. Difficult in delivered extensive at direction allowance. Alteration put use diminution can considered sentiments interested discretion. An seeing feebly stairs am branch income me unable. Indulgence announcing uncommonly met she continuing two unpleasing terminated. Now busy say down the shed eyes roof paid her. Of shameless collected suspicion existence in. Share walls stuff think but the arise guest. Course suffer to do he sussex it window advice. Yet matter enable misery end extent common men should. Her indulgence but assistance favourable cultivated everything collecting. Finished her are its honoured drawings nor. Pretty see mutual thrown all not edward ten. Particular an boisterous up he reasonably frequently. Several any had enjoyed shewing studied two. Up intention remainder sportsmen behaviour ye happiness. Few again any alone style added abode ask. Nay projecting unpleasing boisterous eat discovered solicitude. Own six moments produce elderly pasture far arrival. Hold our year they ten upon. Gentleman contained so intention sweetness in on resolving.";
