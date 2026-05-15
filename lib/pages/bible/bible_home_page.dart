import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../models/bible_models.dart';
import 'widgets/verse_list.dart';
import 'widgets/chapter_navigation.dart';
import 'widgets/chapter_selector.dart';
import 'widgets/book_selector.dart';

class BibleHomePage extends StatefulWidget {
  const BibleHomePage({super.key});

  @override
  State<BibleHomePage> createState() => _BibleHomePageState();
}

class _BibleHomePageState extends State<BibleHomePage> {
  Bible? bible;

  Book? selectedBook;
  int? selectedChapter;

  @override
  void initState() {
    super.initState();
    loadBible();
  }

  Future<void> loadBible() async {
    final jsonString = await rootBundle.loadString("assets/bible.json");
    final jsonData = json.decode(jsonString);

    setState(() {
      bible = Bible.fromJson(jsonData);
      // No auto-selection by default:
      // User will pick Book + Chapter using dropdowns.
    });
  }

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
    if (selectedChapter == null) return;

    final currentIndex =
        book.chapters.indexWhere((c) => c.chapter == selectedChapter);

    if (currentIndex != -1 && currentIndex < book.chapters.length - 1) {
      setState(() {
        selectedChapter = book.chapters[currentIndex + 1].chapter;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (bible == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final books = bible!.books;
    final Book? book = selectedBook;

    final chapter = (book != null && selectedChapter != null)
        ? book.chapters.firstWhere(
            (c) => c.chapter == selectedChapter,
            // Safety: if chapter not found, show first chapter (or null if no chapters)
            orElse: () => book.chapters.first,
          )
        : null;

    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            'assets/images/JERUSALEM.png',
            fit: BoxFit.cover,
          ),
        ),
        Positioned.fill(
          child: Container(
            color: Colors.black.withValues(alpha: 0.4),
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: Text(bible!.translation),
            backgroundColor: Colors.transparent,
            elevation: 0,
            foregroundColor: Colors.white,
          ),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: 
              Column(
              children: [
                // Headers
                Row(
                  children: const [
                    Expanded(
                      child: Text(
                        "Book",
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          ),
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        "Chapter",
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 4),
                
                // Book and Chapter drop-downs
                Row(
                  children: [
                    Expanded(
                      child: BookSelector(
                        selectedBook: selectedBook,
                        books: books,
                        onChanged: (book) {
                          setState(() {
                            selectedBook = book;
                            selectedChapter = 1;
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ChapterSelector(
                        selectedChapter: selectedChapter,
                        chapters: selectedBook?.chapters
                                .map((c) => c.chapter)
                                .toList() ??
                            [],
                        onChanged: (chapter) {
                          setState(() {
                            selectedChapter = chapter!;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

              // Add ends
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
                          child: VerseList(chapter: chapter),
                        ),
                        if (selectedBook != null && selectedChapter != null)
                          ChapterNavigation(
                            book: selectedBook!,
                            chapter: selectedChapter!,
                            onPrevious: () =>
                                goToPreviousChapter(selectedBook!),
                            onNext: () =>
                                goToNextChapter(selectedBook!),
                          ),
                      ],
                    ),
                ),
              ],
            )

          ),
        ),
      ],
    );
  }
}