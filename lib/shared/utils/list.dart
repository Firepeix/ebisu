

extension ListExtension<T> on List<T> {
  void replace(int index, T item) {
    try { removeAt(index); } catch(error) {}
    insert(index, item);
  }
}