class BibleTranslationFile {
  final String name;
  final String downloadUrl;

  BibleTranslationFile({
    required this.name,
    required this.downloadUrl,
  });

  factory BibleTranslationFile.fromJson(Map<String, dynamic> json) {
    return BibleTranslationFile(
      name: json['name'],
      downloadUrl: json['download_url'],
    );
  }
}