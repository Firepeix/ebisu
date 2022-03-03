import 'package:hive/hive.dart';

part 'book_hive_model.g.dart';

@HiveType(typeId : 4)
class BookHiveModel extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  String chapter;

  @HiveField(3)
  String? ignoreUntil;

  BookHiveModel(this.id, this.title, this.chapter, this.ignoreUntil);
}
