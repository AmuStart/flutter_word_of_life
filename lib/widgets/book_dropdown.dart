import 'package:flutter/material.dart';
import '../models/bible_models.dart';

class BookDropdown extends StatelessWidget {
  final List<Book> books;
  final Book? selectedBook;
  final ValueChanged<Book?> onChanged;

  const BookDropdown({
    super.key,
    required this.books,
    required this.selectedBook,
    required this.onChanged,
  });


@override
Widget build(BuildContext context) {
  return DropdownButton<Book>(
    hint: const Text("Select Book"),
    value: selectedBook, // Book?
    isExpanded: true,
    items: books
        .map((b) => DropdownMenuItem<Book>(
              value: b,            // Book
              child: Text(b.name), // label
            ))
        .toList(),
    onChanged: onChanged, // ValueChanged<Book?>
  );

  }
}