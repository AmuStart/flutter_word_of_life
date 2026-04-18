import 'package:flutter/material.dart';
import '../models/bible_models.dart';

class VerseList extends StatelessWidget {
  final Chapter chapter;
  final int? selectedVerse;

  const VerseList({
    super.key,
    required this.chapter,
    required this.selectedVerse,
  });

  @override
  Widget build(BuildContext context) {
    // All verses selected (0 or null)
    if (selectedVerse == null || selectedVerse == 0) {
      return ScrollConfiguration(
        behavior: ScrollBehavior().copyWith(overscroll: false),
        child: ListView(
          physics: const ClampingScrollPhysics(),
          children: chapter.allVerses
              .map(
                (v) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    "${v.verse}. ${v.text}",
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      );
    }

    // Single verse selected
    final verse = chapter.verses.firstWhere(
      (v) => v.verse == selectedVerse,
    );

    return Text(
      verse.text,
      style: const TextStyle(
        fontSize: 18,
        color: Colors.white,
      ),
    );
  }
}
