import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'bible_models.dart';

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

  @override
  State<BibleHomePage> createState() => _BibleHomePageState();
}

class _BibleHomePageState extends State<BibleHomePage> {
  Bible? bible;

  String? selectedBook;
  int? selectedChapter;
  int? selectedVerse;

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

    Verse? verse = (chapter != null && selectedVerse != null)
        ? chapter.verses.firstWhere((v) => v.verse == selectedVerse)
        : null;

    return Scaffold(
      appBar: AppBar(title: Text(bible!.translation)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // BOOK
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
                items: chapter.verses
                    .map((v) => DropdownMenuItem(
                          value: v.verse,
                          child: Text("Verse ${v.verse}"),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedVerse = value;
                  });
                },
              ),

            const SizedBox(height: 20),

            // DISPLAY VERSE
            if (verse != null)
              Text(
                verse.text,
                style: const TextStyle(fontSize: 18),
              ),
          ],
        ),
      ),
    );
  }
}