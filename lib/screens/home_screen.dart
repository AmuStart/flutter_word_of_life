import 'package:flutter/material.dart';
import '../pages/bible/widgets/settings_menu.dart'; // adjust path
import 'package:flutter/services.dart';
import '../models/bible_models.dart';
import 'dart:convert';
import '../pages/bible/widgets/verse_list.dart';
import '../pages/bible/widgets/book_selector.dart';
import '../pages/bible/widgets/chapter_selector.dart';
import '../pages/bible/widgets/chapter_navigation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String currentTranslation = 'assets/finn_1776_bible.json';  
  
  Bible? bible; // ✅ correct place

  Book? selectedBook;
  int? selectedChapter;
  double fontSize = 14.0;

  String _backgroundImage = 'assets/images/JERUSALEM.png';
  Color? _backgroundColor;

  @override
  void initState() {
    super.initState();
    loadBible(currentTranslation);
    // loadLastLocation();
  }

  Future<void> loadBible(String path) async {
    print("📗 START loading: $path");

    try {
      final jsonString = await rootBundle.loadString(path);
      print("✅ JSON loaded, length: ${jsonString.length}");

      final sw = Stopwatch()..start();
      print("loadString: ${sw.elapsedMilliseconds} ms");

      final jsonData = jsonDecode(jsonString);
      print("JSON Data keys: ${jsonData.keys}");
      print("jsonDecode: ${sw.elapsedMilliseconds} ms");


      final booksJson = jsonData['books'];
      print("Books length: ${booksJson.length}");

      print("Translation from JSON: ${jsonData["translation"]}");

      setState(() {
        bible = Bible.fromJson(jsonData);
      });
      // RESTORING USER'S LAST SESSION BOOK / CHAPTER
      await restoreLastLocation();

      print("Bible translation: ${bible?.translation}");

      print("✅ Bible parsed: ${bible!.books.length} books");
    } catch (e) {
      print("❌ ERROR: $e");
    }
  }

Future<void> restoreLastLocation() async {
  if (bible == null) return;

  final prefs = await SharedPreferences.getInstance();

  final savedBookName = prefs.getString('lastBook');
  final savedChapter = prefs.getInt('lastChapter');

  print("📖 savedBookName=$savedBookName");
  print("📖 savedChapter=$savedChapter");

  setState(() {
    if (savedBookName == null) {
      // First launch
      selectedBook = bible!.books.first; // Genesis
      selectedChapter = 1;
    } else {
      selectedBook = bible!.books.firstWhere(
        (book) => book.name == savedBookName,
        orElse: () => bible!.books.first,
      );

      selectedChapter = savedChapter ?? 1;
    }
  });

  print(
    "📖 Restored locations: ${selectedBook?.name} $selectedChapter"
  );
}

