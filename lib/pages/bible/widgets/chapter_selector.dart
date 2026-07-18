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
    return DropdownButtonFormField<int>(
      value: chapters.contains(selectedChapter) ? selectedChapter : null,
      isExpanded: true,
      dropdownColor: const Color(0xFF1F1F1F),
      icon: const Icon(
        Icons.keyboard_arrow_down_rounded,
        color: Colors.white,
      ),
      style: const TextStyle(
        color: Colors.white,
        fontSize: 16,
      ),
      decoration: InputDecoration(
        isDense: true,
        filled: true,
        fillColor: Colors.grey.shade400,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 12,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Colors.white.withOpacity(0.25),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Colors.white70,
          ),
        ),
      ),
      hint: const Text(
        'Select chapter',
        style: TextStyle(color: Colors.white70),
      ),
      items: chapters.map((chapter) {
        return DropdownMenuItem<int>(
          value: chapter,
          child: Text('$chapter'),
        );
      }).toList(),
      onChanged: chapters.isEmpty ? null : onChanged,
    );
  }
}