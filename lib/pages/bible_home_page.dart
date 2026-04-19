import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/bible_models.dart';
import '../models/bible_translation_file.dart';
import '../services/bible_translation_service.dart';
import '../widgets/book_dropdown.dart';
import '../widgets/chapter_dropdown.dart';
import '../widgets/verse_dropdown.dart';
import '../widgets/verse_list.dart';

class BibleHomePage extends StatefulWidget {
  const BibleHomePage({super.key});

  @override
  State<BibleHomePage> createState() => _BibleHomePageState();
}

class _BibleHomePageState extends State<BibleHomePage> {
  Bible? bible;

  String? selectedBook;
  int? selectedChapter;
  int? selectedVerse;

  final BibleTranslationService service = BibleTranslationService();
  List<BibleTranslationFile> translations = [];
  BibleTranslationFile? selectedTranslation;

  // === If single Verse is selected, previous / next Verse buttons are visible ===
  void goToPreviousVerse(Chapter chapter) {
    if (selectedVerse == null || selectedVerse == 0) return;

    final currentIndex =
        chapter.verses.indexWhere((v) => v.verse == selectedVerse);

    if (currentIndex > 0) {
      setState(() {
        selectedVerse = chapter.verses[currentIndex - 1].verse;
      });
    }
  }

  void goToNextVerse(Chapter chapter) {
    if (selectedVerse == null || selectedVerse == 0) return;

    final currentIndex =
        chapter.verses.indexWhere((v) => v.verse == selectedVerse);

    if (currentIndex < chapter.verses.length - 1) {
      setState(() {
        selectedVerse = chapter.verses[currentIndex + 1].verse;
      });
    }
  }

    // === If All Verses is selected, previous / next Chapter buttons are visible ===
  void goToPreviousChapter(Book book) {
    if (selectedChapter == null) return;

    final currentIndex =
        book.chapters.indexWhere((c) => c.chapter == selectedChapter);

    if (currentIndex > 0) {
        setState(() {
          selectedChapter = book.chapters[currentIndex - 1].chapter;
        });
      }
  }

  void goToNextChapter(Book book) {
    if (selectedChapter == null || selectedChapter == 0) return;

    final currentIndex =
        book.chapters.indexWhere((v) => v.chapter == selectedChapter);

    if (currentIndex < book.chapters.length - 1) {
      setState(() {
        selectedChapter = book.chapters[currentIndex + 1].chapter;
      });
    }
  }


  @override
  void initState() {
    super.initState();
    loadBible();
    service.fetchTranslations().then((list) {
      setState(() => translations = list);
    });
  }

  Future<void> loadBible() async {
    final jsonString = await rootBundle.loadString("assets/bible.json");
    final jsonData = json.decode(jsonString);
    setState(() => bible = Bible.fromJson(jsonData));
  }

  @override
  Widget build(BuildContext context) {
    if (bible == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final books = bible!.books;
    final book = selectedBook != null
        ? books.firstWhere((b) => b.name == selectedBook)
        : null;

    final chapter = (book != null && selectedChapter != null)
        ? book.chapters.firstWhere((c) => c.chapter == selectedChapter)
        : null;

    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset('assets/images/JERUSALEM.png', fit: BoxFit.cover),
        ),
        Positioned.fill(
          child: Container(color: Colors.black.withOpacity(0.4)),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(title: Text(bible!.translation)),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 🔹 BOOK + CHAPTER ON THE SAME ROW
                Row(
                  children: [
                    Expanded(
                      child: BookDropdown(
                        books: books,
                        selectedBook: selectedBook,
                        onChanged: (value) {
                          setState(() {
                            selectedBook = value;
                            selectedChapter = null;
                            selectedVerse = null;
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    if (book != null)
                      Expanded(
                        child: ChapterDropdown(
                          chapters: book.chapters,
                          selectedChapter: selectedChapter,
                          onChanged: (value) {
                            setState(() {
                              selectedChapter = value;
                              selectedVerse = 0; // All verses
                            });
                          },
                        ),
                      ),
                  ],
                ),

                const SizedBox(height: 20),

                // ✅ CHAPTER NAVIGATION (only for All Verses selected) Next - Previous Arrows
                if (book != null && chapter != null && (selectedVerse == null || selectedVerse == 0))
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                          onPressed: () => goToPreviousChapter(book),
                        ),
                        Text(
                          "Chapter $selectedChapter",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.arrow_forward_ios, color: Colors.white),
                          onPressed: () => goToNextChapter(book),
                        ),
                      ],
                    ),
                  ),

                if (chapter != null)
                  Expanded(
                    child: Column(
                      children: [
                        // MAIN VERSE CONTENT
                        Expanded(
                          child: VerseList(
                            chapter: chapter,
                            selectedVerse: selectedVerse,
                          ),
                        ),

                        // NAVIGATION BAR (only for single verse) Next - Previous Arrows
                        if (selectedVerse != null && selectedVerse! > 0)
                          Padding (
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                IconButton(
                                  icon: const Icon(
                                    Icons.arrow_back_ios,
                                    color: Colors.white,
                                  ),
                                  onPressed: () => goToPreviousVerse(chapter),
                                ),
                                Text(
                                  "Verse $selectedVerse",
                                  style: const TextStyle(color: Colors.white),
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.arrow_forward_ios,
                                    color: Colors.white,
                                  ),
                                  onPressed: () => goToNextVerse(chapter),
                                ),          
                              ], // ✅ CLOSE children
                            ), // ✅ CLOSE Row
                          ), // ✅ CLOSE Padding
                      ], // ✅ CLOSE Column children 
                    ), // ✅ CLOSE Column
                  ), // ✅ CLOSE Expanded
              ],
            ),
          ),
        ),
      ],  
    );
  }
}
