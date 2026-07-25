import 'package:flutter/material.dart';
import '../../../models/bible_models.dart';

class VerseItem extends StatelessWidget {
  final Verse verse;

  const VerseItem({
    super.key,
    required this.verse,
  });

// Bible text details
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: Text(
        "${verse.verse}. ${verse.text}",
        style: const TextStyle(
          fontSize: 18,
          color: Colors.white,
          height: 1.5, // improves readability
        ),
      ),
    );
  }
}