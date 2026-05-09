import 'package:flutter/material.dart';
import '../../../models/bible_models.dart';

class ChapterNavigation extends StatelessWidget {
  final Book book;
  final int chapter;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  const ChapterNavigation({
    super.key,
    required this.book,
    required this.chapter,
    required this.onPrevious,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
            onPressed: onPrevious,
          ),
          Text(
            "${book.name} $chapter",
            style: const TextStyle(color: Colors.white),
          ),
          IconButton(
            icon: const Icon(
              Icons.arrow_forward_ios,
              color: Colors.white,
            ),
            onPressed: onNext,
          ),
        ],
      ),
    );
  }
}