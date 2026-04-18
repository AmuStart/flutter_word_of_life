import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'bible_models.dart';
import 'services/bible_translation_service.dart';
import 'models/bible_translation_file.dart';

void main() {
  runApp(const BibleApp());
}

class BibleApp extends StatelessWidget {
  const BibleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bible App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const BibleHomePage(),
    );
  }
}

class BibleHomePage extends StatefulWidget {
  const BibleHomePage({super.key});
  // BibleTranslationService service = BibleTranslationService();

  // List<BibleTranslationFile> translations = [];
  // BibleTranslationFile? selectedTranslation;

  @override
  State<BibleHomePage> createState() => _BibleHomePageState();
}

class _BibleHomePageState extends State<BibleHomePage> {
  Bible? bible;

  String? selectedBook;
  int? selectedChapter;
  int? selectedVerse;

  BibleTranslationService service = BibleTranslationService();

  List<BibleTranslationFile> translations = [];
  BibleTranslationFile? selectedTranslation;


  @override
  void initState() {
    super.initState();
    // Load thedefault Bible
    loadBible();
    // Fetch available translations from GitHub
    service.fetchTranslations().then((list) {
      setState(() {
        translations = list;
      });
    });
  }

  Future<void> loadBible() async {
    final jsonString = await rootBundle.loadString("assets/bible.json");
    final jsonData = json.decode(jsonString);
    setState(() {
      bible = Bible.fromJson(jsonData);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (bible == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final books = bible!.books;

    Book? book = selectedBook != null
        ? books.firstWhere((b) => b.name == selectedBook)
        : null;

    Chapter? chapter = (book != null && selectedChapter != null)
        ? book.chapters.firstWhere((c) => c.chapter == selectedChapter)
        : null;

    Verse? verse = (chapter != null && selectedVerse != null && selectedVerse! > 0)
        ? chapter.verses.firstWhere((v) => v.verse == selectedVerse)
        : null;

    return Stack(
      children: [
        // BACKGROUND IMAGE
        Positioned.fill(
          child: Image.asset(
            'assets/images/JERUSALEM.png',
            fit: BoxFit.cover,
          ),
        ),

        // DIM LAYER
        Positioned.fill(
          child: Container(
            color: Colors.black.withOpacity(0.4),
          ),
        ),

        // MAIN UI
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(title: Text(bible!.translation)),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
                // Keep text-boxes on left top aligned to left
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // 🔹 TOP ROW: BOOK (left) + TRANSLATION (right)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // BOOK (left)
                    DropdownButton<String>(
                      hint: const Text("Select Book"),
                      value: selectedBook,
                      items: books
                          .map((b) => DropdownMenuItem(
                                value: b.name,
                                child: Text(b.name),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedBook = value;
                          selectedChapter = null;
                          selectedVerse = null;
                        });
                      },
                    ),

                    // TRANSLATION (right)
                    if (translations.isNotEmpty)
                      DropdownButton<BibleTranslationFile>(
                        hint: const Text("Select Bible Translation"),
                        value: selectedTranslation,
                        items: translations.map((file) {
                          return DropdownMenuItem(
                            value: file,
                            child: Text(file.name.replaceAll(".json", "").toUpperCase()),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedTranslation = value;
                          });
                        },
                      ),
                  ],
                ),

                // CHAPTER
                if (book != null)
                  DropdownButton<int>(
                    hint: const Text("Select Chapter"),
                    value: selectedChapter,
                    items: book.chapters
                        .map((c) => DropdownMenuItem(
                              value: c.chapter,
                              child: Text("Chapter ${c.chapter}"),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedChapter = value;
                        selectedVerse = null;
                      });
                    },
                  ),

                // VERSE
                if (chapter != null)
                  DropdownButton<int>(
                    hint: const Text("Select Verse"),
                    value: selectedVerse,
                    items: [
                      const DropdownMenuItem(
                        value: 0,
                        child: Text("All verses"),
                      ),
                      ...chapter.verses.map(
                        (v) => DropdownMenuItem(
                          value: v.verse,
                          child: Text("Verse ${v.verse}"),
                        ),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        selectedVerse = value;
                      });
                    },
                  ),

                const SizedBox(height: 20),

                if (chapter != null)
                  if (selectedVerse == 0)
                    // Show ALL verses
                    Expanded(
                      child: ScrollConfiguration(
                        // Dont allow streching on scroll up and down
                        behavior: ScrollBehavior().copyWith(overscroll: false),
                        child: ListView(
                          physics: const ClampingScrollPhysics(), // 👈 prevents stretching
                          children: chapter.allVerses
                              .map((v) => Padding(
                                    padding: const EdgeInsets.only(bottom: 8),
                                    child: Text(
                                      "${v.verse}. ${v.text}",
                                      style: const TextStyle(fontSize: 18, color: Colors.white),
                                    ),
                                  ))
                              .toList(),
                        ),
                      ),
                    )
                  else if (verse != null)
                    // Show ONE verse
                    Text(
                      verse.text,
                      style: const TextStyle(fontSize: 18, color: Colors.white),
                    ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}