Future<void> saveLastLocation() async {
  print("Save last location");
  final prefs = await SharedPreferences.getInstance();

  await prefs.setString(
    'lastBook',
    selectedBook?.name ?? '',
  );

  await prefs.setInt(
    'lastChapter',
    selectedChapter ?? 1,
  );

  print(
    '💾 Saved: ${selectedBook?.name} $selectedChapter'
  );
}
    
  void goToPreviousChapter(Book book) {
    if (selectedChapter == null) return;

    final currentIndex =
        book.chapters.indexWhere((c) => c.chapter == selectedChapter);

    if (currentIndex > 0) {
      setState(() {
        selectedChapter = book.chapters[currentIndex - 1].chapter;
      });
      saveLastLocation();
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
      saveLastLocation();
    }
  }

  void _showFontSizeDialog() {
    showDialog(
      context: context,
      builder: (context) {
        double tempFontSize = fontSize;
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Font Size'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Font Size: ${tempFontSize.round()}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 12),

                  Slider(
                    value: tempFontSize,
                    min: 12,
                    max: 32,
                    divisions: 20,
                    label: tempFontSize.round().toString(),
                    onChanged: (value) {
                      setDialogState(() {
                        tempFontSize = value;
                      });
                    },
                  ),

                  Text(
                    'The Lord is my shepherd',
                    style: TextStyle(
                      fontSize: tempFontSize,
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    setDialogState(() {
                      tempFontSize = 14.0;
                    });
                  },
                  child: const Text('Default'),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      fontSize = tempFontSize;
                    });
                    Navigator.pop(context);
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
        },
      );
    }
  // TODO move to new settings.dart
  void _changeTranslation() async {
    final selected = await showDialog<String>(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: const Text('Select Translation'),
          children: [
            SimpleDialogOption(
              onPressed: () => Navigator.pop(context, 'assets/finn_1776_bible.json'),
              child: const Text('Finnish 1776'),
            ),
            SimpleDialogOption(
              onPressed: () => Navigator.pop(context, 'assets/finn_1938_bible.json'),
              child: const Text('Finnish 1938'),
            ),
            SimpleDialogOption(
              onPressed: () => Navigator.pop(context, 'assets/en_kjv_1769_bible.json'),
              child: const Text('English KJV 1769'),
            ),
            SimpleDialogOption(
              onPressed: () => Navigator.pop(context, 'assets/en_niv_1978_bible.json'),
              child: const Text('English NIV 1978'),
            ),
          ],
        );
      },
    );

    if (selected != null) {
      print("Translation selected: $selected");
      setState(() {
        currentTranslation = selected;
        selectedBook = null;       // ✅ reset book
        selectedChapter = null;    // ✅ reset chapter
      });

      await loadBible(selected);
    }
  }

  void _changeTheme() async {
    final selected = await showDialog<String>(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: const Text('Select Theme'),
          children: [
            SimpleDialogOption(
              onPressed: () => Navigator.pop(
                context,
                'assets/images/JERUSALEM.png',
              ),
              child: const Text('Jerusalem'),
            ),

            SimpleDialogOption(
              onPressed: () => Navigator.pop(
                context,
                'assets/images/JESUS_riding.png',
              ),
              child: const Text('Jesus Riding'),
            ),

            SimpleDialogOption(
              onPressed: () => Navigator.pop(
                context,
                'assets/images/3_cross_modified.png',
              ),
              child: const Text('3 Cross'),
            ),            

            SimpleDialogOption(
              onPressed: () => Navigator.pop(context, 'beige'),
              child: const Text('Warm Beige'),
            ),

            SimpleDialogOption(
              onPressed: () => Navigator.pop(context, 'blue'),
              child: const Text('Warm Blue'),
            ),

            SimpleDialogOption(
              onPressed: () => Navigator.pop(context, 'green'),
              child: const Text('Warm Green'),
            ),
          ],
        );
      },
    );

    if (selected != null) {
      print("Theme selected: $selected");

      setState(() {
        if (selected == 'beige') {
          _backgroundImage = '';
          _backgroundColor = const Color(0xFFF4E2B8);

        } else if (selected == 'blue') {
          _backgroundImage = '';
          _backgroundColor = const Color(0xFFD0E8FF);

        } else if (selected == 'green') {
          _backgroundImage = '';
          _backgroundColor = const Color(0xFFCDECCB);

        } else {
          _backgroundImage = selected;
          _backgroundColor = null;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    print('=== HOME_SCREEN BUILD ===');
    print('Translation: ${bible?.translation}');
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
          child: _backgroundColor != null
              ? Container(
                  color: _backgroundColor,
                )
              : Image.asset(
                  _backgroundImage,
                  fit: BoxFit.cover,
                ),
        ),
        Positioned.fill(
          child: Container(
            color: Colors.black.withValues(alpha: 0.45),
          ),
        ),

        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Word of Life'),
                Text(
                  bible?.translation ?? '',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            actions: [
              SettingsMenu(
                onSelectBible: _changeTranslation,
                onSelectTheme: _changeTheme,
                onSelectFontSize: _showFontSizeDialog,
              ),
            ],
          ),
          body: bible == null
              ? const Center(child: CircularProgressIndicator())
              : Column(
                  children: [
                    // ✅ Keep your existing selectors
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: BookSelector(
                            selectedBook: selectedBook,
                            books: bible?.books ?? [],
                            onChanged: (book) {
                              setState(() {
                                selectedBook = book;
                                selectedChapter = 1;
                              });
                              saveLastLocation();
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ChapterSelector(
                            selectedChapter: selectedChapter,
                            chapters: selectedBook?.chapters
                                    .map((c) => c.chapter)
                                    .toList() ??
                                [],
                            onChanged: (chapter) {
                              setState(() {
                                selectedChapter = chapter;
                              });
                              saveLastLocation();
                            },
                          ),
                        ),
                      ],
                    ),

              const SizedBox(height: 16),

              // Navigation - Previous - Next
                const SizedBox(height: 16),
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
                                fontSize: fontSize,
                              ),
                            ),
                            if (selectedBook != null && selectedChapter != null)
                              ChapterNavigation(
                                book: selectedBook!,
                                chapter: selectedChapter!,
                                onPrevious: () => goToPreviousChapter(selectedBook!),
                                onNext: () => goToNextChapter(selectedBook!),
                              ),
                          ],
                        ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

