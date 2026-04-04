class Bible {
  final String translation;
  final List<Book> books;

  Bible({required this.translation, required this.books});

  factory Bible.fromJson(Map<String, dynamic> json) {
    return Bible(
      translation: json["translation"],
      books: (json["books"] as List)
          .map((b) => Book.fromJson(b))
          .toList(),
    );
  }
}

class Book {
  final String name;
  final List<Chapter> chapters;

  Book({required this.name, required this.chapters});

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      name: json["name"],
      chapters: (json["chapters"] as List)
          .map((c) => Chapter.fromJson(c))
          .toList(),
    );
  }
}

class Chapter {
  final int chapter;
  final List<Verse> verses;

  Chapter({required this.chapter, required this.verses});

  factory Chapter.fromJson(Map<String, dynamic> json) {
    return Chapter(
      chapter: json["chapter"],
      verses: (json["verses"] as List)
          .map((v) => Verse.fromJson(v))
          .toList(),
    );
  }
}

class Verse {
  final int verse;
  final String text;

  Verse({required this.verse, required this.text});

  factory Verse.fromJson(Map<String, dynamic> json) {
    return Verse(
      verse: json["verse"],
      text: json["text"],
    );
  }
}