import 'package:ebisu/modules/scout/book/models/book.dart';
import 'package:ebisu/ui_components/chronos/time/moment.dart';
import 'package:injectable/injectable.dart';

@injectable
class BookMapper {

  BookModel fromJson(Map<String, dynamic> json) {
    final ignoreUntil = json["ignoredUntil"] == "" || json["ignoredUntil"] == null
        ? null
        : Moment.parse(json["ignoredUntil"]);


    return BookModel(
      id: json["id"],
      name: json["title"],
      chapter: BookChapter(json["lastChapterRead"]),
      ignoredUntil: ignoreUntil,
    );
  }
}