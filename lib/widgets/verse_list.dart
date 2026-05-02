import 'package:flutter/material.dart';
import '../models/bible_models.dart';

class VerseList extends StatelessWidget {
  final Chapter chapter;

  const VerseList({
    super.key,
    required this.chapter,
  });

  @override
  Widget build(BuildContext context) {
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
}