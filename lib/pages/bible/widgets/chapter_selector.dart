import 'package:flutter/material.dart';

class ChapterSelector extends StatelessWidget {
  final int? selectedChapter;
  final List<int> chapters;
  final ValueChanged<int?> onChanged;

  const ChapterSelector({
    super.key,
    required this.selectedChapter,
    required this.chapters,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButton<int>(
      value: selectedChapter,
      isExpanded: true,
      dropdownColor: Colors.black,
      icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
      style: const TextStyle(color: Colors.white),
      underline: Container(
        height: 1,
        color: Colors.white70,
      ),
      items: chapters.map((chapter) {
        return DropdownMenuItem<int>(
          value: chapter,
          child: Text(
            '$chapter',
            style: const TextStyle(color: Colors.white),
          ),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }
}