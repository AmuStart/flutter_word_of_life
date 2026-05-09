import 'package:flutter/material.dart';
import '../../../models/bible_models.dart';
import 'verse_item.dart';

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
    child: ListView.builder(
      physics: const ClampingScrollPhysics(),
      itemCount: chapter.allVerses.length,
      itemBuilder: (context, index) {
        final verse = chapter.allVerses[index];
        return VerseItem(verse: verse);
      },
    ),
  );
}

}