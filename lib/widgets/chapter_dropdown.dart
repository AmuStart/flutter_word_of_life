import 'package:flutter/material.dart';
import '../models/bible_models.dart';

class ChapterDropdown extends StatelessWidget {
  final List<Chapter> chapters;
  final int? selectedChapter;
  final ValueChanged<int?> onChanged;

  const ChapterDropdown({
    super.key,
    required this.chapters,
    required this.selectedChapter,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButton<int>(
      hint: const Text("Select Chapter"),
      value: selectedChapter,
      items: chapters
          .map(
            (c) => DropdownMenuItem(
              value: c.chapter,
              child: Text("Chapter ${c.chapter}"),
            ),
          )
          .toList(),
      onChanged: onChanged,
    );
  }
}