
class Let {
  static String? match<T>(Match? match, int index) {
    try {
      return match?[index];
    } catch(error) {
      print("Out of bounds");
      return null;
    }
  }
}