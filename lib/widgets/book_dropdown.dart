import 'package:flutter/material.dart';
import '../models/bible_models.dart';

class BookDropdown extends StatelessWidget {
  final List<Book> books;
  final String? selectedBook;
  final ValueChanged<String?> onChanged;

  const BookDropdown({
    super.key,
    required this.books,
    required this.selectedBook,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      hint: const Text("Select Book"),
      value: selectedBook,
      items: books
          .map((b) => DropdownMenuItem(
                value: b.name,
                child: Text(b.name),
              ))
          .toList(),
      onChanged: onChanged,
    );
  }
}