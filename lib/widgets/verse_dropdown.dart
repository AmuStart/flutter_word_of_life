import 'package:flutter/material.dart';
import '../models/bible_models.dart';

class VerseDropdown extends StatelessWidget {
  final List<Verse> verses;
  final int? selectedVerse;
  final ValueChanged<int?> onChanged;

  const VerseDropdown({
    super.key,
    required this.verses,
    required this.selectedVerse,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButton<int>(
      hint: const Text("Select Verse"),
      value: selectedVerse,
      items: [
        const DropdownMenuItem(
          value: 0,
          child: Text("All verses"),
        ),
        ...verses.map(
          (v) => DropdownMenuItem(
            value: v.verse,
            child: Text("Verse ${v.verse}"),
          ),
        ),
      ],
      onChanged: onChanged,
    );
  }
}