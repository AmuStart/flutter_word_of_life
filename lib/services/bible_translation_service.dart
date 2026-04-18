import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/bible_translation_file.dart';

class BibleTranslationService {
  static const String apiUrl =
      "https://api.github.com/repos/scrollmapper/bible_databases/contents/formats/json";

  Future<List<BibleTranslationFile>> fetchTranslations() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data
          .map((item) => BibleTranslationFile.fromJson(item))
          .toList();
    } else {
      throw Exception("Failed to load translations");
    }
  }
}