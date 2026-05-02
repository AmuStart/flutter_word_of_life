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

  Book? selectedBook;
  int? selectedChapter; // if you store Chapter objects
  int? selectedVerse; // or whatever you used for verse selection

  final BibleTranslationService service = BibleTranslationService();
  List<BibleTranslationFile> translations = [];
  BibleTranslationFile? selectedTranslation;

  // === If single Verse is selected, previous / next Verse buttons are visible ===
  void goToPreviousVerse(Chapter chapter) {
    if (selectedVerse == null || selectedVerse == 0) return;

    final currentIndex = chapter.verses.indexWhere(
      (v) => v.verse == selectedVerse,
    );

    if (currentIndex > 0) {
      setState(() {
        selectedVerse = chapter.verses[currentIndex - 1].verse;
      });
    }
  }

  void goToNextVerse(Chapter chapter) {
    if (selectedVerse == null || selectedVerse == 0) return;

    final currentIndex = chapter.verses.indexWhere(
      (v) => v.verse == selectedVerse,
    );

    if (currentIndex < chapter.verses.length - 1) {
      setState(() {
        selectedVerse = chapter.verses[currentIndex + 1].verse;
      });
    }
  }

  // === If All Verses is selected, previous / next Chapter buttons are visible ===
  void goToPreviousChapter(Book book) {
    if (selectedChapter == null) return;

    final currentIndex = book.chapters.indexWhere(
      (c) => c.chapter == selectedChapter,
    );

    if (currentIndex > 0) {
      setState(() {
        selectedChapter = book.chapters[currentIndex - 1].chapter;
        selectedVerse = 0; // reset to "All verses" when chapter changes
      });
    }
  }

  void goToNextChapter(Book book) {
    if (selectedChapter == null || selectedChapter == 0) return;

    final currentIndex = book.chapters.indexWhere(
      (c) => c.chapter == selectedChapter,
    );

    if (currentIndex != -1 && currentIndex < book.chapters.length - 1) {
      setState(() {
        selectedChapter = book.chapters[currentIndex + 1].chapter;
        selectedVerse = 0;
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
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

  final books = bible!.books;
  final Book? book = selectedBook;

    final chapter = (book != null && selectedChapter != null)
        ? book.chapters.firstWhere((c) => c.chapter == selectedChapter)
        : null;

    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset('assets/images/JERUSALEM.png', fit: BoxFit.cover),
        ),
        Positioned.fill(child: Container(color: Colors.black.withValues(alpha: 0.4))),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(title: Text(bible!.translation)),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                const Text(
                  "Bible Book",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 8),

                // Book + Chapter selectors
                Row(
                  children: [
                    Expanded(
                      child: BookDropdown(
                        books: books,
                        selectedBook: selectedBook,
                        onChanged: (b) {
                          setState(() {
                            selectedBook = b;
                            selectedChapter = null;
                            selectedVerse = 0;
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ChapterDropdown(
                        chapters: selectedBook?.chapters ?? const [],
                        selectedChapter: selectedChapter,
                        onChanged: (c) {
                          setState(() {
                            selectedChapter = c;
                            selectedVerse = 0;
                          });
                        },
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                if (chapter != null)
                  VerseDropdown(
                    verses: chapter.verses,
                    selectedVerse: selectedVerse,
                    onChanged: (v) => setState(() => selectedVerse = v),
                  ),

                const SizedBox(height: 12),

                // MAIN CONTENT — always present
                Expanded(
                  child: chapter == null
                      ? const Center(
                          child: Text(
                            "Select a book and chapter",
                            style: TextStyle(color: Colors.white70),
                          ),
                        )
                      : Column(
                          children: [
                            Expanded(
                              child: VerseList(
                                chapter: chapter,
                                selectedVerse: selectedVerse,
                              ),
                            ),

                            if (selectedVerse != null && selectedVerse! > 0)
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.arrow_back_ios,
                                          color: Colors.white),
                                      onPressed: () => goToPreviousVerse(chapter),
                                    ),
                                    Text(
                                      "Verse $selectedVerse",
                                      style: const TextStyle(color: Colors.white),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.arrow_forward_ios,
                                          color: Colors.white),
                                      onPressed: () => goToNextVerse(chapter),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
