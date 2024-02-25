import 'package:uuid/uuid.dart';

class Database {
  final _uuid = Uuid();

  Database._privateConstructor();

  static final Database instance = Database._privateConstructor();

  String createId() {
    return _uuid.v8();
  }
}