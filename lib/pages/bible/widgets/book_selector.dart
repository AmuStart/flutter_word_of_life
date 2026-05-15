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
    return DropdownButton<Book>(
      value: selectedBook,
      isExpanded: true,
      dropdownColor: Colors.black,
      icon: const Icon(Icons.arrow_drop_down, color: Colors.white), // ✅ arrow color
      style: const TextStyle(color: Colors.white), // ✅ selected text color
      underline: Container(
        height: 1,
        color: Colors.white70, // ✅ consistent underline
      ),
      items: books.map((book) {
        return DropdownMenuItem<Book>(
          value: book,
          child: Text(
            book.name,
            style: const TextStyle(color: Colors.white),
          ),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }
}