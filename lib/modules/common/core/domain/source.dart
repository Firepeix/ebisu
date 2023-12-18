enum SourceType {
  USER,
  ESTABLISHMENT
}


class Source {
  final String id;
  final String name;
  final SourceType type;

  Source({required this.id, required this.name, required this.type});
}