import 'package:flutter/material.dart';
import '../../../models/bible_models.dart';

class BookSelector extends StatelessWidget {
  final Book? selectedBook;
  final List<Book> books;
  final ValueChanged<Book?> onChanged;

  const BookSelector({
    super.key,
    required this.selectedBook,
    required this.books,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<Book>(
      value: selectedBook,
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
        fillColor: Colors.white.withOpacity(0.08),
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
        'Select book',
        style: TextStyle(color: Colors.white70),
      ),
      items: books.map((book) {
        return DropdownMenuItem<Book>(
          value: book,
          child: Text(
            book.name,
            overflow: TextOverflow.ellipsis,
          ),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }
}